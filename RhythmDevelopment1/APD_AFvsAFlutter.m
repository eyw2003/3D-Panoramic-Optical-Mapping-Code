%%
% 12/06/21 Lea
% Code that allows us to draw 2 ROIS: one for the RA and one for the LA to measure the average APD value in each chamber

%%
% load the APD map AND APD dispersion map (NOT binary) for Anterior or Posterior

DispersionMap=DispersionMap_CamD; % !!!! MAKE SURE TO CHOSE WHICH CAMERA FOR APD DISPERSION

figure(); imagesc(APDmap); colormap(jet); colorbar; caxis([0 100])
title('Please select the right atria')
mask1=roipoly;
atria1=mask1.*APDmap;
atriaDisp1=mask1.*DispersionMap;
figure(); imagesc(atria1); colormap(jet); colorbar; caxis([0 100]); title('atria1')

figure(); imagesc(APDmap); colormap(jet); colorbar; caxis([0 100])
title('Please select the left atria')
mask2=roipoly;
atria2=mask2.*APDmap;
atriaDisp2=mask2.*DispersionMap;
figure(); imagesc(atria2); colormap(jet); colorbar; caxis([0 100]); title('atria2')

atria1(isnan(atria1))=0;
atria1(atria1==-Inf)=0;
mean1=mean(atria1(atria1~=0))
max1=max(atria1(atria1~=0))
min1=min(atria1(atria1~=0))
std1=std(atria1(atria1~=0))

atria2(isnan(atria2))=0;
atria2(atria2==-Inf)=0;
mean2=mean(atria2(atria2~=0))
max2=max(atria2(atria2~=0))
min2=min(atria2(atria2~=0))
std2=std(atria2(atria2~=0))

atriaDisp1(isnan(atriaDisp1))=0;
atriaDisp1(atriaDisp1==-Inf)=0;
meanDisp1=mean(atriaDisp1(atriaDisp1~=0))
maxDisp1=max(atriaDisp1(atriaDisp1~=0))
minDisp1=min(atriaDisp1(atriaDisp1~=0))
stdDisp1=std(atriaDisp1(atriaDisp1~=0))

atriaDisp2(isnan(atriaDisp2))=0;
atriaDisp2(atriaDisp2==-Inf)=0;
meanDisp2=mean(atriaDisp2(atriaDisp2~=0))
maxDisp2=max(atriaDisp2(atriaDisp2~=0))
minDisp2=min(atriaDisp2(atriaDisp2~=0))
stdDisp2=std(atriaDisp2(atriaDisp2~=0))

%%
% load the APD map for cameras with just one atrial chamber in view

DispersionMap=DispersionMap_CamC; % !!!! MAKE SURE TO CHOSE WHICH CAMERA FOR APD DISPERSION

figure(); imagesc(APDmap); colormap(jet); colorbar; caxis([0 100])
title('Please select the atria')
mask=roipoly;
atria=mask.*APDmap;
atriaDisp=mask.*DispersionMap;
figure(); imagesc(atria); colormap(jet); colorbar; caxis([0 100]); title('atria')

atria(isnan(atria))=0;
atria(atria==-Inf)=0;
mean1=mean(atria(atria~=0))
max1=max(atria(atria~=0))
min1=min(atria(atria~=0))
std1=std(atria(atria~=0))

atriaDisp(isnan(atriaDisp))=0;
atriaDisp(atriaDisp==-Inf)=0;
atriaDisp=double(atriaDisp);
meanDisp=mean(atriaDisp(atriaDisp~=0))
maxDisp=max(atriaDisp(atriaDisp~=0))
minDisp=min(atriaDisp(atriaDisp~=0))
stdDisp=std(atriaDisp(atriaDisp~=0))
