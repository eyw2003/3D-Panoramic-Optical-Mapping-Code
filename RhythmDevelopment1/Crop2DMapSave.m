% After having loaded the /mat and run the whiteBackgndNaN, run this code

mask=roipoly;
APDmap=APDmap.*mask; % Make sure to replace both "APDmap" terms by Actmap when cropping activation maps

run whiteBackgndNaN

prompt = {'What is the filename of the .mat you want to save? '};
dlgtitle = 'Name save';
dims = [1 35];
definput = {'IMG0505-015DAPDMap.mat'};
filename = inputdlg(prompt,dlgtitle,dims,definput);


prompt = {'Are you happy with segmentation and want to proceed with overwriting the .mat maps?'};
dlgtitle = 'Name save';
dims = [1 35];
definput = {'yes'};
goahead = inputdlg(prompt,dlgtitle,dims,definput);

if isequal(goahead{1},'yes')
    save(filename{1}, 'APDmap','-v7.3'); % Make sure to replace second variable "APDmap" term by Actmap when cropping activation maps
end