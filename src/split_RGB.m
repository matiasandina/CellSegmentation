%% Split RGB
% This function takes an image in RGB and splits the channels

function [red, green, blue] = split_RGB(RGB, plotMe)

% split the channels
red = RGB(:,:,1);
green = RGB(:,:,2);
blue = RGB(:,:,3);

    if plotMe
        subplot(1, 4, 1)
        imshow(red)
        title('Red channel')
        subplot(1, 4, 2)
        imshow(green)
        title('Green channel')
        subplot(1, 4, 3)
        imshow(blue)
        title('Blue channel')
        subplot(1, 4, 4)
        imshow(RGB)
        title('Original Image')

% The render is horrible because matlab sucks...Improve alberto

    end
    
% Add saveMe alberto?    

end