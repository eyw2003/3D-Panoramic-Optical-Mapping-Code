  

....    36890-5  % Code to convert .rsh camera images into .mat format by batch
% Written by Lea Melki 11/18/2020

% BE CAREFUL!!! Make sure your current folder in Matlab is the one where the images are stored before running thay script

[filenames, folder] = uigetfile('*.rsh','Select camera images in .rsh you want to convert into .mat format','Multiselect','on');
for i=1:length(filenames)
    cmosData = CMOSconverter(folder,filenames{i});
end
disp('Done converting')

 
