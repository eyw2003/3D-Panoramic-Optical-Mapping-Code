function [MapFinalCamA2,MapFinalCamB2,MapFinalCamC2,MapFinalCamD2,MapTotal2,MapRef] = ProjectionOptMapPhaseMoviev2(SilhouetteTotal,threshold,FrameFirst,FrameLast,AxX,AxY,AxZ,TSquare,SSquare,RSquare,QSquare,OptCamAFileName,Pathname)
[a,b,c]=ind2sub(size(SilhouetteTotal),find(SilhouetteTotal));

ReconCamA = zeros(100);
ReconCamB = zeros(100);
ReconCamC = zeros(100);
ReconCamD = zeros(100);

MapTotal2 = zeros(length(AxX),length(AxY),length(AxZ),FrameLast-FrameFirst);
MapFinalCamA2 = zeros(length(AxX),length(AxY),length(AxZ),FrameLast-FrameFirst);
MapFinalCamB2 = zeros(length(AxX),length(AxY),length(AxZ),FrameLast-FrameFirst);
MapFinalCamC2 = zeros(length(AxX),length(AxY),length(AxZ),FrameLast-FrameFirst);
MapFinalCamD2 = zeros(length(AxX),length(AxY),length(AxZ),FrameLast-FrameFirst);

%% Load optical map images
PosCamName = strfind(OptCamAFileName,'A');

% Camera A
load(strcat(Pathname,OptCamAFileName));
OptMapCamAFull = PhaseMapMovie;

% Camera B
load(strcat(Pathname,OptCamAFileName(1:PosCamName-1),'B',OptCamAFileName(PosCamName+1:end)));
OptMapCamBFull = PhaseMapMovie;

% Camera C
load(strcat(Pathname,OptCamAFileName(1:PosCamName-1),'C',OptCamAFileName(PosCamName+1:end)));
OptMapCamCFull = PhaseMapMovie;


% Camera D
load(strcat(Pathname,OptCamAFileName(1:PosCamName-1),'D',OptCamAFileName(PosCamName+1:end)));
OptMapCamDFull = PhaseMapMovie;
clear PhaseMapMovie
%% Load camera images corresponding to the maps
FileNameCamera = OptCamAFileName(1:PosCamName-1);

% Camera A
if strcmp(FileNameCamera(end),'h')
    CMOSconverter(Pathname,strcat(FileNameCamera,'A')); % Convert directly from the .rsh
end
Data1 = load(strcat(Pathname,FileNameCamera,'A'));
frame = 1;
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
A3init = imadjust(A2); % Increase contrast
% Segmentation based on active contour and gray level co occurence
% matrix
mask = zeros(size(A3init));
mask(3:end-3,3:end-3) = 1;
clear SI coords X Y bwSI
[~,SI] = graycomatrix(A3init,'GrayLimits',[threshold,1]);
SI(SI~=1) = 8;
bwSI = activecontour(SI,mask,500);
A3 = A3init .* bwSI;

% Camera B
if strcmp(FileNameCamera(end),'h')
    CMOSconverter(Pathname,strcat(FileNameCamera,'B')); % Convert directly from the .rsh
end
Data2 = load(strcat(Pathname,FileNameCamera,'B'));
clear G Mframe J A
cmosData1 = double(Data2.cmosData(:,:,2:end));
bg1 = double(Data2.bgimage);
G = real2rgb(bg1, 'gray');
Mframe = cmosData1(:,:,frame);
J = real2rgb(Mframe, 'jet');
A = real2rgb(Mframe >= minVisible, 'gray');
A1 = J .* A + G .* (1-A);
A2 = rgb2gray(A1); % Made 2D
B3init = imadjust(A2); % Increase contrast
% Segmentation based on active contour and gray level co occurence
% matrix
mask = zeros(size(B3init));
mask(3:end-3,3:end-3) = 1;
clear SI coords X Y bwSI
[~,SI] = graycomatrix(B3init,'GrayLimits',[threshold,1]);
SI(SI~=1) = 8;
bwSI = activecontour(SI,mask,500);
B3 = B3init .* bwSI;

% Camera C
if strcmp(FileNameCamera(end),'h')
    CMOSconverter(Pathname,strcat(FileNameCamera,'C')); % Convert directly from the .rsh
end
Data3 = load(strcat(Pathname,FileNameCamera,'C'));
clear G Mframe J A
cmosData1 = double(Data3.cmosData(:,:,2:end));
bg1 = double(Data3.bgimage);
G = real2rgb(bg1, 'gray');
Mframe = cmosData1(:,:,frame);
J = real2rgb(Mframe, 'jet');
A = real2rgb(Mframe >= minVisible, 'gray');
A1 = J .* A + G .* (1-A);
A2 = rgb2gray(A1); % Made 2D
C3init = imadjust(A2); % Increase contrast
% Segmentation based on active contour and gray level co occurence
% matrix
mask = zeros(size(C3init));
mask(3:end-3,3:end-3) = 1;
clear SI coords X Y bwSI
[~,SI] = graycomatrix(C3init,'GrayLimits',[threshold,1]);
SI(SI~=1) = 8;
bwSI = activecontour(SI,mask,500);
C3 = C3init .* bwSI;

% Camera D
if strcmp(FileNameCamera(end),'h')
    CMOSconverter(Pathname,FileNameCamera,'D'); % Convert directly from the .rsh
end
Data4 = load(strcat(Pathname,FileNameCamera,'D'));
clear G Mframe J A
cmosData1 = double(Data4.cmosData(:,:,2:end));
bg1 = double(Data4.bgimage);
G = real2rgb(bg1, 'gray');
Mframe = cmosData1(:,:,frame);
J = real2rgb(Mframe, 'jet');
A = real2rgb(Mframe >= minVisible, 'gray');
A1 = J .* A + G .* (1-A);
A2 = rgb2gray(A1); % Made 2D
D3init = imadjust(A2); % Increase contrast
% Segmentation based on active contour and gray level co occurence
% matrix
mask = zeros(size(D3init));
mask(3:end-3,3:end-3) = 1;
clear SI coords X Y bwSI
[~,SI] = graycomatrix(D3init,'GrayLimits',[threshold,1]);
SI(SI~=1) = 8;
bwSI = activecontour(SI,mask,500);
D3 = D3init .* bwSI;


