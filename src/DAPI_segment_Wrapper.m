
myfiles = list_files('Dirname', 'sample_img', 'Fullpath', true);

 

for ii=1:length(myfiles)

[~, name, ~] = fileparts(myfiles{ii});

    
img = imread(myfiles{ii});    


qq = DAPI_segment(img, 0);

save(strcat(name, '.mat'), '-struct', 'qq')

end
