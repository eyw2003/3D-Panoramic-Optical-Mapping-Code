function CheckSegmentation(numInit,numViews,threshold,filename,pathname)

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
h=figure;
%% Creation of the n 3-D views based on the 4 cameras
for  iAngle=1:1:numViews
    iAngleLoad = (iAngle-1)+numInit;
    if iAngleLoad < 100
       iAngleLoadstr = strcat('0',num2str(iAngleLoad));
    else
       iAngleLoadstr = num2str(iAngleLoad);
    end
    
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
    
    subplot(121)
    imagesc(A3init)
    title(strcat(LoadFileNameA,' Before'))
    subplot(122)
    imagesc(A3)
    title(strcat(LoadFileNameA,' After'))
    pause
end
for  iAngle=1:1:numViews
    iAngleLoad = (iAngle-1)+numInit;
    if iAngleLoad < 100
       iAngleLoadstr = strcat('0',num2str(iAngleLoad));
    else
       iAngleLoadstr = num2str(iAngleLoad);
    end
    
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
    
    subplot(121)
    imagesc(B3init)
    title(strcat(LoadFileNameB,' Before'))
    subplot(122)
    imagesc(B3)
    title(strcat(LoadFileNameB,' After'))
    pause
end
for  iAngle=1:1:numViews
    iAngleLoad = (iAngle-1)+numInit;
    if iAngleLoad < 100
       iAngleLoadstr = strcat('0',num2str(iAngleLoad));
    else
       iAngleLoadstr = num2str(iAngleLoad);
    end
    
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
    
    subplot(121)
    imagesc(C3init)
    title(strcat(LoadFileNameC,' Before'))
    subplot(122)
    imagesc(C3)
    title(strcat(LoadFileNameC,' After'))
    pause
end
for  iAngle=1:1:numViews
    iAngleLoad = (iAngle-1)+numInit;
    if iAngleLoad < 100
       iAngleLoadstr = strcat('0',num2str(iAngleLoad));
    else
       iAngleLoadstr = num2str(iAngleLoad);
    end
    
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

    
    subplot(121)
    imagesc(D3init)
    title(strcat(LoadFileNameD,' Before'))
    subplot(122)
    imagesc(D3)
    title(strcat(LoadFileNameD,' After'))
    pause
end
close(h)