h = waitbar(0,strcat('Calculating the 3-D optical map: Frame ',num2str(FrameFirst)));
for iFrame = FrameFirst:FrameLast
    OptMapCamA = OptMapCamAFull(:,:,iFrame);
    OptMapCamB = OptMapCamBFull(:,:,iFrame);
    OptMapCamC = OptMapCamCFull(:,:,iFrame);
    OptMapCamD = OptMapCamDFull(:,:,iFrame);
    %% Pre-processing of the optical maps (what is outside of the heart on the camera is set to NaN in the optical map)
    OptMapCamA(A3==0) = NaN;
    OptMapCamB(B3==0) = NaN;
    OptMapCamC(C3==0) = NaN;
    OptMapCamD(D3==0) = NaN;
    
%     % Added by Lea on 03/26/2021 because now in 2D when generating the
%     % phase map movies we already crop the noisy backgroung
%     OptMapCamA(isnan(OptMapCamA))=0;
%     OptMapCamB(isnan(OptMapCamB))=0;
%     OptMapCamC(isnan(OptMapCamC))=0;
%     OptMapCamD(isnan(OptMapCamD))=0;

    if iFrame == FrameFirst
        fOptMap = figure;
        colormap(jet)
        subplot(221)
        imagesc(OptMapCamA)
        title('Optical Map from Cam A')
        subplot(222)
        imagesc(OptMapCamB)
        title('Optical Map from Cam B')
        subplot(223)
        imagesc(OptMapCamC)
        title('Optical Map from Cam C')
        subplot(224)
        imagesc(OptMapCamD)
        title('Optical Map from Cam D')
        
        [choiceCam,DoneIndex] = chooseCamdialog;
        while DoneIndex == 0
            switch choiceCam
                case 'CamA'
                    clear BW
                    subplot(221)
                    title('Choose the part of the map you want to keep')
                    BW = roipoly;
                    OptMapCamA = OptMapCamA.*BW;
                    imagesc(OptMapCamA)
                case 'CamB'
                    clear BW
                    subplot(222)
                    title('Choose the part of the map you want to keep')
                    BW = roipoly;
                    OptMapCamB = OptMapCamB.*BW;
                    imagesc(OptMapCamB)
                case 'CamC'
                    clear BW
                    subplot(223)
                    title('Choose the part of the map you want to keep')
                    BW = roipoly;
                    OptMapCamC = OptMapCamC.*BW;
                    imagesc(OptMapCamC)
                case 'CamD'
                    clear BW
                    subplot(224)
                    title('Choose the part of the map you want to keep')
                    BW = roipoly;
                    OptMapCamD = OptMapCamD.*BW;
                    imagesc(OptMapCamD)
            end
            [choiceCam,DoneIndex] = chooseCamdialog;
        end
    end
    %% Calculation of the virtual images: reconstructed silhouette as seen by each camera
    
    for ii = 1:length(a)
        kA = TSquare(1,3)*AxX(a(ii))+TSquare(2,3)*AxY(b(ii))+TSquare(3,3)*AxZ(c(ii))+TSquare(4,3);
        uA(ii) = round((TSquare(1,1)*AxX(a(ii))+TSquare(2,1)*AxY(b(ii))+TSquare(3,1)*AxZ(c(ii))+TSquare(4,1))/kA);
        vA(ii) = round((TSquare(1,2)*AxX(a(ii))+TSquare(2,2)*AxY(b(ii))+TSquare(3,2)*AxZ(c(ii))+TSquare(4,2))/kA);
        
        uA(ii) = uA(ii)+50;
        vA(ii) = vA(ii)+50;
        if  uA(ii) <= 0 || vA(ii) <= 0
            disp('CamA Not in view')
        else
            ReconCamA(vA(ii),uA(ii)) = 1;
        end
        
        kB = SSquare(1,3)*AxX(a(ii))+SSquare(2,3)*AxY(b(ii))+SSquare(3,3)*AxZ(c(ii))+SSquare(4,3);
        uB(ii) = round((SSquare(1,1)*AxX(a(ii))+SSquare(2,1)*AxY(b(ii))+SSquare(3,1)*AxZ(c(ii))+SSquare(4,1))/kB);
        vB(ii) = round((SSquare(1,2)*AxX(a(ii))+SSquare(2,2)*AxY(b(ii))+SSquare(3,2)*AxZ(c(ii))+SSquare(4,2))/kB);
        
        uB(ii) = uB(ii)+50;
        vB(ii) = vB(ii)+50;
        if uB(ii) <= 0 || vB(ii) <= 0
            disp('CamB Not in view')
        else
            ReconCamB(vB(ii),uB(ii)) = 1;
        end
        
        kC = RSquare(1,3)*AxX(a(ii))+RSquare(2,3)*AxY(b(ii))+RSquare(3,3)*AxZ(c(ii))+RSquare(4,3);
        uC(ii) = round((RSquare(1,1)*AxX(a(ii))+RSquare(2,1)*AxY(b(ii))+RSquare(3,1)*AxZ(c(ii))+RSquare(4,1))/kC);
        vC(ii) = round((RSquare(1,2)*AxX(a(ii))+RSquare(2,2)*AxY(b(ii))+RSquare(3,2)*AxZ(c(ii))+RSquare(4,2))/kC);
        
        uC(ii) = uC(ii)+50;
        vC(ii) = vC(ii)+50;
        if uC(ii) <= 0 || vC(ii) <= 0
            disp('CamC Not in view')
        else
            ReconCamC(vC(ii),uC(ii)) = 1;
        end
        
        kD = QSquare(1,3)*AxX(a(ii))+QSquare(2,3)*AxY(b(ii))+QSquare(3,3)*AxZ(c(ii))+QSquare(4,3);
        uD(ii) = round((QSquare(1,1)*AxX(a(ii))+QSquare(2,1)*AxY(b(ii))+QSquare(3,1)*AxZ(c(ii))+QSquare(4,1))/kD);
        vD(ii) = round((QSquare(1,2)*AxX(a(ii))+QSquare(2,2)*AxY(b(ii))+QSquare(3,2)*AxZ(c(ii))+QSquare(4,2))/kD);
        
        uD(ii) = uD(ii)+50;
        vD(ii) = vD(ii)+50;
        if uD(ii) <= 0 || vD(ii) <= 0
            disp('CamD Not in view')
        else
            ReconCamD(vD(ii),uD(ii)) = 1;
        end
    end
    %% Rough alignment and creation of virtual 2-D activation maps seen by each camera
    VirtualPropsA = regionprops(ReconCamA,'centroid');
    VirtualPropsB = regionprops(ReconCamB,'centroid');
    VirtualPropsC = regionprops(ReconCamC,'centroid');
    VirtualPropsD = regionprops(ReconCamD,'centroid');
    
