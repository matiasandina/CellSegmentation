%% Code for registrating microscopy images to atlas

%% Load the images

microscopy = imread('micro.bmp');
atlas = imread('bregma072.png');

%% Registrate

% 1) Open the control point selection window and select matching features
% close the window when it's done
[movingPoints, fixedPoints] = cpselect(microscopy, atlas,'Wait',true);

method = 'similarity'; %shapes in the moving image are unchanged, but the image is distorted by
%some combination of translation, rotation, and scaling (and possibly reflection).
%Straight lines remain straight,and parallel lines are still parallel.

tform = fitgeotrans(movingPoints, fixedPoints, method);
micro_registered = imwarp(microscopy, tform, 'interp', 'nearest', 'OutputView', imref2d(size(atlas)));

% plot and compare difference 
figure, imshowpair(atlas, micro_registered)