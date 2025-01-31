% Code to process the Keima images

%%
% First load the acquisition .mat that has the Keima signal in neutral
A=double(bgimage);
CamD_neutral=rescale(A); % make sure to change the name to CamB, CamC, CamD...

% repeat for the three other cameras

%%
% First load the acquisition .mat that has the Keima signal in basic
A=double(bgimage);
CamD_acidic=rescale(A); % make sure to change the name to CamB, CamC, CamD...

% repeat for the three other cameras

%%
figure(); 
subplot(241);imagesc(CamA_neutral); colorbar; colormap gray
subplot(242);imagesc(CamB_neutral); colorbar; colormap gray
subplot(243);imagesc(CamC_neutral); colorbar; colormap gray
subplot(244);imagesc(CamD_neutral); colorbar; colormap gray
subplot(245);imagesc(CamA_acidic); colorbar; colormap gray
subplot(246);imagesc(CamB_acidic); colorbar; colormap gray
subplot(247);imagesc(CamC_acidic); colorbar; colormap gray
subplot(248);imagesc(CamD_acidic); colorbar; colormap gray

%%
% Outline the atrial fluorescent regions and binarize the neutral Keima maps

close all;

Cam=CamD_neutral; % make sure to change the name to CamB, CamC, CamD...

figure(); imagesc(Cam); colorbar
silhouetteCam_neutral=Cam;
silhouetteCam_neutral(silhouetteCam_neutral<0.2)=0;
figure(); imagesc(silhouetteCam_neutral); colorbar

fluorescence=silhouetteCam_neutral;
fluorescence(fluorescence>0.75)=1;
fluorescence(fluorescence~=1)=0;
figure(); imagesc(fluorescence); colorbar


silhouette=silhouetteCam_neutral;
silhouette(silhouette~=0)=1;
figure(); imagesc(silhouette); colorbar

silhouetteCam_neutral=silhouette+fluorescence;
figure(); imagesc(silhouetteCam_neutral); colorbar
% OPTIONAL: if you need to get rid of ventricular fluorescence signal
title('Select the atrial fluorescence region you want to keep')
mask=roipoly;
fluorescence=fluorescence.*mask;
silhouetteCam_neutral=silhouette+fluorescence;
figure(); imagesc(silhouetteCam_neutral); colorbar

silhouetteCamD_neutral=silhouetteCam_neutral; % make sure to change the name to CamB, CamC, CamD...

% repeat for the three other cameras

%%
close all;
figure(); 
subplot(141);imagesc(CamA_neutral); colorbar; colormap gray
subplot(142);imagesc(CamB_neutral); colorbar; colormap gray
subplot(143);imagesc(CamC_neutral); colorbar; colormap gray
subplot(144);imagesc(CamD_neutral); colorbar; colormap gray
figure(); 
subplot(141);imagesc(silhouetteCamA_neutral); colorbar; colormap parula
subplot(142);imagesc(silhouetteCamB_neutral); colorbar; colormap parula
subplot(143);imagesc(silhouetteCamC_neutral); colorbar; colormap parula
subplot(144);imagesc(silhouetteCamD_neutral); colorbar; colormap parula


%%
% Outline the atrial fluorescent regions and binarize the acidic Keima maps

close all;

Cam=CamD_acidic; % make sure to change the name to CamB, CamC, CamD...

figure(); imagesc(Cam); colorbar
silhouetteCam_acidic=Cam;
silhouetteCam_acidic(silhouetteCam_acidic<0.2)=0;
figure(); imagesc(silhouetteCam_acidic); colorbar


fluorescence=silhouetteCam_acidic;
fluorescence(fluorescence>0.75)=1;
fluorescence(fluorescence~=1)=0;
figure(); imagesc(fluorescence); colorbar

silhouette=silhouetteCam_acidic;
silhouette(silhouette~=0)=1;
figure(); imagesc(silhouette); colorbar

silhouetteCam_acidic=silhouette+fluorescence;
figure(); imagesc(silhouetteCam_acidic); colorbar

% OPTIONAL: if you need to get rid of ventricular fluorescence signal
title('Select the atrial fluorescence region you want to keep')
mask=roipoly;
fluorescence=fluorescence.*mask;
silhouetteCam_acidic=silhouette+fluorescence;
figure(); imagesc(silhouetteCam_acidic); colorbar

silhouetteCamD_acidic=silhouetteCam_acidic; % make sure to change the name to CamB, CamC, CamD...

% repeat for the three other cameras

%%
close all;
figure(); 
subplot(141);imagesc(CamA_acidic); colorbar; colormap gray
subplot(142);imagesc(CamB_acidic); colorbar; colormap gray
subplot(143);imagesc(CamC_acidic); colorbar; colormap gray
subplot(144);imagesc(CamD_acidic); colorbar; colormap gray
figure();
subplot(141);imagesc(silhouetteCamA_acidic); colorbar; colormap parula
subplot(142);imagesc(silhouetteCamB_acidic); colorbar; colormap parula
subplot(143);imagesc(silhouetteCamC_acidic); colorbar; colormap parula
subplot(144);imagesc(silhouetteCamD_acidic); colorbar; colormap parula

%%
%Save the data

save('KeimaData.mat','CamA_neutral','CamB_neutral','CamC_neutral','CamD_neutral','silhouetteCamA_neutral','silhouetteCamB_neutral','silhouetteCamC_neutral','silhouetteCamD_neutral','CamA_acidic','CamB_acidic','CamC_acidic','CamD_acidic','silhouetteCamA_acidic','silhouetteCamB_acidic','silhouetteCamC_acidic','silhouetteCamD_acidic','-v7.3');

%%
% Prepare for 3D projection NEUTRAL

Actmap=silhouetteCamD_neutral; % make sure to change the name to CamB, CamC, CamD...
Actmap(Actmap==1)=50;
Actmap(Actmap==2)=100;
save('IMG0505-014DKeimaNeutralMap.mat','Actmap'); % make sure to change the name with the correct number and correct CamB, CamC, CamD...

% You will have to repeat this section for each camera

%%
% Prepare for 3D projection ACIDIC

Actmap=silhouetteCamD_acidic; % make sure to change the name to CamB, CamC, CamD...
Actmap(Actmap==1)=50;
Actmap(Actmap==2)=100;
save('IMG0505-015DKeimaAcidicMap.mat','Actmap'); % make sure to change the name with the correct number and correct CamB, CamC, CamD...


% You will have to repeat this section for each camera