%     % Added by Lea on 03/26/2021 
%     OptMapCamA(OptMapCamA==0)=NaN;
%     OptMapCamB(OptMapCamB==0)=NaN;
%     OptMapCamC(OptMapCamC==0)=NaN;
%     OptMapCamD(OptMapCamD==0)=NaN;
    
    RealAMap = zeros(size(OptMapCamA));
    RealAMap(~isnan(OptMapCamA)) = 1;
    RealBMap = zeros(size(OptMapCamB));
    RealBMap(~isnan(OptMapCamB)) = 1;
    RealCMap = zeros(size(OptMapCamC));
    RealCMap(~isnan(OptMapCamC)) = 1;
    RealDMap = zeros(size(OptMapCamD));
    RealDMap(~isnan(OptMapCamD)) = 1;
    
    RealPropsA = regionprops(RealAMap,'centroid');
    RealPropsB = regionprops(RealBMap,'centroid');
    RealPropsC = regionprops(RealCMap,'centroid');
    RealPropsD = regionprops(RealDMap,'centroid');
    
    VirtualAMap = imtranslate(ReconCamA,[RealPropsA.Centroid(1)-VirtualPropsA.Centroid(1),RealPropsA.Centroid(2)-VirtualPropsA.Centroid(2)]);
    VirtualAMap2 = zeros(size(OptMapCamA));
    [a,b] = ind2sub(size(VirtualAMap),find(VirtualAMap));
    for ii = 1:length(a)
        if a(ii) <= size(OptMapCamA,1) && a(ii) <= size(VirtualAMap2,1) && b(ii) <= size(OptMapCamA,2) && b(ii) <= size(VirtualAMap2,2)
            VirtualAMap2(a(ii),b(ii)) = OptMapCamA(a(ii),b(ii));
        end
    end
    VirtualAMap2(isnan(VirtualAMap2)) = 0;
    VirtualAMap3 = imtranslate(VirtualAMap2,[-RealPropsA.Centroid(1)+VirtualPropsA.Centroid(1),-RealPropsA.Centroid(2)+VirtualPropsA.Centroid(2)],'OutputView','Full');
    if iFrame == FrameFirst
        figA = figure;
        subplot(121)
        imagesc(OptMapCamA)
%         caxis([-max(OptMapCamA(:)) max(OptMapCamA(:))])
        caxis([min(OptMapCamA(:)) max(OptMapCamA(:))])
        title('Original activation map')
        subplot(122)
        imagesc(VirtualAMap2)
%         caxis([-max(OptMapCamA(:)) max(OptMapCamA(:))])
        caxis([min(OptMapCamA(:)) max(OptMapCamA(:))])
        title('Activation map for projection')
        pause
        close(figA)
        
        if ~exist('CentralSlice.mat')
            figA = figure;
            imagesc(VirtualAMap3)
            title('Please select a central slice of the heart')
            AxisA = roipoly;
            close(figA)
        else
            load('CentralSlice.mat');
        end
    end
    
    clear a b c
    VirtualBMap = imtranslate(ReconCamB,[RealPropsB.Centroid(1)-VirtualPropsB.Centroid(1),RealPropsB.Centroid(2)-VirtualPropsB.Centroid(2)]);
    VirtualBMap2 = zeros(size(OptMapCamB));
    [a,b] = ind2sub(size(VirtualBMap),find(VirtualBMap));
    for ii = 1:length(a)
        if a(ii) <= size(OptMapCamB,1) && a(ii) <= size(VirtualBMap2,1) && b(ii) <= size(OptMapCamB,2) && b(ii) <= size(VirtualBMap2,2)
            VirtualBMap2(a(ii),b(ii)) = OptMapCamB(a(ii),b(ii));
        end
    end
    VirtualBMap2(isnan(VirtualBMap2)) = 0;
    VirtualBMap3 = imtranslate(VirtualBMap2,[-RealPropsB.Centroid(1)+VirtualPropsB.Centroid(1),-RealPropsB.Centroid(2)+VirtualPropsB.Centroid(2)],'OutputView','Full');
    if iFrame == FrameFirst
        figB = figure;
        subplot(121)
        imagesc(OptMapCamB)
%         caxis([-max(OptMapCamB(:)) max(OptMapCamB(:))])
        caxis([min(OptMapCamB(:)) max(OptMapCamB(:))])
        title('Original activation map')
        subplot(122)
        imagesc(VirtualBMap2)
        title('Activation map for projection')
%         caxis([-max(OptMapCamB(:)) max(OptMapCamB(:))])
        caxis([min(OptMapCamB(:)) max(OptMapCamB(:))])
        pause
        close(figB)
        
        if ~exist('CentralSlice.mat')
            figB = figure;
            imagesc(VirtualBMap3)
            title('Please select a central slice of the heart')
            AxisB = roipoly;
            close(figB)
            
            % Added by Lea on 05/04/2021 to save the selection for the central slice of the heart for future processing and not have to manually redraw it everytime
            save('CentralSlice.mat','AxisB','AxisA');
        else
            load('CentralSlice.mat');
        end
    end
      
    clear a b c
    VirtualCMap = imtranslate(ReconCamC,[RealPropsC.Centroid(1)-VirtualPropsC.Centroid(1),RealPropsC.Centroid(2)-VirtualPropsC.Centroid(2)]);
    VirtualCMap2 = zeros(size(OptMapCamC));
    [a,b] = ind2sub(size(VirtualCMap),find(VirtualCMap));
    for ii = 1:length(a)
        if a(ii) <= size(OptMapCamC,1) && a(ii) <= size(VirtualCMap2,1) && b(ii) <= size(OptMapCamC,2) && b(ii) <= size(VirtualCMap2,2)
            VirtualCMap2(a(ii),b(ii)) = OptMapCamC(a(ii),b(ii));
        end
    end
    VirtualCMap2(isnan(VirtualCMap2)) = 0;
    VirtualCMap3 = imtranslate(VirtualCMap2,[-RealPropsC.Centroid(1)+VirtualPropsC.Centroid(1),-RealPropsC.Centroid(2)+VirtualPropsC.Centroid(2)],'OutputView','Full');
    if iFrame == FrameFirst
        figC = figure;
        subplot(121)
        imagesc(OptMapCamC)
%         caxis([-max(OptMapCamC(:)) max(OptMapCamC(:))])
        caxis([min(OptMapCamC(:)) max(OptMapCamC(:))])
        title('Original activation map')
        subplot(122)
        imagesc(VirtualCMap2)
        title('Activation map for projection')
