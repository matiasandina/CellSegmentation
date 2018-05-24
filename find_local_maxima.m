%% Find Local Maxima
% This function takes a binary bw and finds maxima
% Thresholds are image dependent...improve

function [maxs] = find_local_maxima(bw, plotMe)

%  Extending the maxima for cell nuclei
%  Some erosion/dilation and filtering of small things was added 

    % First detection and processing
    maxs_1 = imextendedmax(bw,  5);                                        
    maxs_2 = imclose(maxs_1, strel('disk',3));
    maxs_3 = imfill(maxs_2, 'holes');
    
    % Final object
    maxs = bwareaopen(maxs_3, 1);
    
if plotMe

    subplot(2,2,1)
    imshow(maxs_1); title('Local Maxima');

    subplot(2,2,2)
    imshow(maxs_2); title('After disk strel');

    subplot(2,2,3)
    imshow(maxs_3); title('Fill holes');

    subplot(2,2,4)
    imshow(maxs); title('Final. Remove very small areas');

end

end