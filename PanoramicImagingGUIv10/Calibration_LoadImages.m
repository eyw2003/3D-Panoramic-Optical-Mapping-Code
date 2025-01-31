function [MaskA,cmosData1] = Calibration_LoadImages(userimage,dirimage,camview,frame)
% Calibration_LoadImages.m

% Inputs: Photo that user wants to use for calibration as m file
% (userimage), camera ID as number 1-4 (camview) that photo was taken from
% index number of frame to process (frame)
% Outputs: Image with masks


%% Convert or load the 4 sets of data
% Load data from the mat file (already converted data)
filename1_Cal = userimage;

%% Display of the calibration data
if strcmp(filename1_Cal(end),'h')
    CMOSconverter(dirimage,filename1_Cal); % Convert directly from the .rsh    
    Data1 = load(strcat(dirimage,'\',filename1_Cal(1:end-3)));
elseif strcmp(filename1_Cal(end),'t')
    Data1 = load(strcat(dirimage,filename1_Cal));
end

minVisible = 6;
hFig=figure;
clear G Mframe J A
cmosData1 = double(Data1.cmosData(:,:,2:end));
bg1 = double(Data1.bgimage);
G = real2rgb(bg1, 'gray');
Mframe = cmosData1(:,:,frame);
J = real2rgb(Mframe, 'jet');
A = real2rgb(Mframe >= minVisible, 'gray');
A1 = J .* A + G .* (1-A);
A2 = rgb2gray(A1); % Made 2D
A3 = imadjust(A2); % Increase contrast
imshow(A3);
% 
axA = gca;
axA.Units = 'pixels';
posA = axA.Position;
rectA = [0,0, posA(3), posA(4)];

CameraA = getframe(axA,rectA);
[MaskA, map] = frame2im(CameraA);

image(MaskA)
close(hFig)