%         caxis([-max(OptMapCamC(:)) max(OptMapCamC(:))])
        caxis([min(OptMapCamC(:)) max(OptMapCamC(:))])
        pause
        close(figC)        
    end
    
    clear a b c
    VirtualDMap = imtranslate(ReconCamD,[RealPropsD.Centroid(1)-VirtualPropsD.Centroid(1),RealPropsD.Centroid(2)-VirtualPropsD.Centroid(2)]);
    VirtualDMap2 = zeros(size(OptMapCamD));
    [a,b] = ind2sub(size(VirtualDMap),find(VirtualDMap));
    for ii = 1:length(a)
        if a(ii) <= size(OptMapCamD,1) && a(ii) <= size(VirtualDMap2,1) && b(ii) <= size(OptMapCamD,2) && b(ii) <= size(VirtualDMap2,2)
            VirtualDMap2(a(ii),b(ii)) = OptMapCamD(a(ii),b(ii));
        end
    end
    VirtualDMap2(isnan(VirtualDMap2)) = 0;
    VirtualDMap3 = imtranslate(VirtualDMap2,[-RealPropsD.Centroid(1)+VirtualPropsD.Centroid(1),-RealPropsD.Centroid(2)+VirtualPropsD.Centroid(2)],'OutputView','Full');
    if iFrame == FrameFirst
        figD = figure;
        subplot(121)
        imagesc(OptMapCamD)
%         caxis([-max(OptMapCamD(:)) max(OptMapCamD(:))])
        caxis([min(OptMapCamD(:)) max(OptMapCamD(:))])
        title('Original activation map')
        subplot(122)
        imagesc(VirtualDMap2)
        title('Activation map for projection')
