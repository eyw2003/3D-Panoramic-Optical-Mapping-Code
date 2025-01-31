%% Load the APD map
%tic
% filenameAPD = 'IMG1113-014AAPDMap.mat';
% load(filenameAPD);

ProjectedMap = APDmap;
ProjectedMap(isnan(ProjectedMap)) = -Inf;

%% Important parameters to be adjusted by the user
NghbrSize = 3; % Size of the neighbourhood in which the dispersion is studied. Needs to be an odd number bigger than 2
Threshold = 8; % Threshold separating the regions of high dispersion from the regions of low dispersion

%% Detection of the voxel with an APD value
ii = find(~isinf(ProjectedMap));
[ix,iy] = ind2sub(size(ProjectedMap),ii);

%% Calculation of the dispersion in the neighbourhood of each voxel
DispersionMap = zeros(size(ProjectedMap));
nghbourhood = zeros(NghbrSize,NghbrSize);
for in = 1:length(ii)
    if ix(in)-(NghbrSize-1)/2 > 1
        ind1 = ix(in)-(NghbrSize-1)/2;
    else
        ind1 = 1;
    end
    if ix(in)+(NghbrSize-1)/2 < size(ProjectedMap,1)
        ind2 = ix(in)+(NghbrSize-1)/2;
    else
        ind2 = size(ProjectedMap,1);
    end
    if iy(in)-(NghbrSize-1)/2 > 1
        ind3 = iy(in)-(NghbrSize-1)/2;
    else
        ind3 = 1;
    end
    if iy(in)+(NghbrSize-1)/2 < size(ProjectedMap,2)
        ind4 = iy(in)+(NghbrSize-1)/2;
    else
        ind4 = size(ProjectedMap,2);
    end
    nghbourhood = ProjectedMap(ind1:ind2,ind3:ind4);
    DispersionMap(ix(in),iy(in)) = std(nghbourhood(~isinf(nghbourhood)));
end
figure
subplot(121)
imagesc(ProjectedMap); colormap(jet); colorbar; title('APD map')
caxis([0 60])
subplot(122)
imagesc(DispersionMap); colormap(jet); colorbar; title('APD dispersion map')
caxis([0 25])
DispersionMap(DispersionMap==0) = -Inf;

%% Crop the noisy borders to not have outlier APD dispersion values
figure(); imagesc(DispersionMap); colormap(jet); caxis([0 25]);
mask=roipoly; 
DispersionMap=mask.*DispersionMap;
DispersionMap(DispersionMap==0) = -Inf;
figure(); imagesc(DispersionMap); colormap(jet); caxis([0 25]);

% APDmap=mask.*APDmap;
APDmap(APDmap==0)=-Inf;

%% Separation of the regions of high dispersion vs regions of low dispersion
DispersionMapThresholded = zeros(size(DispersionMap));
DispersionMapThresholded(DispersionMap<Threshold&DispersionMap>-1) = 1;
DispersionMapThresholded(DispersionMap>Threshold) = 2;

figure
imagesc(DispersionMapThresholded); colorbar; title('APD dispersion binary map')
caxis([0 2])
DispersionMapThresholded(DispersionMapThresholded==0) = -Inf;

%% OPTION 1: Calculate the percentage of dispersion in the studied heart within 2 ROIs of the chambers of interest (atria)

% --- When both atria present in view (ANT and POST) then draw 2 ROIs

title('1st ROI');
ROI1=roipoly;
hold on; contour(ROI1);
title('2nd ROI');
ROI2=roipoly;
hold on; contour(ROI2);

DispersionMapThresholded_ROI1=ROI1.*DispersionMapThresholded;
DispersionMap_ROI1=ROI1.*DispersionMap;
DispersionMap_ROI1(isnan(DispersionMap_ROI1))=0;
DispersionMap_ROI1(DispersionMap_ROI1==-Inf)=0;
APDdispAvg1=mean(DispersionMap_ROI1(:));
APDdispMax1=max(DispersionMap_ROI1(:));

iLow1 = length(find(DispersionMapThresholded_ROI1==1));
iHigh1 = length(find(DispersionMapThresholded_ROI1==2));
PercentageDisp1 = 100*iHigh1/(iHigh1+iLow1);

