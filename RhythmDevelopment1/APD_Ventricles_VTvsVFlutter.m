%%
% 11/03/2022 Najla
% Code that allows us to draw 1 ROIS: for the ventricles to measure the average APD value in the chamber



%%
% load the APD map for cameras with just one ventricular chamber in view

DispersionMap=DispersionMap_CamD; % !!!! MAKE SURE TO CHOSE WHICH CAMERA FOR APD DISPERSION

figure(); imagesc(APDmap); colormap(jet); colorbar; caxis([0 100])
title('Please select the ventricles')
mask=roipoly;
ventricles=mask.*APDmap;
ventriclesDisp=mask.*DispersionMap;
figure(); imagesc(ventricles); colormap(jet); colorbar; caxis([0 100]); title('ventricles')

ventricles(isnan(ventricles))=0;
ventricles(ventricles==-Inf)=0;
mean1=mean(ventricles(ventricles~=0))
max1=max(ventricles(ventricles~=0))
min1=min(ventricles(ventricles~=0))
std1=std(ventricles(ventricles~=0))

ventriclesDisp(isnan(ventriclesDisp))=0;
ventriclesDisp(ventriclesDisp==-Inf)=0;
ventriclesDisp=double(ventriclesDisp);
meanDisp=mean(ventriclesDisp(ventriclesDisp~=0))
maxDisp=max(ventriclesDisp(ventriclesDisp~=0))
minDisp=min(ventriclesDisp(ventriclesDisp~=0))
stdDisp=std(ventriclesDisp(ventriclesDisp~=0))

%%