%         caxis([-max(OptMapCamD(:)) max(OptMapCamD(:))])
        caxis([min(OptMapCamD(:)) max(OptMapCamD(:))])
        pause
        close(figD)        
    end
    %% Reconstruction of a 3-D volume using the virtual 2-D images
    [a,b,c]=ind2sub(size(SilhouetteTotal),find(SilhouetteTotal));
    Recon3DCamA = zeros(size(SilhouetteTotal));
    Recon3DCamB = zeros(size(SilhouetteTotal));
    Recon3DCamC = zeros(size(SilhouetteTotal));
    Recon3DCamD = zeros(size(SilhouetteTotal));
    Recon3DAxisA = zeros(size(SilhouetteTotal));
    Recon3DAxisB = zeros(size(SilhouetteTotal));
    Recon3DAxis = zeros(size(SilhouetteTotal));

    for ii = 1:length(a)
        kA = TSquare(1,3)*AxX(a(ii))+TSquare(2,3)*AxY(b(ii))+TSquare(3,3)*AxZ(c(ii))+TSquare(4,3);
        uA(ii) = round((TSquare(1,1)*AxX(a(ii))+TSquare(2,1)*AxY(b(ii))+TSquare(3,1)*AxZ(c(ii))+TSquare(4,1))/kA);
        vA(ii) = round((TSquare(1,2)*AxX(a(ii))+TSquare(2,2)*AxY(b(ii))+TSquare(3,2)*AxZ(c(ii))+TSquare(4,2))/kA);
        
        uA(ii) = uA(ii)+50;
        vA(ii) = vA(ii)+50;
        
        if vA(ii) < size(VirtualAMap3,1) && uA(ii) < size(VirtualAMap3,2)
            if  VirtualAMap3(vA(ii),uA(ii))~=0
                Recon3DCamA(a(ii),b(ii),c(ii)) = VirtualAMap3(vA(ii),uA(ii));
            end
            if AxisA(vA(ii),uA(ii))~=0
                Recon3DAxisA(a(ii),b(ii),c(ii)) = 1;
            end
        end
        
        kB = SSquare(1,3)*AxX(a(ii))+SSquare(2,3)*AxY(b(ii))+SSquare(3,3)*AxZ(c(ii))+SSquare(4,3);
        uB(ii) = round((SSquare(1,1)*AxX(a(ii))+SSquare(2,1)*AxY(b(ii))+SSquare(3,1)*AxZ(c(ii))+SSquare(4,1))/kB);
        vB(ii) = round((SSquare(1,2)*AxX(a(ii))+SSquare(2,2)*AxY(b(ii))+SSquare(3,2)*AxZ(c(ii))+SSquare(4,2))/kB);
        
        uB(ii) = uB(ii)+50;
        vB(ii) = vB(ii)+50;
        if vB(ii) < size(VirtualBMap3,1) && uB(ii) < size(VirtualBMap3,2)
            if  VirtualBMap3(vB(ii),uB(ii))~=0
                Recon3DCamB(a(ii),b(ii),c(ii)) = VirtualBMap3(vB(ii),uB(ii));
            end
            if AxisB(vB(ii),uB(ii))~=0
                Recon3DAxisB(a(ii),b(ii),c(ii)) = 1;
            end
        end
        
        kC = RSquare(1,3)*AxX(a(ii))+RSquare(2,3)*AxY(b(ii))+RSquare(3,3)*AxZ(c(ii))+RSquare(4,3);
        uC(ii) = round((RSquare(1,1)*AxX(a(ii))+RSquare(2,1)*AxY(b(ii))+RSquare(3,1)*AxZ(c(ii))+RSquare(4,1))/kC);
        vC(ii) = round((RSquare(1,2)*AxX(a(ii))+RSquare(2,2)*AxY(b(ii))+RSquare(3,2)*AxZ(c(ii))+RSquare(4,2))/kC);
        
        uC(ii) = uC(ii)+50;
        vC(ii) = vC(ii)+50;
        if vC(ii) < size(VirtualCMap3,1) && uC(ii) < size(VirtualCMap3,2)
            if  VirtualCMap3(vC(ii),uC(ii))~=0
                Recon3DCamC(a(ii),b(ii),c(ii)) = VirtualCMap3(vC(ii),uC(ii));
            end
        end
        
        kD = QSquare(1,3)*AxX(a(ii))+QSquare(2,3)*AxY(b(ii))+QSquare(3,3)*AxZ(c(ii))+QSquare(4,3);
        uD(ii) = round((QSquare(1,1)*AxX(a(ii))+QSquare(2,1)*AxY(b(ii))+QSquare(3,1)*AxZ(c(ii))+QSquare(4,1))/kD);
        vD(ii) = round((QSquare(1,2)*AxX(a(ii))+QSquare(2,2)*AxY(b(ii))+QSquare(3,2)*AxZ(c(ii))+QSquare(4,2))/kD);
        
        uD(ii) = uD(ii)+50;
        vD(ii) = vD(ii)+50;
        if vD(ii) < size(VirtualDMap3,1) && uD(ii) < size(VirtualDMap3,2)
            if  VirtualDMap3(vD(ii),uD(ii))~=0
                Recon3DCamD(a(ii),b(ii),c(ii)) = VirtualDMap3(vD(ii),uD(ii));
            end
        end
        if Recon3DAxisA(a(ii),b(ii),c(ii))==1 && Recon3DAxisB(a(ii),b(ii),c(ii))==1
            Recon3DAxis(a(ii),b(ii),c(ii)) = 1;
        end
    end
    %% Rotation of the created 3D maps
    
    dx = AxX(2)-AxX(1);
    dy = AxY(2)-AxY(1);
    dz = AxZ(2)-AxZ(1);
    indXZero = find(AxX>-dx/2 & AxX<dx/2);
    indYZero = find(AxY>-dy/2 & AxY<dy/2);
    indZZero = find(AxZ>-dz/2 & AxZ<dz/2);
    %% Rotation and translation of the silhouette to be at the center of the coordinate system and aligned with the z-axis
    %CamA
    clear ROTMatrix indOptMap CoordOptMap indOptMapAxis CoordOptMapAxis
    indOptMapAxis = find(Recon3DAxis);
    indOptMap = find(Recon3DCamA);
    [CoordOptMapAxis(:,1),CoordOptMapAxis(:,2),CoordOptMapAxis(:,3)] = ind2sub(size(Recon3DCamA),indOptMapAxis);
    L1 = fitLine3d(CoordOptMapAxis);
    [CoordOptMap(:,1),CoordOptMap(:,2),CoordOptMap(:,3)] = ind2sub(size(Recon3DCamB),indOptMap);
    vz = [0 0 1];
    ROTMatrix = createRotationVector3d([L1(4) L1(5) L1(6)],vz);
    CoordOptMapRot=transformPoint3d(CoordOptMap,ROTMatrix);
    OptMapRot = zeros(size(Recon3DCamA));
    for ii=1:length(indOptMap)
        if round(CoordOptMapRot(ii,1))<=0 || round(CoordOptMapRot(ii,2))<=0 || round(CoordOptMapRot(ii,3))<=0
            testCoordNeg = 0;
        else
            OptMapRot(round(CoordOptMapRot(ii,1)),round(CoordOptMapRot(ii,2)),round(CoordOptMapRot(ii,3))) = Recon3DCamA(CoordOptMap(ii,1),CoordOptMap(ii,2),CoordOptMap(ii,3));
        end
    end
    ellFitS = inertiaEllipsoid(CoordOptMapRot);
    TransMatrixS = createTranslation3d(indXZero-ellFitS(1), indYZero-ellFitS(2),indZZero-ellFitS(3));
    CoordOptMapFinal = transformPoint3d(CoordOptMapRot,TransMatrixS);
    MapRotatedCamA = zeros(size(Recon3DCamA));
    for ii=1:length(indOptMap)
        if round(CoordOptMapFinal(ii,1))<=0 || round(CoordOptMapFinal(ii,2))<=0 || round(CoordOptMapFinal(ii,3))<=0
            testCoordNeg = 0;
        else
            MapRotatedCamA(round(CoordOptMapFinal(ii,1)),round(CoordOptMapFinal(ii,2)),round(CoordOptMapFinal(ii,3))) = Recon3DCamA(CoordOptMap(ii,1),CoordOptMap(ii,2),CoordOptMap(ii,3));
        end
    end
    
    %CamB
    clear ROTMatrix indOptMap CoordOptMap indOptMapAxis CoordOptMapAxis
    indOptMapAxis = find(Recon3DAxis);
    indOptMap = find(Recon3DCamB);
    [CoordOptMap(:,1),CoordOptMap(:,2),CoordOptMap(:,3)] = ind2sub(size(Recon3DCamB),indOptMap);
    [CoordOptMapAxis(:,1),CoordOptMapAxis(:,2),CoordOptMapAxis(:,3)] = ind2sub(size(Recon3DCamB),indOptMapAxis);
    L1 = fitLine3d(CoordOptMapAxis);
    vz = [0 0 1];
    ROTMatrix = createRotationVector3d([L1(4) L1(5) L1(6)],vz);
    CoordOptMapRot=transformPoint3d(CoordOptMap,ROTMatrix);
    OptMapRot = zeros(size(Recon3DCamB));
    for ii=1:length(indOptMap)
        if round(CoordOptMapRot(ii,1))<=0 || round(CoordOptMapRot(ii,2))<=0 || round(CoordOptMapRot(ii,3))<=0
            testCoordNeg = 0;
        else
            OptMapRot(round(CoordOptMapRot(ii,1)),round(CoordOptMapRot(ii,2)),round(CoordOptMapRot(ii,3))) = Recon3DCamB(CoordOptMap(ii,1),CoordOptMap(ii,2),CoordOptMap(ii,3));
        end
    end
    ellFitS = inertiaEllipsoid(CoordOptMapRot);
    TransMatrixS = createTranslation3d(indXZero-ellFitS(1), indYZero-ellFitS(2),indZZero-ellFitS(3));
    CoordOptMapFinal = transformPoint3d(CoordOptMapRot,TransMatrixS);
    MapRotatedCamB = zeros(size(Recon3DCamB));
    for ii=1:length(indOptMap)
        if round(CoordOptMapFinal(ii,1))<=0 || round(CoordOptMapFinal(ii,2))<=0 || round(CoordOptMapFinal(ii,3))<=0
            testCoordNeg = 0;
        else
            MapRotatedCamB(round(CoordOptMapFinal(ii,1)),round(CoordOptMapFinal(ii,2)),round(CoordOptMapFinal(ii,3))) = Recon3DCamB(CoordOptMap(ii,1),CoordOptMap(ii,2),CoordOptMap(ii,3));
        end
    end
    
    %CamC
    clear ROTMatrix indOptMap CoordOptMap indOptMapAxis CoordOptMapAxis
    indOptMap = find(Recon3DCamC);
    [CoordOptMap(:,1),CoordOptMap(:,2),CoordOptMap(:,3)] = ind2sub(size(Recon3DCamC),indOptMap);
    indOptMapAxis = find(Recon3DAxis);
    [CoordOptMapAxis(:,1),CoordOptMapAxis(:,2),CoordOptMapAxis(:,3)] = ind2sub(size(Recon3DCamC),indOptMapAxis);
    L1 = fitLine3d(CoordOptMapAxis);
    vz = [0 0 1];
    ROTMatrix = createRotationVector3d([L1(4) L1(5) L1(6)],vz);
    CoordOptMapRot=transformPoint3d(CoordOptMap,ROTMatrix);
    OptMapRot = zeros(size(Recon3DCamC));
    for ii=1:length(indOptMap)
        if round(CoordOptMapRot(ii,1))<=0 || round(CoordOptMapRot(ii,2))<=0 || round(CoordOptMapRot(ii,3))<=0
            testCoordNeg = 0;
        else
            OptMapRot(round(CoordOptMapRot(ii,1)),round(CoordOptMapRot(ii,2)),round(CoordOptMapRot(ii,3))) = Recon3DCamC(CoordOptMap(ii,1),CoordOptMap(ii,2),CoordOptMap(ii,3));
        end
    end
    ellFitS = inertiaEllipsoid(CoordOptMapRot);
    TransMatrixS = createTranslation3d(indXZero-ellFitS(1), indYZero-ellFitS(2),indZZero-ellFitS(3));
    CoordOptMapFinal = transformPoint3d(CoordOptMapRot,TransMatrixS);
    MapRotatedCamC = zeros(size(Recon3DCamC));
    for ii=1:length(indOptMap)
        if round(CoordOptMapFinal(ii,1))<=0 || round(CoordOptMapFinal(ii,2))<=0 || round(CoordOptMapFinal(ii,3))<=0
            testCoordNeg = 0;
        else
            MapRotatedCamC(round(CoordOptMapFinal(ii,1)),round(CoordOptMapFinal(ii,2)),round(CoordOptMapFinal(ii,3))) = Recon3DCamC(CoordOptMap(ii,1),CoordOptMap(ii,2),CoordOptMap(ii,3));
        end
    end
    
    %CamD
    clear ROTMatrix indOptMap CoordOptMap
    indOptMap = find(Recon3DCamD);
    [CoordOptMap(:,1),CoordOptMap(:,2),CoordOptMap(:,3)] = ind2sub(size(Recon3DCamD),indOptMap);
    indOptMapAxis = find(Recon3DAxis);
    [CoordOptMapAxis(:,1),CoordOptMapAxis(:,2),CoordOptMapAxis(:,3)] = ind2sub(size(Recon3DCamD),indOptMapAxis);
    L1 = fitLine3d(CoordOptMapAxis);
    vz = [0 0 1];
    ROTMatrix = createRotationVector3d([L1(4) L1(5) L1(6)],vz);
    CoordOptMapRot=transformPoint3d(CoordOptMap,ROTMatrix);
    OptMapRot = zeros(size(Recon3DCamD));
    for ii=1:length(indOptMap)
        if round(CoordOptMapRot(ii,1))<=0 || round(CoordOptMapRot(ii,2))<=0 || round(CoordOptMapRot(ii,3))<=0
            testCoordNeg = 0;
        else
            OptMapRot(round(CoordOptMapRot(ii,1)),round(CoordOptMapRot(ii,2)),round(CoordOptMapRot(ii,3))) = Recon3DCamD(CoordOptMap(ii,1),CoordOptMap(ii,2),CoordOptMap(ii,3));
        end
    end
    ellFitS = inertiaEllipsoid(CoordOptMapRot);
    TransMatrixS = createTranslation3d(indXZero-ellFitS(1), indYZero-ellFitS(2),indZZero-ellFitS(3));
    CoordOptMapFinal = transformPoint3d(CoordOptMapRot,TransMatrixS);
    MapRotatedCamD = zeros(size(Recon3DCamD));
    for ii=1:length(indOptMap)
        if round(CoordOptMapFinal(ii,1))<=0 || round(CoordOptMapFinal(ii,2))<=0 || round(CoordOptMapFinal(ii,3))<=0
            testCoordNeg = 0;
        else
            MapRotatedCamD(round(CoordOptMapFinal(ii,1)),round(CoordOptMapFinal(ii,2)),round(CoordOptMapFinal(ii,3))) = Recon3DCamD(CoordOptMap(ii,1),CoordOptMap(ii,2),CoordOptMap(ii,3));
        end
    end
    %% Rotation of the volumes around z to be aligned with the x, y axes of the volume
    if iFrame == FrameFirst
        FigMapRot = figure;
        for ii = 1:size(MapRotatedCamA,3)
            imagesc(MapRotatedCamA(:,:,ii))
            colormap(jet)
            caxis([-max(max(MapRotatedCamA(:,:,ii))) max(max(MapRotatedCamA(:,:,ii)))]);
            title(ii)
            pause(0.1)
        end
        imagesc(MapRotatedCamA(:,:,round(ii/2)))
        title('Please select the symmetry axis of this section')
        CorrectAxis = 0;
        while CorrectAxis == 0
            [xAxRot2Cam,yAxRot2Cam] = ginput(2);
            PAxRot2 = polyfit(xAxRot2Cam,yAxRot2Cam,1);
            PDispAxRot2 = polyval(PAxRot2,[1:1:size(MapRotatedCamA,2)]);
            hold on
            plot([1:1:size(MapRotatedCamA,2)],PDispAxRot2,'r')
            AngRot2 = atand((PDispAxRot2(end)-PDispAxRot2(1))/(size(MapRotatedCamA,2)-1));
            [CorrectAxis] = chooseCorrectAxisdialog;
        end
        close(FigMapRot)
        
        FigMapRot2 = figure;
        for ii = 1:size(MapRotatedCamA,3)
            MapRotatedCamA2(:,:,ii) = imrotate(MapRotatedCamA(:,:,ii),AngRot2,'nearest','crop');
            MapRotatedCamB2(:,:,ii) = imrotate(MapRotatedCamB(:,:,ii),AngRot2,'nearest','crop');
            MapRotatedCamC2(:,:,ii) = imrotate(MapRotatedCamC(:,:,ii),AngRot2,'nearest','crop');
            MapRotatedCamD2(:,:,ii) = imrotate(MapRotatedCamD(:,:,ii),AngRot2,'nearest','crop');
            subplot(121)
            imagesc(MapRotatedCamA(:,:,ii))
            colormap(jet)
            caxis([-max(max(MapRotatedCamA(:,:,ii))) max(max(MapRotatedCamA(:,:,ii)))]);
            subplot(122)
            imagesc(MapRotatedCamA2(:,:,ii))
            colormap(jet)
            caxis([-max(max(MapRotatedCamA(:,:,ii))) max(max(MapRotatedCamA(:,:,ii)))]);
            title(ii)
            pause(0.1)
        end
        close(FigMapRot2)
    else
        for ii = 1:size(MapRotatedCamA,3)
            MapRotatedCamA2(:,:,ii) = imrotate(MapRotatedCamA(:,:,ii),AngRot2,'nearest','crop');
            MapRotatedCamB2(:,:,ii) = imrotate(MapRotatedCamB(:,:,ii),AngRot2,'nearest','crop');
            MapRotatedCamC2(:,:,ii) = imrotate(MapRotatedCamC(:,:,ii),AngRot2,'nearest','crop');
            MapRotatedCamD2(:,:,ii) = imrotate(MapRotatedCamD(:,:,ii),AngRot2,'nearest','crop');           
        end
    end
