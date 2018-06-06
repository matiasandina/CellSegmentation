%% ReadNikon
function [fg, red, farred] = ReadNikon(filename, is_stack) 

if (~isdir('bfmatlab'))
error('add bfmatlab to path')
end

% Open one image
img = bfopen(filename);

% We assume 3 channels



if is_stack

    % Get number of planes
    
    num_planes = size(img{1,1}, 1)/3;
    
    % Make the big stacks
    fg = cell(num_planes, 1);
    red = fg;
    farred = fg;
    
    % split the channels
    counter = 1;
       
    for ii = 1:3:size(img{1,1},1) - 2
               
        fg{counter, 1} = img{1,1}{ii,1};
        red{counter, 1} = img{1,1}{ii+1, 1};
        farred{counter, 1} = img{1,1}{ii+2, 1};
    
        counter = counter + 1;
        
    end
    
        
else
    
% The important stuff will be in {1,1}
% We will use generic names (except for fluorogold, fg)

fg = img{1,1}{1};
red = img{1,1}{2};
farred = img{1,1}{3};


end