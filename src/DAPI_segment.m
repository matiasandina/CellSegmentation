%% 2D cell segmentation for confocal images
%% Specialized for DAPI (blue channel)

% Feed the array after reading .tif images

function [out] = DAPI_segment(img, plotMe)


if length(size(img)) == 3
    
% We have RGB in this case
% No need to plot, hence 0

[~, ~, blue] = split_RGB(img, 0);

else
    
    % If we have only one channel
    blue = img;
    
end

%% Segmentation for the blue channel

% median filter
% Prior to the application of any binarization algorithm, the image is
% processed with a median filter to reduce noise while trying to preserve edges
% apply [3, 3] median filter, plotMe == 0

median_filtered = my_medfilt2(blue, 3, 3, 0);

% Adjusting Contrast Level

clahe = adapthisteq(median_filtered);                

% Borders might be problematic
% We might want to also remove any values at the borders
% instead of the above line, run the line below

% clahe = imclearborder(adapthisteq(median_filtered));                    


% Adaptive Wiener Filtering 
wie_filt = wiener2(clahe,[5 5]); 

% Thresholding by Otsu's Method and binarization
BW = imbinarize(wie_filt, graythresh(wie_filt));

% Morphological Processing

bw2 = imfill(BW, 'holes');                             
bw3 = imopen(bw2, strel('disk',2));  

% We will filter using area
% Threshold needs to be verified

% check for area threshold
% area_bw3 = regionprops('table', bw3, 'Area');
% histogram(area_bw, 5000)

% We want to get rid of debris but not too many cells
% Keep everything greater than threshold
bw4 = bwareaopen(bw3, 30);           


% Get perimeter of binary mask
bw4_perim = bwperim(bw4);                      

% Find local maxima. plotMe = 0

maxs = find_local_maxima(wie_filt, 0);

% invert wiener filter
% This image has background as max value and signal as min value

inverted_wie = imcomplement(wie_filt);

% Create mask:
% Anything that is negative on bw4 (background)
% OR anything that is on maxs

masked_blobs = ~bw4 | maxs;

% We assign the values in masked_blobs to the inverted_wie image
% Effectively, this puts the background back to zero
% It also puts the maxima to zero for watershed

imposed_min = imimposemin(inverted_wie, masked_blobs);

% Watershed Segmentation function
L = watershed(imposed_min);                                                 

% If want to visualize the labelling
% labeledImage = label2rgb(L);
% figure, imshow(labeledImage), title('labeledImage')

% Get the properties of the cells

cell_props = regionprops(L);

% Get centroids (they are burried in a struct in a classic bullshit format from MATLAB)

centroids = cell2mat({cell_props.Centroid}');
centroids = table(centroids(:,1), centroids(:,2), 'VariableNames', {'x', 'y'});


%% Count
% Now that we have the watershed image, we can count using bwconncomp
% bwconncomp counts **connected** regions

cc = bwconncomp(L);
cells_per_unit_area = cc.NumObjects / (size(L,1)*size(L,2));


%% find centroids and add missing cells

% manually add centroids of cells missed by the segmentation
% [x, y] = getpts;
% addedcent = [x,y]; %store the new centroids
%add something to delete centroids as well

% adding manually gets fucked up because of the zoom

%% Ploting for debug/thresholding

if plotMe
   
    figure, imshow(BW), title('BW image')

    figure, imshow(bw4_perim), title('bw4_perim')

    % First Overlay function
    overlay1 = imoverlay(wie_filt, bw4_perim, [1 .3 .3]);              
    figure; imshow(overlay1), title('Wiener Filter with shape borders') 
    
    % Imposed min figure
    figure, imshow(imposed_min), title('Imposed min')
        
    % Second overlay, show perimeter and maxs in red ([1 .3 .3])
    
    overlay2 = imoverlay(wie_filt, bw4_perim | maxs, [1 .3 .3]); 
    figure, imshow(overlay2), title('Perimeter and local maxima')
    
    % Show image with detected centroids

    imshow(blue); hold on; plot(centroids.x, centroids.y, 'rx')

end

%% Get the stuff out and exit

out.blue = blue;
out.wie_filt = wie_filt;
out.cell_props = cell_props;
out.centroids = centroids;
out.cc = cc;
out.cells_per_unit_area = cells_per_unit_area;
out.L = L;

end
