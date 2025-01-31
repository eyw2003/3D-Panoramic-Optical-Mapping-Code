function OptMapRef = PreprocessProjectionOptMapRef(OptCamAFileName,Pathname,Threshold,TSquare,SSquare,RSquare,QSquare,AxX,AxY,AxZ)
h = waitbar(0,strcat('Calculating the ref 3-D optical map'));
OptMapRef = zeros(length(AxX),length(AxY),length(AxZ));
OptMapIndex = 0.1*ones(length(AxX),length(AxY),length(AxZ));

%% Load optical map images
% Camera A
load(strcat(Pathname,OptCamAFileName));
if ~isempty(strfind(OptCamAFileName,'ActivationMap'))
    OptMapCamA = Actmap;
    TypeOptMap = 'ActivMap';
end
if ~isempty(strfind(OptCamAFileName,'DomFreqMap'))
    OptMapCamA = DomFreqMap;
    TypeOptMap = 'DomFrMap';
end
if ~isempty(strfind(OptCamAFileName,'APDMap'))
    OptMapCamA = APDmap;
    TypeOptMap = 'APDurMap';
end
if ~isempty(strfind(OptCamAFileName,'PhaseMapMovie'))
    OptMapCamA = PhaseMapMovie;
    TypeOptMap = 'PhaseMap';
end
PosCamName = strfind(OptCamAFileName,'A');

% Camera B
load(strcat(Pathname,OptCamAFileName(1:PosCamName-1),'B',OptCamAFileName(PosCamName+1:end)));
switch TypeOptMap
    case 'ActivMap'
        OptMapCamB = Actmap;
    case 'DomFrMap'
        OptMapCamB = DomFreqMap;
    case 'APDurMap'
        OptMapCamB = APDmap;
    case 'PhaseMap'
        OptMapCamB = PhaseMapMovie;
end

% Camera C
load(strcat(Pathname,OptCamAFileName(1:PosCamName-1),'C',OptCamAFileName(PosCamName+1:end)));
switch TypeOptMap
    case 'ActivMap'
        OptMapCamC = Actmap;
    case 'DomFrMap'
        OptMapCamC = DomFreqMap;
    case 'APDurMap'
        OptMapCamC = APDmap;
    case 'PhaseMap'        
        OptMapCamC = PhaseMapMovie;
end

% Camera D
load(strcat(Pathname,OptCamAFileName(1:PosCamName-1),'D',OptCamAFileName(PosCamName+1:end)));
switch TypeOptMap
    case 'ActivMap'
        OptMapCamD = Actmap;
    case 'DomFrMap'
        OptMapCamD = DomFreqMap;
    case 'APDurMap'
        OptMapCamD = APDmap;
    case 'PhaseMap'
        OptMapCamD = PhaseMapMovie;
end

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
A3 = imadjust(A2); % Increase contrast

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
B3 = imadjust(A2); % Increase contrast

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
C3 = imadjust(A2); % Increase contrast

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
D3 = imadjust(A2); % Increase contrast

%% Pre-processing of the optical maps (what is outside of the heart on the camera is set to NaN in the optical map)
OptMapCamA(A3<=Threshold) = NaN;
OptMapCamB(B3<=Threshold) = NaN;
OptMapCamC(C3<=Threshold) = NaN;
OptMapCamD(D3<=Threshold) = NaN;

%% Creation of the 3D optical map using the optical maps from Cam A, B, C and D
%

%     % For test (to see if the different faces are projected correctly)
switch TypeOptMap
    case 'PhaseMap'
        OptMapCamA(OptMapCamA~=0) = 1;
        OptMapCamB(OptMapCamB~=0) = 2;
        OptMapCamC(OptMapCamC~=0) = 3;
        OptMapCamD(OptMapCamD~=0) = 4;
    otherwise
        OptMapCamA(OptMapCamA>0) = 1;
        OptMapCamB(OptMapCamB>0) = 2;
        OptMapCamC(OptMapCamC>0) = 3;
        OptMapCamD(OptMapCamD>0) = 4;
end

