%%
% 10/06/22 Najla 
%%% Code that allows ud to draw 2 ROIS: one for the RA and one for the LA to measure mean, maximum and minimum intensity values of Keima Acidic gray image in each chamber
%% 
% load the Keima Acidic gray image
 A=double(bgimage);
 figure(); 
 imagesc(A);colorbar; colormap gray; caxis([75 700])
 max(A(:))
 min(A(:))
 % !!!!make sure to change the name to CamB, CamC, CamD...
 
%% for cameras with just one atrial chamber in view
CamA_acidic=rescale(A); % make sure to change the name to CamB, CamC, CamD...

figure(); imagesc(A); colorbar; colormap gray; caxis([75 700])
title('Please select the atria')
mask=roipoly;
atria=mask.*CamA_acidic;
figure(); imagesc(atria); colorbar; colormap gray; caxis([75 700]); title('atria')

atria(isnan(atria))=75;
atria(atria==-Inf)=75;
mean1=mean(atria(atria~=75))
max1=max(atria(atria~=75))
min1=min(atria(atria~=75))

%% %% for cameras with just one atrial chamber in view for Anterior or Posterior

CamB_acidic=rescale(A); % make sure to change the name to CamB, CamC, CamD..

figure(); imagesc(A);colorbar; colormap gray;
 title('Please select the right atria')
 mask1=roipoly;
 atria1=mask1.*CamB_acidic;
 figure(); imagesc(atria1); colormap gray; colorbar; title('atria1')
 
 figure(); imagesc(A);colormap gray; colorbar; 
 title('Please select the left atria')
 mask2=roipoly;
 atria2=mask2.*CamB_acidic;
 figure(); imagesc(atria2); colormap gray;colorbar; title('atria2')
 
atria1(isnan(atria1))=0;
atria1(atria1==-Inf)=0;
mean1=mean(atria1(atria1~=0))
max1=max(atria1(atria1~=0))
min1=min(atria1(atria1~=0))

atria2(isnan(atria2))=0;
atria2(atria2==-Inf)=0;
mean2=mean(atria2(atria2~=0))
max2=max(atria2(atria2~=0))
min2=min(atria2(atria2~=0))
