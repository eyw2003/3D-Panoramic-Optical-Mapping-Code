function FitRod = CalculateAxisRotation(filename,pathname,TSquare,SSquare,RSquare,QSquare,axesImage,handlesText,AxX,AxY,AxZ)

% Calculate the axis of rotation of the heart using a manual segmentation
% of the rod performed by the operator on the initial images.

% Inputs: TSquare,SSquare,RSquare and QSquare are the calibration matrices
%         to go from 2-D to 3-D space.
%         filename is the filename of the first acquisition with the cam A
%         axesImage is the name of the figure where to display the images
%         to segment.
%         AxX, AxY, AxZ are the axes of the virtual box surrounding the
%         heart

PosCamAName = strfind(filename,'A');

RotationAxis = 0.1*ones(length(AxX),length(AxY),length(AxZ));

%% Load images
% Camera A
Data1 = load(strcat(pathname,filename(1:PosCamAName-1),'A'));
frame = 200;
minVisible = 6;
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
%      figure(1), imagesc(A3),pause,
axes(axesImage);
imagesc(A3)
colormap(parula)
set(handlesText,'String','Please select the rod/axis of rotation of the heart for Cam A.');
BWAxisA = roipoly;

% Camera B
Data2 = load(strcat(pathname,filename(1:PosCamAName-1),'B'));
frame = 200;
minVisible = 6;
clear G Mframe J A
cmosData1 = double(Data2.cmosData(:,:,2:end));
bg1 = double(Data2.bgimage);
G = real2rgb(bg1, 'gray');
Mframe = cmosData1(:,:,frame);
J = real2rgb(Mframe, 'jet');
A = real2rgb(Mframe >= minVisible, 'gray');
A1 = J .* A + G .* (1-A);
A2 = rgb2gray(A1); % Made 2D
B3 = imadjust(A2); % Increase contrast
axes(axesImage);
imagesc(B3)
colormap(parula)
set(handlesText,'String','Please select the rod/axis of rotation of the heart for Cam B.');
BWAxisB = roipoly;

% Camera C
Data3 = load(strcat(pathname,filename(1:PosCamAName-1),'C'));
frame = 200;
minVisible = 6;
clear G Mframe J A
cmosData1 = double(Data3.cmosData(:,:,2:end));
bg1 = double(Data3.bgimage);
G = real2rgb(bg1, 'gray');
Mframe = cmosData1(:,:,frame);
J = real2rgb(Mframe, 'jet');
A = real2rgb(Mframe >= minVisible, 'gray');
A1 = J .* A + G .* (1-A);
A2 = rgb2gray(A1); % Made 2D
C3 = imadjust(A2); % Increase contrast
%     figure(1), imagesc(C3)
axes(axesImage);
imagesc(C3)
colormap(parula)
set(handlesText,'String','Please select the rod/axis of rotation of the heart for Cam C.');
BWAxisC = roipoly;

% Camera D
Data4 = load(strcat(pathname,filename(1:PosCamAName-1),'D'));
frame = 200;
minVisible = 6;
clear G Mframe J A
cmosData1 = double(Data4.cmosData(:,:,2:end));
bg1 = double(Data4.bgimage);
G = real2rgb(bg1, 'gray');
Mframe = cmosData1(:,:,frame);
J = real2rgb(Mframe, 'jet');
A = real2rgb(Mframe >= minVisible, 'gray');
A1 = J .* A + G .* (1-A);
A2 = rgb2gray(A1); % Made 2D
D3 = imadjust(A2); % Increase contrast
%     figure(1), imagesc(D3)
axes(axesImage);
imagesc(D3)
colormap(parula)
set(handlesText,'String','Please select the rod/axis of rotation of the heart for Cam D.');
BWAxisD = roipoly;