uA = zeros(length(AxX),length(AxY),length(AxZ));
vA = zeros(length(AxX),length(AxY),length(AxZ));
uB = zeros(length(AxX),length(AxY),length(AxZ));
vB = zeros(length(AxX),length(AxY),length(AxZ));
uC = zeros(length(AxX),length(AxY),length(AxZ));
vC = zeros(length(AxX),length(AxY),length(AxZ));
uD = zeros(length(AxX),length(AxY),length(AxZ));
vD = zeros(length(AxX),length(AxY),length(AxZ));
for ii = 1:length(AxX)
    for jj = 1:length(AxY)
        for kk = 1:length(AxZ)
            kA = TSquare(1,3)*AxX(ii)+TSquare(2,3)*AxY(jj)+TSquare(3,3)*AxZ(kk)+TSquare(4,3);
            uA(ii,jj,kk) = round((TSquare(1,1)*AxX(ii)+TSquare(2,1)*AxY(jj)+TSquare(3,1)*AxZ(kk)+TSquare(4,1))/kA);
            vA(ii,jj,kk) = round((TSquare(1,2)*AxX(ii)+TSquare(2,2)*AxY(jj)+TSquare(3,2)*AxZ(kk)+TSquare(4,2))/kA);
            
            if uA(ii,jj,kk) > size(A3,1) || vA(ii,jj,kk) > size(A3,2) || uA(ii,jj,kk) <= 0 || vA(ii,jj,kk) <= 0
                OptMapIndex(ii,jj,kk) = 0;
            else
                if A3(vA(ii,jj,kk),uA(ii,jj,kk)) > Threshold && OptMapIndex(ii,jj,kk)~=0
                    OptMapIndex(ii,jj,kk) = 1;
                else
                    OptMapIndex(ii,jj,kk) = 0;
                end
            end
            
            kB = SSquare(1,3)*AxX(ii)+SSquare(2,3)*AxY(jj)+SSquare(3,3)*AxZ(kk)+SSquare(4,3);
            uB(ii,jj,kk) = round((SSquare(1,1)*AxX(ii)+SSquare(2,1)*AxY(jj)+SSquare(3,1)*AxZ(kk)+SSquare(4,1))/kB);
            vB(ii,jj,kk) = round((SSquare(1,2)*AxX(ii)+SSquare(2,2)*AxY(jj)+SSquare(3,2)*AxZ(kk)+SSquare(4,2))/kB);
            
            if uB(ii,jj,kk) > size(B3,1) || vB(ii,jj,kk) > size(B3,2) || uB(ii,jj,kk) <= 0 || vB(ii,jj,kk) <= 0
                OptMapIndex(ii,jj,kk) = 0;
            else
                if B3(vB(ii,jj,kk),uB(ii,jj,kk)) > Threshold && OptMapIndex(ii,jj,kk)~=0
                    OptMapIndex(ii,jj,kk) = 1;
                else
                    OptMapIndex(ii,jj,kk) = 0;
                end
            end
            
            kC = RSquare(1,3)*AxX(ii)+RSquare(2,3)*AxY(jj)+RSquare(3,3)*AxZ(kk)+RSquare(4,3);
            uC(ii,jj,kk) = round((RSquare(1,1)*AxX(ii)+RSquare(2,1)*AxY(jj)+RSquare(3,1)*AxZ(kk)+RSquare(4,1))/kC);
            vC(ii,jj,kk) = round((RSquare(1,2)*AxX(ii)+RSquare(2,2)*AxY(jj)+RSquare(3,2)*AxZ(kk)+RSquare(4,2))/kC);
            
            if uC(ii,jj,kk) > size(C3,1) || vC(ii,jj,kk) > size(C3,2) || uC(ii,jj,kk) <= 0 || vC(ii,jj,kk) <= 0
                OptMapIndex(ii,jj,kk) = 0;
            else
                if C3(vC(ii,jj,kk),uC(ii,jj,kk)) > Threshold && OptMapIndex(ii,jj,kk)~=0
                    OptMapIndex(ii,jj,kk) = 1;
                else
                    OptMapIndex(ii,jj,kk) = 0;
                end
            end
            
            kD = QSquare(1,3)*AxX(ii)+QSquare(2,3)*AxY(jj)+QSquare(3,3)*AxZ(kk)+QSquare(4,3);
            uD(ii,jj,kk) = round((QSquare(1,1)*AxX(ii)+QSquare(2,1)*AxY(jj)+QSquare(3,1)*AxZ(kk)+QSquare(4,1))/kD);
            vD(ii,jj,kk) = round((QSquare(1,2)*AxX(ii)+QSquare(2,2)*AxY(jj)+QSquare(3,2)*AxZ(kk)+QSquare(4,2))/kD);
            
            if uD(ii,jj,kk) > size(D3,1) || vD(ii,jj,kk) > size(D3,2) || uD(ii,jj,kk) <= 0 || vD(ii,jj,kk) <= 0
                OptMapIndex(ii,jj,kk) = 0;
            else
                if D3(vD(ii,jj,kk),uD(ii,jj,kk)) > Threshold && OptMapIndex(ii,jj,kk)~=0
                    OptMapIndex(ii,jj,kk) = 1;
                else
                    OptMapIndex(ii,jj,kk) = 0;
                end
            end
        end
    end
end