DispersionMapThresholded_ROI2=ROI2.*DispersionMapThresholded;
DispersionMap_ROI2=ROI2.*DispersionMap;
DispersionMap_ROI2(isnan(DispersionMap_ROI2))=0;
DispersionMap_ROI2(DispersionMap_ROI2==-Inf)=0;
APDdispAvg2=mean(DispersionMap_ROI2(:));
APDdispMax2=max(DispersionMap_ROI2(:));

iLow2 = length(find(DispersionMapThresholded_ROI2==1));
iHigh2 = length(find(DispersionMapThresholded_ROI2==2));
PercentageDisp2 = 100*iHigh2/(iHigh2+iLow2);

PercentageDisp = (PercentageDisp1+PercentageDisp2)/2;
disp('Percentage of dispersion in this heart')
disp(PercentageDisp)

%% OPTION 2: Calculate the percentage of dispersion in the studied heart within 1 ROI of the chamberhh of interest (atrium)

% --- When ONLY ONE atrium present in view then draw only 1 ROI
ROI1=roipoly;
hold on; contour(ROI1);
DispersionMapThresholded_ROI2=ROI1.*DispersionMapThresholded;

DispersionMap_ROI1=ROI1.*DispersionMap;
DispersionMap_ROI1(isnan(DispersionMap_ROI1))=0;
DispersionMap_ROI1(DispersionMap_ROI1==-Inf)=0;
APDdispAvg=mean(DispersionMap_ROI1(:));
APDdispMax=max(DispersionMap_ROI1(:));

iLow = length(find(DispersionMapThresholded_ROI2==1));
iHigh = length(find(DispersionMapThresholded_ROI2==2));

PercentageDisp = 100*iHigh/(iHigh+iLow);
disp('Percentage of dispersion in this heart')
disp(PercentageDisp)


%% Save and display results for all 4 cameras

figure();
subplot(221); imagesc(APDmap_CamA); colormap(jet); colorbar; title('APD map camera A'); caxis([0 100])
subplot(222); imagesc(APDmap_CamB); colormap(jet); colorbar; title('APD map camera B'); caxis([0 100])
subplot(223); imagesc(APDmap_CamC); colormap(jet); colorbar; title('APD map camera C'); caxis([0 100])
subplot(224); imagesc(APDmap_CamD); colormap(jet); colorbar; title('APD map camera D'); caxis([0 100])

figure();
subplot(221); imagesc(DispersionMap_CamA); colormap(jet); colorbar; title('Dispersion map camera A'); caxis([0 25])
subplot(222); imagesc(DispersionMap_CamB); colormap(jet); colorbar; title('Dispersion map camera B'); caxis([0 25])
subplot(223); imagesc(DispersionMap_CamC); colormap(jet); colorbar; title('Dispersion map camera C'); caxis([0 25])
subplot(224); imagesc(DispersionMap_CamD); colormap(jet); colorbar; title('Dispersion map camera D'); caxis([0 25])

figure();
subplot(221); imagesc(DispersionMapThresholded_CamA); colorbar; title('Binary dispersion map camera A'); caxis([0 2])
subplot(222); imagesc(DispersionMapThresholded_CamB); colorbar; title('Binary dispersion map camera B'); caxis([0 2])
subplot(223); imagesc(DispersionMapThresholded_CamC); colorbar; title('Binary dispersion map camera C'); caxis([0 2])
subplot(224); imagesc(DispersionMapThresholded_CamD); colorbar; title('Binary dispersion map camera D'); caxis([0 2])

%!!!!! MAKE SURE TO CHANGE THE XX to correct digit
save('APDdispersionAtria_017.mat','-v7.3'); % make sure to change the name with the correct number

%%  Prepare and save four camera maps for prjection onto 3D silhouette

APDmap=DispersionMapThresholded_CamD; % make sure to change the name to CamB, CamC, CamD...
APDmap(APDmap==1)=50;
APDmap(APDmap==2)=100;
APDmap(APDmap==-Inf)=NaN;
save('IMG0503-021DAPDMap_DispBinary.mat','APDmap'); % make sure to change the name with the correct number and correct CamB, CamC, CamD...

% You will have to repeat this section for each camera