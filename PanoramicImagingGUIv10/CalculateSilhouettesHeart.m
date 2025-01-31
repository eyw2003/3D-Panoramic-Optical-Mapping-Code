function Silhouettes = CalculateSilhouettesHeart(numInit,numViews,threshold,TSquare,SSquare,RSquare,QSquare,filename,pathname,AxX,AxY,AxZ)

% Calculate the numViews 3D silhouettes of the heart using the occluding
% contour scripts and a certain numbers of acquisitions around the heart.

% Inputs: numInit indicates the ref number of the first file of Camera A
%         numViews indicates the number of views in total (to cover 90degrees with a 5 degree steps, numViews = 19)
%         threshold defines what is background vs. what is heart
%         TSquare,SSquare,RSquare and QSquare are the calibration matrices
%         to go from 2-D to 3-D space.
%         filename is the filename of the first acquisition with the cam A
%         AxX, AxY, AxZ are the axes of the virtual box surrounding the
%         heart

PosDashName = strfind(filename,'-');
h = waitbar(0,strcat('Calculation of the ',num2str(numViews),' 3-D silhouettes'));
%% Creation of the n 3-D views based on the 4 cameras
for  iAngle=1:1:numViews
    iAngleLoad = (iAngle-1)+numInit;
    if iAngleLoad < 100
       iAngleLoadstr = strcat('0',num2str(iAngleLoad));
    else
       iAngleLoadstr = num2str(iAngleLoad);
    end
    Silhouette = 0.1*ones(length(AxX),length(AxY),length(AxZ));
    
    % Load images
    % Camera A
    LoadFileNameA = strcat(filename(1:PosDashName),iAngleLoadstr,'A');
    if exist(strcat(pathname,LoadFileNameA,'.mat'),'file') == 0
        CMOSconverter(pathname,strcat(LoadFileNameA,'.rsh')); % Convert directly from the .rsh    
    end    
    Data1 = load(strcat(pathname,LoadFileNameA));
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
    LoadFileNameB = strcat(filename(1:PosDashName),iAngleLoadstr,'B');
    if exist(strcat(pathname,LoadFileNameB,'.mat'),'file') == 0
        CMOSconverter(pathname,strcat(LoadFileNameB,'.rsh')); % Convert directly from the .rsh    
    end
    Data2 = load(strcat(pathname,LoadFileNameB));
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
    LoadFileNameC = strcat(filename(1:PosDashName),iAngleLoadstr,'C');
    if exist(strcat(pathname,LoadFileNameC,'.mat'),'file') == 0
        CMOSconverter(pathname,strcat(LoadFileNameC,'.rsh')); % Convert directly from the .rsh    
    end
    Data3 = load(strcat(pathname,LoadFileNameC));
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
    LoadFileNameD = strcat(filename(1:PosDashName),iAngleLoadstr,'D');
    if exist(strcat(pathname,LoadFileNameD,'.mat'),'file') == 0
        CMOSconverter(pathname,strcat(LoadFileNameD,'.rsh')); % Convert directly from the .rsh    
    end
    Data4 = load(strcat(pathname,LoadFileNameD));
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
    %
    for ii = 1:length(AxX)
        for jj = 1:length(AxY)
            for kk = 1:length(AxZ)
                kA = TSquare(1,3)*AxX(ii)+TSquare(2,3)*AxY(jj)+TSquare(3,3)*AxZ(kk)+TSquare(4,3);
                uA = round((TSquare(1,1)*AxX(ii)+TSquare(2,1)*AxY(jj)+TSquare(3,1)*AxZ(kk)+TSquare(4,1))/kA);
                vA = round((TSquare(1,2)*AxX(ii)+TSquare(2,2)*AxY(jj)+TSquare(3,2)*AxZ(kk)+TSquare(4,2))/kA);
                
                if uA > size(A3,1) || vA > size(A3,2) || uA <= 0 || vA <= 0
                    Silhouette(ii,jj,kk) = 0;
                else
                    if A3(vA,uA) > 0 && Silhouette(ii,jj,kk)~=0
                        Silhouette(ii,jj,kk) = 1;
                    else
                        Silhouette(ii,jj,kk) = 0;
                    end
                end
                
                kB = SSquare(1,3)*AxX(ii)+SSquare(2,3)*AxY(jj)+SSquare(3,3)*AxZ(kk)+SSquare(4,3);
                uB = round((SSquare(1,1)*AxX(ii)+SSquare(2,1)*AxY(jj)+SSquare(3,1)*AxZ(kk)+SSquare(4,1))/kB);
                vB = round((SSquare(1,2)*AxX(ii)+SSquare(2,2)*AxY(jj)+SSquare(3,2)*AxZ(kk)+SSquare(4,2))/kB);
                
                if uB > size(B3,1) || vB > size(B3,2) || uB <= 0 || vB <= 0
                    Silhouette(ii,jj,kk) = 0;
                else
                    if B3(vB,uB) > 0 && Silhouette(ii,jj,kk)~=0
                        Silhouette(ii,jj,kk) = 1;
                    else
                        Silhouette(ii,jj,kk) = 0;
                    end
                end
                
                kC = RSquare(1,3)*AxX(ii)+RSquare(2,3)*AxY(jj)+RSquare(3,3)*AxZ(kk)+RSquare(4,3);
                uC = round((RSquare(1,1)*AxX(ii)+RSquare(2,1)*AxY(jj)+RSquare(3,1)*AxZ(kk)+RSquare(4,1))/kC);
                vC = round((RSquare(1,2)*AxX(ii)+RSquare(2,2)*AxY(jj)+RSquare(3,2)*AxZ(kk)+RSquare(4,2))/kC);
                
                if uC > size(C3,1) || vC > size(C3,2) || uC <= 0 || vC <= 0
                    Silhouette(ii,jj,kk) = 0;
                else
                    if C3(vC,uC) > 0 && Silhouette(ii,jj,kk)~=0
                        Silhouette(ii,jj,kk) = 1;
                    else
                        Silhouette(ii,jj,kk) = 0;
                    end
                end
                
                kD = QSquare(1,3)*AxX(ii)+QSquare(2,3)*AxY(jj)+QSquare(3,3)*AxZ(kk)+QSquare(4,3);
                uD = round((QSquare(1,1)*AxX(ii)+QSquare(2,1)*AxY(jj)+QSquare(3,1)*AxZ(kk)+QSquare(4,1))/kD);
                vD = round((QSquare(1,2)*AxX(ii)+QSquare(2,2)*AxY(jj)+QSquare(3,2)*AxZ(kk)+QSquare(4,2))/kD);
                
                if uD > size(D3,1) || vD > size(D3,2) || uD <= 0 || vD <= 0
                    Silhouette(ii,jj,kk) = 0;
                else
                    if D3(vD,uD) > 0 && Silhouette(ii,jj,kk)~=0
                        Silhouette(ii,jj,kk) = 1;
                    else
                        Silhouette(ii,jj,kk) = 0;
                    end
                end
            end
        end
    end
    
    Silhouette(Silhouette==0.1) = 0;
    eval(strcat('Silhouettes.Silhouette',num2str(iAngle),'=Silhouette;'))
%     save(strcat('Silhouette',num2str(iAngle)),strcat('Silhouette',num2str(iAngle)))
%     fidu = fopen(strcat('Silhouette',num2str(iAngle)),'w');
%     fwrite(fidu,Silhouette,'double');
%     fclose(fidu);
    waitbar(iAngle/numViews,h);
end

close(h)