% Rotation and translations of the optical map to be aligned with the
% vertical axis (so we can easily study it slice by slice)
indMap = find(OptMapIndex);
[CoordMap(:,1),CoordMap(:,2),CoordMap(:,3)] = ind2sub(size(OptMapIndex),indMap);
ellFit1 = inertiaEllipsoid(CoordMap);

dx = AxX(2)-AxX(1);
dy = AxY(2)-AxY(1);
dz = AxZ(2)-AxZ(1);
indXZero = find(AxX>-dx/2 & AxX<dx/2);
indYZero = find(AxY>-dy/2 & AxY<dy/2);
indZZero = find(AxZ>-dz/2 & AxZ<dz/2);

TransMatrix = createTranslation3d(indXZero-ellFit1(1), indYZero-ellFit1(2),indZZero-ellFit1(3));
CoordMapTrans = transformPoint3d(CoordMap,TransMatrix);
OptMapTrans1 = zeros(size(OptMapRef));
for ii=1:length(indMap)
    if round(CoordMapTrans(ii,1))<=0 || round(CoordMapTrans(ii,2))<=0 || round(CoordMapTrans(ii,3))<=0
    else
        OptMapTrans1(round(CoordMapTrans(ii,1)),round(CoordMapTrans(ii,2)),round(CoordMapTrans(ii,3))) = 1;%OptMap(round(CoordMap(ii,1)),round(CoordMap(ii,2)),round(CoordMap(ii,3)));
    end
end

L1 = fitLine3d(CoordMapTrans);
vz = [0 0 1];
ROTMatrix = createRotationVector3d([L1(4) L1(5) L1(6)],vz);
CoordMapRot=transformPoint3d(CoordMapTrans,ROTMatrix);
OptMapRot1 = zeros(size(OptMapRef));
for ii=1:length(indMap)
    if round(CoordMapRot(ii,1))<=0 || round(CoordMapRot(ii,2))<=0 || round(CoordMapRot(ii,3))<=0
    else
        OptMapRot1(round(CoordMapRot(ii,1)),round(CoordMapRot(ii,2)),round(CoordMapRot(ii,3))) = 1;%OptMapTrans1(round(CoordMapTrans(ii,1)),round(CoordMapTrans(ii,2)),round(CoordMapTrans(ii,3)));
    end
end

ellFit2 = inertiaEllipsoid(CoordMapRot);
TransMatrix2 = createTranslation3d(indXZero-ellFit2(1), indYZero-ellFit2(2),indZZero-ellFit2(3));
CoordMapFinal = transformPoint3d(CoordMapRot,TransMatrix2);
OptMapIndexFinal = zeros(size(OptMapRef));
for ii=1:length(indMap)
    if round(CoordMapFinal(ii,1))<=0 || round(CoordMapFinal(ii,2))<=0 || round(CoordMapFinal(ii,3))<=0
    else
        OptMapIndexFinal(round(CoordMapFinal(ii,1)),round(CoordMapFinal(ii,2)),round(CoordMapFinal(ii,3))) = 1;%OptMap(round(CoordMap(ii,1)),round(CoordMap(ii,2)),round(CoordMap(ii,3)));
    end
end

clear ii jj kk
CoordMapFinal = round(CoordMapFinal);
zmax = max(CoordMapFinal(:,3));
xC = zeros(1,zmax);
yC = zeros(1,zmax);
xT = zeros(1,zmax);
yT = zeros(1,zmax);
xR = zeros(1,zmax);
yR = zeros(1,zmax);
xB = zeros(1,zmax);
yB = zeros(1,zmax);
xL = zeros(1,zmax);
yL = zeros(1,zmax);
pTopBottom = zeros(zmax,2);
pLeftRight = zeros(zmax,2);
LimLR = zeros(size(OptMapIndexFinal,2),zmax);
LimTB = zeros(size(OptMapIndexFinal,1),zmax);
MarkersCoord = regionprops(OptMapIndexFinal(:,:,round(size(OptMapIndexFinal,3)/2)),'extrema');
xTMid = MarkersCoord.Extrema(2,1);
yTMid = MarkersCoord.Extrema(2,2);
xRMid = MarkersCoord.Extrema(4,1);
yRMid = MarkersCoord.Extrema(4,2);
xBMid = MarkersCoord.Extrema(6,1);
yBMid = MarkersCoord.Extrema(6,2);
xLMid = MarkersCoord.Extrema(8,1);
yLMid = MarkersCoord.Extrema(8,2);

