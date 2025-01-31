
%% Cropping according to the black and white images

% First load IMG0616-011C.mat file

A=double(bgimage);
CamD=rescale(A);

figure(); imagesc(CamD); colormap gray; axis square 
mask=roipoly;

% Rename the mask in the right hand side workspace column to maskA, maskB
% etc...
% Repeat the process for the other 3 cameras 


%%
save('mask.mat','maskA');


%% Load the activation or APD map

APDmap=APDmap.*maskA; % here do NOT forget to rename maskA B C D based on which map you are focusing on; also change APD/Act map

prompt = {'What is the filename of the .mat you want to save? '};
dlgtitle = 'Name save';
dims = [1 35];
definput = {'IMG0505-021AAPDMap.mat'}; %change A B C D before saving
filename = inputdlg(prompt,dlgtitle,dims,definput);


prompt = {'Are you happy with segmentation and want to proceed with overwriting the .mat maps?'};
dlgtitle = 'Name save';
dims = [1 35];
definput = {'yes'};
goahead = inputdlg(prompt,dlgtitle,dims,definput);

if isequal(goahead{1},'yes')
    save(filename{1}, 'APDmap','-v7.3'); % Make sure to replace second variable "APDmap" term by Actmap when cropping activation maps
end





% You would be able to run the whiteBackgndNaN code to make sure the
% cropping worked and take a look at how the map looks
