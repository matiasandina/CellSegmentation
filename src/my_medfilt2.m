%% Median filter plus plot

function [median_filtered] = my_medfilt2(img, M, N, plotMe)

% Filter with [M N]
median_filtered = medfilt2(img, [M N]);

    if plotMe
    % Plot
    figure('Name','Global binarization');
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    
    subplot(1,2,1);
    imshow(img); title('Input image');
    
    subplot(1,2,2);
    imshow(median_filtered);
    title('After median filter')
    end

end