pTopBottomMid = polyfit([yTMid yBMid],[xTMid xBMid],1);
pLeftRightMid = polyfit([xLMid xRMid],[yLMid yRMid],1);
clear MarkersCoord
for iPt = 1:size(CoordMap,1)
    iz = CoordMapFinal(iPt,3);
    if (xC(iz)) == 0

        MarkersCoord = regionprops(OptMapIndexFinal(:,:,CoordMapFinal(iPt,3)),'centroid','extrema');
        xC(iz) = MarkersCoord.Centroid(1);
        yC(iz) = MarkersCoord.Centroid(2);        
        xT(iz) = MarkersCoord.Extrema(2,1);
        yT(iz) = MarkersCoord.Extrema(2,2);
        xR(iz) = MarkersCoord.Extrema(4,1);
        yR(iz) = MarkersCoord.Extrema(4,2);
        xB(iz) = MarkersCoord.Extrema(6,1);
        yB(iz) = MarkersCoord.Extrema(6,2);
        xL(iz) = MarkersCoord.Extrema(8,1);
        yL(iz) = MarkersCoord.Extrema(8,2);
        
%         pTopBottom(iz,:) = polyfit([yT(iz) yB(iz)],[xT(iz) xB(iz)],1);
%         pLeftRight(iz,:) = polyfit([xL(iz) xR(iz)],[yL(iz) yR(iz)],1);
        pTopBottom(iz,1) = pTopBottomMid(1);
        pLeftRight(iz,1) = pLeftRightMid(1);
        pTopBottom(iz,2) = yC(iz)-pTopBottomMid(1)*xC(iz);
        pLeftRight(iz,2) = yC(iz)-pLeftRightMid(1)*xC(iz);
        LimLR(:,iz) = polyval(pLeftRight(iz,:),(1:size(OptMapIndexFinal,2)));
        LimTB(:,iz) = polyval(pTopBottom(iz,:),(1:size(OptMapIndexFinal,1)));
    end
    
    if CoordMapFinal(iPt,1) <= LimLR(CoordMapFinal(iPt,2),iz) && CoordMapFinal(iPt,2) <= LimTB(CoordMapFinal(iPt,1),iz)
        if uB(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)) > size(B3,1) || vB(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)) > size(B3,2) || uB(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)) <= 0 || vB(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)) <= 0
            OptMapRef(CoordMapFinal(iPt,1),CoordMapFinal(iPt,2),CoordMapFinal(iPt,3)) = 0;
        else
            OptMapRef(CoordMapFinal(iPt,1),CoordMapFinal(iPt,2),CoordMapFinal(iPt,3)) = OptMapCamB(vB(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)),uB(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)));
        end
    elseif CoordMapFinal(iPt,1) >= LimLR(CoordMapFinal(iPt,2),iz) && CoordMapFinal(iPt,2) <= LimTB(CoordMapFinal(iPt,1),iz)
        if uA(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)) > size(A3,1) || vA(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)) > size(A3,2) || uA(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)) <= 0 || vA(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)) <= 0
            OptMapRef(CoordMapFinal(iPt,1),CoordMapFinal(iPt,2),CoordMapFinal(iPt,3)) = 0;
        else
            OptMapRef(CoordMapFinal(iPt,1),CoordMapFinal(iPt,2),CoordMapFinal(iPt,3)) = OptMapCamA(vA(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)),uA(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)));
        end
    elseif CoordMapFinal(iPt,1) <= LimLR(CoordMapFinal(iPt,2),iz) && CoordMapFinal(iPt,2) >=  LimTB(CoordMapFinal(iPt,1),iz)
        if uC(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)) > size(C3,1) || vC(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)) > size(C3,2) || uC(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)) <= 0 || vC(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)) <= 0
            OptMapRef(CoordMapFinal(iPt,1),CoordMapFinal(iPt,2),CoordMapFinal(iPt,3)) = 0;
        else
            OptMapRef(CoordMapFinal(iPt,1),CoordMapFinal(iPt,2),CoordMapFinal(iPt,3)) = OptMapCamC(vC(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)),uC(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)));
        end
    elseif CoordMapFinal(iPt,1) >= LimLR(CoordMapFinal(iPt,2),iz) &&  CoordMapFinal(iPt,2) >= LimTB(CoordMapFinal(iPt,1),iz)
        if uD(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)) > size(D3,1) || vD(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)) > size(D3,2) || uD(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)) <= 0 || vD(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)) <= 0
            OptMapRef(CoordMapFinal(iPt,1),CoordMapFinal(iPt,2),CoordMapFinal(iPt,3)) = 0;
        else
            OptMapRef(CoordMapFinal(iPt,1),CoordMapFinal(iPt,2),CoordMapFinal(iPt,3)) = OptMapCamD(vD(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)),uD(CoordMap(iPt,1),CoordMap(iPt,2),CoordMap(iPt,3)));
        end
    end
    waitbar(iPt/size(CoordMap,1),h);
end
close(h)