%% Calculate the 3-D position of the selected rod
h = waitbar(0,'Calculating the 3-D silhouette of the axis of rotation');
for ii = 1:length(AxX)
    for jj = 1:length(AxY)
        for kk = 1:length(AxZ)
            kA = TSquare(1,3)*AxX(ii)+TSquare(2,3)*AxY(jj)+TSquare(3,3)*AxZ(kk)+TSquare(4,3);
            uA = round((TSquare(1,1)*AxX(ii)+TSquare(2,1)*AxY(jj)+TSquare(3,1)*AxZ(kk)+TSquare(4,1))/kA);
            vA = round((TSquare(1,2)*AxX(ii)+TSquare(2,2)*AxY(jj)+TSquare(3,2)*AxZ(kk)+TSquare(4,2))/kA);
            
            if uA > size(A3,1) || vA > size(A3,2) || uA <= 0 || vA <= 0
                RotationAxis(ii,jj,kk) = 0;
            else
                if BWAxisA(vA,uA) > 0 && RotationAxis(ii,jj,kk)~=0
                    RotationAxis(ii,jj,kk) = 1;
                else
                    RotationAxis(ii,jj,kk) = 0;
                end
            end
            
            kB = SSquare(1,3)*AxX(ii)+SSquare(2,3)*AxY(jj)+SSquare(3,3)*AxZ(kk)+SSquare(4,3);
            uB = round((SSquare(1,1)*AxX(ii)+SSquare(2,1)*AxY(jj)+SSquare(3,1)*AxZ(kk)+SSquare(4,1))/kB);
            vB = round((SSquare(1,2)*AxX(ii)+SSquare(2,2)*AxY(jj)+SSquare(3,2)*AxZ(kk)+SSquare(4,2))/kB);
            
            if uB > size(B3,1) || vB > size(B3,2) || uB <= 0 || vB <= 0
                RotationAxis(ii,jj,kk) = 0;
            else
                if BWAxisB(vB,uB) > 0 && RotationAxis(ii,jj,kk)~=0
                    RotationAxis(ii,jj,kk) = 1;
                else
                    RotationAxis(ii,jj,kk) = 0;
                end
            end
            
            kC = RSquare(1,3)*AxX(ii)+RSquare(2,3)*AxY(jj)+RSquare(3,3)*AxZ(kk)+RSquare(4,3);
            uC = round((RSquare(1,1)*AxX(ii)+RSquare(2,1)*AxY(jj)+RSquare(3,1)*AxZ(kk)+RSquare(4,1))/kC);
            vC = round((RSquare(1,2)*AxX(ii)+RSquare(2,2)*AxY(jj)+RSquare(3,2)*AxZ(kk)+RSquare(4,2))/kC);
            
            if uC > size(C3,1) || vC > size(C3,2) || uC <= 0 || vC <= 0
                RotationAxis(ii,jj,kk) = 0;
            else
                if BWAxisC(vC,uC) > 0 && RotationAxis(ii,jj,kk)~=0
                    RotationAxis(ii,jj,kk) = 1;
                else
                    RotationAxis(ii,jj,kk) = 0;
                end
            end
            
            kD = QSquare(1,3)*AxX(ii)+QSquare(2,3)*AxY(jj)+QSquare(3,3)*AxZ(kk)+QSquare(4,3);
            uD = round((QSquare(1,1)*AxX(ii)+QSquare(2,1)*AxY(jj)+QSquare(3,1)*AxZ(kk)+QSquare(4,1))/kD);
            vD = round((QSquare(1,2)*AxX(ii)+QSquare(2,2)*AxY(jj)+QSquare(3,2)*AxZ(kk)+QSquare(4,2))/kD);
            
            if uD > size(D3,1) || vD > size(D3,2) || uD <= 0 || vD <= 0
                RotationAxis(ii,jj,kk) = 0;
            else
                if BWAxisD(vD,uD) > 0 && RotationAxis(ii,jj,kk)~=0
                    RotationAxis(ii,jj,kk) = 1;
                else
                    RotationAxis(ii,jj,kk) = 0;
                end
            end
        end
    end
    waitbar(ii/length(AxX),h);
end

close(h)
RotationAxis(RotationAxis==0.1) = 0;
indRod = find(RotationAxis);
[CoordRod(:,1),CoordRod(:,2),CoordRod(:,3)] = ind2sub(size(RotationAxis),indRod);
FitRod = fitLine3d(CoordRod);