%% Cropping of the 3D matrices to select only the heart face in front of each camera
    MapFinalCamA = zeros(size(MapRotatedCamA));
    MapFinalCamB = zeros(size(MapRotatedCamA));
    MapFinalCamC = zeros(size(MapRotatedCamA));
    MapFinalCamD = zeros(size(MapRotatedCamA));
    MapTotal = zeros(size(MapRotatedCamA));
    MapRef = zeros(size(MapRotatedCamA));
    for ii = 1:size(MapRotatedCamA,3)
        for jj = 1:size(MapRotatedCamA,1)
            [~,indA] = find(MapRotatedCamA2(jj,:,ii),1,'first');
            [~,indC] = find(MapRotatedCamC2(jj,:,ii),1,'last');
            if jj == 1
                indAPrev = 0;
                indCPrev = 0;
            end
            if ~isempty(indA) & abs(indA-indAPrev)<5
                MapFinalCamA(jj-3:jj+3,indA-3:indA+3,ii) = MapRotatedCamA2(jj-3:jj+3,indA-3:indA+3,ii);
            end
            if ~isempty(indC) & abs(indC-indCPrev)<5
                MapFinalCamC(jj-3:jj+3,indC-3:indC+3,ii) = MapRotatedCamC2(jj-3:jj+3,indC-3:indC+3,ii);
            end
            indAPrev = indA;
            indCPrev = indC;
        end
        for kk = 1:size(MapRotatedCamA,2)
            [indD,~] = find(MapRotatedCamD(:,kk,ii),1,'last');
            [indB,~] = find(MapRotatedCamB(:,kk,ii),1,'first');
            if kk == 1
                indBPrev = 0;
                indDPrev = 0;
            end
            if ~isempty(indD) & abs(indD-indDPrev)<5
                MapFinalCamD(indD-3:indD+3,kk-3:kk+3,ii) = MapRotatedCamD2(indD-3:indD+3,kk-3:kk+3,ii);
            end
            if ~isempty(indB) & abs(indB-indBPrev)<5
                MapFinalCamB(indB-3:indB+3,kk-3:kk+3,ii) = MapRotatedCamB2(indB-3:indB+3,kk-3:kk+3,ii);
            end            
            indBPrev = indB;
            indDPrev = indD;
        end
    end
    [xA,yA,zA] = ind2sub(size(MapFinalCamA),find(MapFinalCamA));
    ACoord = table(xA,yA,zA);
    ACoord.Properties.VariableNames{1} = 'x';
    ACoord.Properties.VariableNames{2} = 'y';
    ACoord.Properties.VariableNames{3} = 'z';
    [xB,yB,zB] = ind2sub(size(MapFinalCamB),find(MapFinalCamB));
    BCoord = table(xB,yB,zB);
    BCoord.Properties.VariableNames{1} = 'x';
    BCoord.Properties.VariableNames{2} = 'y';
    BCoord.Properties.VariableNames{3} = 'z';
    [xC,yC,zC] = ind2sub(size(MapFinalCamC),find(MapFinalCamC));
    CCoord = table(xC,yC,zC);
    CCoord.Properties.VariableNames{1} = 'x';
    CCoord.Properties.VariableNames{2} = 'y';
    CCoord.Properties.VariableNames{3} = 'z';
    [xD,yD,zD] = ind2sub(size(MapFinalCamD),find(MapFinalCamD));
    DCoord = table(xD,yD,zD);
    DCoord.Properties.VariableNames{1} = 'x';
    DCoord.Properties.VariableNames{2} = 'y';
    DCoord.Properties.VariableNames{3} = 'z';
    ComparisonAB = ismember(ACoord,BCoord);
    ComparisonAC = ismember(ACoord,CCoord);
    ComparisonAD = ismember(ACoord,DCoord);
    
    ComparisonBA = ismember(BCoord,ACoord);
    ComparisonBC = ismember(BCoord,CCoord);
    ComparisonBD = ismember(BCoord,DCoord);
    
    ComparisonCA = ismember(CCoord,ACoord);
    ComparisonCB = ismember(CCoord,BCoord);
    ComparisonCD = ismember(CCoord,DCoord);
    
    ComparisonDA = ismember(DCoord,ACoord);
    ComparisonDB = ismember(DCoord,BCoord);
    ComparisonDC = ismember(DCoord,CCoord);
    
    indCompAB = find(ComparisonAB);
    indCompAC = find(ComparisonAC);
    indCompAD = find(ComparisonAD);
    
    indCompBC = find(ComparisonBC);
    indCompBD = find(ComparisonBD);
    
    indCompCD = find(ComparisonCD);
    
    for ii = 1:length(indCompAB)
        MapTotal(ACoord{indCompAB(ii),1},ACoord{indCompAB(ii),2},ACoord{indCompAB(ii),3}) = mean([MapFinalCamA(ACoord{indCompAB(ii),1},ACoord{indCompAB(ii),2},ACoord{indCompAB(ii),3}) MapFinalCamB(ACoord{indCompAB(ii),1},ACoord{indCompAB(ii),2},ACoord{indCompAB(ii),3})]);
        MapRef(ACoord{indCompAB(ii),1},ACoord{indCompAB(ii),2},ACoord{indCompAB(ii),3}) = 5;
    end
    for ii = 1:length(indCompAC)
        MapTotal(ACoord{indCompAC(ii),1},ACoord{indCompAC(ii),2},ACoord{indCompAC(ii),3}) = mean([MapFinalCamA(ACoord{indCompAC(ii),1},ACoord{indCompAC(ii),2},ACoord{indCompAC(ii),3}) MapFinalCamC(ACoord{indCompAC(ii),1},ACoord{indCompAC(ii),2},ACoord{indCompAC(ii),3})]);
        MapRef(ACoord{indCompAC(ii),1},ACoord{indCompAC(ii),2},ACoord{indCompAC(ii),3}) = 5;%6;
    end
    for ii = 1:length(indCompAD)
        MapTotal(ACoord{indCompAD(ii),1},ACoord{indCompAD(ii),2},ACoord{indCompAD(ii),3}) = mean([MapFinalCamA(ACoord{indCompAD(ii),1},ACoord{indCompAD(ii),2},ACoord{indCompAD(ii),3}) MapFinalCamD(ACoord{indCompAD(ii),1},ACoord{indCompAD(ii),2},ACoord{indCompAD(ii),3})]);
        MapRef(ACoord{indCompAD(ii),1},ACoord{indCompAD(ii),2},ACoord{indCompAD(ii),3}) = 5;%7;
    end
    
    ComparisonReverseA = ComparisonAB+ComparisonAC+ComparisonAD;
    indAOnly = find(ComparisonReverseA==0);
    for ii = 1:length(indAOnly)
        MapTotal(ACoord{indAOnly(ii),1},ACoord{indAOnly(ii),2},ACoord{indAOnly(ii),3}) = MapFinalCamA(ACoord{indAOnly(ii),1},ACoord{indAOnly(ii),2},ACoord{indAOnly(ii),3});
        MapRef(ACoord{indAOnly(ii),1},ACoord{indAOnly(ii),2},ACoord{indAOnly(ii),3}) = 1;
    end
    
    for ii = 1:length(indCompBC)
        MapTotal(BCoord{indCompBC(ii),1},BCoord{indCompBC(ii),2},BCoord{indCompBC(ii),3}) = mean([MapFinalCamB(BCoord{indCompBC(ii),1},BCoord{indCompBC(ii),2},BCoord{indCompBC(ii),3}) MapFinalCamC(BCoord{indCompBC(ii),1},BCoord{indCompBC(ii),2},BCoord{indCompBC(ii),3})]);
        MapRef(BCoord{indCompBC(ii),1},BCoord{indCompBC(ii),2},BCoord{indCompBC(ii),3}) = 5;%8;
    end
    for ii = 1:length(indCompBD)
        MapTotal(BCoord{indCompBD(ii),1},BCoord{indCompBD(ii),2},BCoord{indCompBD(ii),3}) = mean([MapFinalCamB(BCoord{indCompBD(ii),1},BCoord{indCompBD(ii),2},BCoord{indCompBD(ii),3}) MapFinalCamD(BCoord{indCompBD(ii),1},BCoord{indCompBD(ii),2},BCoord{indCompBD(ii),3})]);
        MapRef(BCoord{indCompBD(ii),1},BCoord{indCompBD(ii),2},BCoord{indCompBD(ii),3}) = 5;%9;
    end
    
    ComparisonReverseB = ComparisonBA+ComparisonBC+ComparisonBD;
    indBOnly = find(ComparisonReverseB==0);
    for ii = 1:length(indBOnly)
        MapTotal(BCoord{indBOnly(ii),1},BCoord{indBOnly(ii),2},BCoord{indBOnly(ii),3}) = MapFinalCamB(BCoord{indBOnly(ii),1},BCoord{indBOnly(ii),2},BCoord{indBOnly(ii),3});
        MapRef(BCoord{indBOnly(ii),1},BCoord{indBOnly(ii),2},BCoord{indBOnly(ii),3}) = 2;
    end
    
    for ii = 1:length(indCompCD)
        MapTotal(CCoord{indCompCD(ii),1},CCoord{indCompCD(ii),2},CCoord{indCompCD(ii),3}) = mean([MapFinalCamC(CCoord{indCompCD(ii),1},CCoord{indCompCD(ii),2},CCoord{indCompCD(ii),3}) MapFinalCamD(CCoord{indCompCD(ii),1},CCoord{indCompCD(ii),2},CCoord{indCompCD(ii),3})]);
        MapRef(CCoord{indCompCD(ii),1},CCoord{indCompCD(ii),2},CCoord{indCompCD(ii),3}) = 5;%10;
    end
    
    ComparisonReverseC = ComparisonCA+ComparisonCB+ComparisonCD;
    indCOnly = find(ComparisonReverseC==0);
    for ii = 1:length(indCOnly)
        MapTotal(CCoord{indCOnly(ii),1},CCoord{indCOnly(ii),2},CCoord{indCOnly(ii),3}) = MapFinalCamC(CCoord{indCOnly(ii),1},CCoord{indCOnly(ii),2},CCoord{indCOnly(ii),3});
        MapRef(CCoord{indCOnly(ii),1},CCoord{indCOnly(ii),2},CCoord{indCOnly(ii),3}) = 3;
    end
    
    ComparisonReverseD = ComparisonDA+ComparisonDB+ComparisonDC;
    indDOnly = find(ComparisonReverseD==0);
    for ii = 1:length(indDOnly)
        MapTotal(DCoord{indDOnly(ii),1},DCoord{indDOnly(ii),2},DCoord{indDOnly(ii),3}) = MapFinalCamD(DCoord{indDOnly(ii),1},DCoord{indDOnly(ii),2},DCoord{indDOnly(ii),3});
        MapRef(DCoord{indDOnly(ii),1},DCoord{indDOnly(ii),2},DCoord{indDOnly(ii),3}) = 4;
    end
    MapTotal2(:,:,:,iFrame-FrameFirst+1) = MapTotal;
    MapFinalCamA2(:,:,:,iFrame-FrameFirst+1) = MapFinalCamA;
    MapFinalCamB2(:,:,:,iFrame-FrameFirst+1) = MapFinalCamB;
    MapFinalCamC2(:,:,:,iFrame-FrameFirst+1) = MapFinalCamC;
    MapFinalCamD2(:,:,:,iFrame-FrameFirst+1) = MapFinalCamD;
    
    waitbar((iFrame-FrameFirst+1)/(FrameLast-FrameFirst),h,strcat('Projecting the 3-D optical map onto the silhouette: Frame ',num2str(iFrame+1)))
end
MapTotal2 = MapTotal2.*100;
% MapTotal2(MapTotal2==0) = -1000;
% MapFinalCamA2(MapFinalCamA2==0) = -1000;
% MapFinalCamB2(MapFinalCamB2==0) = -1000;
% MapFinalCamC2(MapFinalCamC2==0) = -1000;
% MapFinalCamD2(MapFinalCamD2==0) = -1000;