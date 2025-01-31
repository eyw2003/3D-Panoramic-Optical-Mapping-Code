function phase = phaseMap(data,starttime,endtime,Fs,cmap)
%% Hilbert Transform Generated Phase Map
%
% INPUTS
% data = cmos data
% starttime = start time of viewing window
% endtime = end time of viewing window
% Fs = sampling frequency
% cmap = colormap (inverted/not inverted)
%
% OUTPUT
% A figure that has a color repersentation for phase
%
% REFERENCES
% None
%
% ADDITIONAL NOTES
% None
%
% RELEASE VERSION: 2014b v1.0
%
% AUTHOR: Jake Laughner
%
% MAINTED BY: Christopher Gloschat - (cgloschat@gmail.com) - [Jan. 2015 - Present]
%
% MODIFICATION LOG:
% February 12, 2015 - I restructured the code to first calculate phase,
% then request a directory and filename for the video, and finally to step
% through the phase images capturing them as a video. I also added a
% progress bar.
%
%% Code %%
% Calculate Hilbert Transform
if size(data,3) == 1
%     data = data(:,round(starttime*Fs+1):round(endtime*Fs+1));
    temp = reshape(data,[],size(data,2)) - repmat(mean(reshape(data,[],size(data,2)),2),[1 size(data,2)]);
    hdata = hilbert(temp');
    phase = -1*angle(hdata)';
else
    data = data(:,:,round(starttime*Fs+1):round(endtime*Fs+1));
    temp = reshape(data,[],size(data,3)) - repmat(mean(reshape(data,[],size(data,3)),2),[1 size(data,3)]);
    hdata = hilbert(temp');
    phase = -1*angle(hdata)';
    phase = reshape(phase,size(data,1),size(data,2),[]);
    % Choose location to save file and name of file
    dir = uigetdir;
    % If the cancel button is selected cancel the function
    if dir == 0
        return
    end
    % Request the desired name for the movie file
    filename = inputdlg('Enter Filename:');
    filename = char(filename);
    % Check to make sure a value was entered
    if isempty(filename)
        error = 'A filename must be entered! Function cancelled.';
        msgbox(error,'Incorrect Input','Error');
        return
    end
    % Convert filename to a character string
    filename = char(filename);
    % Create path to file
    movname = [dir,'/',filename,'.avi'];
    
    % !!! NEW (code modified by Lea on 01/11/2022: 
    
    %figure(); imagesc(phase(:,:,1)); colormap(jet); title('Load the mask and say which Cam it corresponds to to get rid of noisy background');
    %mask=roipoly;
    % Load the mask.mat (drag and drop) then type in the workspace
    % mask=maskA; or B C D etc...
    
      % Ask the user with a pop up window to load the mask.mat file
    [filename, pathname]=uigetfile('*.mat','Load the mask.mat file');
    load(filename);
    
       % Ask the user which mask out of the 4 views he wants to use in by directly displaying the message in the workspace and allowing the user to type the name of interest
    % e.g., type maskA, maskB, maskC or maskD
    prompt='Which view do you want the mask of?  ';
    mask=input(prompt);
    

    phaseCropped=phase(:,:,1).*mask;
    phaseCropped(phaseCropped==0)=NaN;
    % close; 
    
    % Capture video fo the Hilbert Transform represented phase over window
    fig = figure('Name',filename,'Visible','off');
    pa = axes;
    vidObj = VideoWriter(movname,'Motion JPEG AVI');
    open(vidObj);
    movegui(fig,'center')
    set(fig,'Visible','on');
    % Create progress bar
    gg = waitbar(0,'Producing Phase Map','Visible','off');
    tmp = get(gg,'Position');
    set(gg,'Position',[tmp(1) tmp(2)/4 tmp(3) tmp(4)],'Visible','on')
    axes(pa)
    for i = 1:size(data,3)
         % Three following lines modified by Lea on 03/18/2021 to apply the
         % cropping mask to the phase images in the phase movie and to the .mat phase variable
        phaseCropped(:,:,i)=phase(:,:,i).*mask;
        temp=phaseCropped(:,:,i);
        temp(temp==0)=NaN;
        phaseCropped(:,:,i)=temp;
        imagesc(phaseCropped(:,:,i),'Parent',pa);
%         temp=phase(:,:,i);
%         temp(temp==0)=NaN;
%         phase(:,:,i)=temp;
%         imagesc(phase(:,:,i),'Parent',pa);
        
        colormap(fig,cmap)
        colorbar(pa)
        caxis(pa,[-pi pi])
        axis(pa,'image')
        axis(pa,'off')
        pause(.05)
        F = getframe(fig);
        writeVideo(vidObj,F);% Write each frame to the file.
        % Update progress bar
        waitbar(i/size(data,3))
    end
    close(gg)
    close(fig)
    close(vidObj) % Close the file.
    
    phase=phaseCropped;
end
end