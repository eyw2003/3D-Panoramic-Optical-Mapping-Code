function rhythmPanoramic
close all; clc;
%% RHYTHM (01/27/2012)
% Matlab software for analyzing optical mapping data
%
% By Matt Sulkin, Jake Laughner, Xinyuan Sophia Cui, Jed Jackoway
% Washington University in St. Louis -- Efimov Lab
%
% Currently maintained by: Christopher Gloschat [Jan. 2015 - Present]
%
% For any questions and suggestions, please email us at:
% cgloschat@gmail.com or igor@wustl.edu
%
% Modification Log:
% Jan. 23, 2015 - 1) Size of tools adjusted for MATLAB 2014a to constrain 
% all tools and labels to their groups. Mostly cosmetic adjustment. 2) I
% built in fail safes to prevent the GUI from doing undesired things. For
% example, if cancel was selected after clicking get directory it set the
% directory to root. Now it will only set the directory if a directory is
% set.
%
% Jan. 26, 2015 - The invert_cmap function was added to facilitate the
% inversion of the default colormap used for maps of activation time and
% action potential duration.
%
% Feb. 9, 2015 - With the MATLAB2014b release multiple commands in the
% visualization toolkit were changed. Among these were the video writer
% commands and the command for tracking mouse clicks on the GUI. These
% commands have been updated and RHYTHM should now be functional on 2014b.
%
% Feb. 24, 2016 - The GUI has been streamlined to reduce clutter and create
% a space for plugins created by future users.
%
%

%% Create GUI structure
scrn_size = get(0,'ScreenSize');
f = figure('Name','RHYTHM','Visible','off','Position',[scrn_size(3),scrn_size(4),1250,750],'NumberTitle','Off');
% set(f,'Visible','off')

% Load Data
p1 = uipanel('Title','Display Data','FontSize',12,'Position',[.01 .01 .98 .98]);
filelist = uicontrol('Parent',p1,'Style','listbox','String','Files','Position',[10 260 150 450],'Callback',{@filelist_callback});
selectdir = uicontrol('Parent',p1,'Style','pushbutton','FontSize',12,'String','Select Directory','Position',[10 225 150 30],'Callback',{@selectdir_callback});
loadfile = uicontrol('Parent',p1,'Style','pushbutton','FontSize',12,'String','Load','Position',[10 195 150 30],'Callback',{@loadfile_callback});
refreshdir = uicontrol('Parent',p1,'Style','pushbutton','FontSize',12,'String','Refresh Directory','Position',[10 165 150 30],'Callback',{@refreshdir_callback});

% Movie Screen for Optical Data
movie_scrn = axes('Parent',p1,'Units','Pixels','YTick',[],'XTick',[],'Position',[200, 210, 500,500]);

% Movie Slider for Controling Current Frame
movie_slider = uicontrol('Parent',f, 'Style', 'slider','Position', [213, 180, 502, 20],'SliderStep',[.001 .01],'Callback',{@movieslider_callback});
addlistener(movie_slider,'ContinuousValueChange',@movieslider_callback);

% Mouse Listening Function
set(f,'WindowButtonDownFcn',{@button_down_function});
set(f,'WindowButtonUpFcn',{@button_up_function});
set(f,'WindowButtonMotionFcn',{@button_motion_function});

% Signal Display Screens for Optical Action Potentials
signal_scrn1 = axes('Parent',p1,'Units','Pixels','Color','w','XTick',[],'Position',[740,592,468,120]);
signal_scrn2 = axes('Parent',p1,'Units','Pixels','Color','w','XTick',[],'Position',[740,464,468,120]);
signal_scrn3 = axes('Parent',p1,'Units','Pixels','Color','w','XTick',[],'Position',[740,336,468,120]);
signal_scrn4 = axes('Parent',p1,'Units','Pixels','Color','w','XTick',[],'Position',[740,208,468,120]);
signal_scrn5 = axes('Parent',p1,'Units','Pixels','Color','w','Position',[740,80,468,120]);
xlabel('Time (sec)');
expwave_button = uicontrol('Parent',p1,'Style','pushbutton','FontSize',12,'String','Export OAPs','Position',[1115 13 100 30],'Callback',{@expwave_button_callback});
starttimesig_text = uicontrol('Parent',p1,'Style','text','FontSize',12,'String','Start Time','Position',[830 19 55 15]);
starttimesig_edit = uicontrol('Parent',p1,'Style','edit','FontSize',14,'Position',[890 15 55 23],'Callback',{@starttimesig_edit_callback});
endtimesig_text = uicontrol('Parent',p1,'Style','text','FontSize',12,'String','End Time','Position',[965 19 52 15]);
endtimesig_edit = uicontrol('Parent',p1,'Style','edit','FontSize',14,'Position',[1022 15 55 23],'Callback',{@endtimesig_edit_callback});

% Sweep Bar Display for Optical Action Potentials
sweep_bar = axes ('Parent',p1,'Units','Pixels','Layer','top','Position',[740,55,466,735]);
set(sweep_bar,'NextPlot','replacechildren','Visible','off')

% Video Control Buttons and Optical Action Potential Display
play_button = uicontrol('Parent',p1,'Style','pushbutton','FontSize',12,'String','Play Movie','Position',[215 141 100 30],'Callback',{@play_button_callback});
stop_button = uicontrol('Parent',p1,'Style','pushbutton','FontSize',12,'String','Stop Movie','Position',[315 141 100 30],'Callback',{@stop_button_callback});
dispwave_button = uicontrol('Parent',p1,'Style','pushbutton','FontSize',12,'String','Display Wave','Position',[415 141 100 30],'Callback',{@dispwave_button_callback});
expmov_button = uicontrol('Parent',p1,'Style','pushbutton','FontSize',12,'String','Export Movie','Position',[515 141 100 30],'Callback',{@expmov_button_callback});

% Optical Action Potential Analysis Button Group and Buttons
view_sig = uibuttongroup('Parent',p1,'Title','View Signals','FontSize',12,'Position',[0.01 0.015 .255 .18]);
az_txt = uicontrol('Parent',view_sig,'Style','text','String','Azimuth Angle:','FontSize',12,'Position',[10 85 85 25]);
az_edit = uicontrol('Parent',view_sig,'Style','edit','FontSize',12,'String','0','Position',[95 88 50 25],'Callback',{@az_edit_callback});
el_txt = uicontrol('Parent',view_sig,'Style','text','String','Elevation Angle:','FontSize',12,'Position',[155 85 95 25]);
el_edit = uicontrol('Parent',view_sig,'Style','edit','FontSize',12,'String','0','Position',[250 88 50 25],'Callback',{@el_edit_callback});
cam1view_button = uicontrol('Parent',view_sig,'Style','pushbutton','String','Camera 1','FontSize',12,'Position',[5 55 70 25],'Callback',{@cam1view_button_callback});
cam2view_button = uicontrol('Parent',view_sig,'Style','pushbutton','String','Camera 2','FontSize',12,'Position',[80 55 70 25],'Callback',{@cam2view_button_callback});
cam3view_button = uicontrol('Parent',view_sig,'Style','pushbutton','String','Camera 3','FontSize',12,'Position',[155 55 70 25],'Callback',{@cam3view_button_callback});
cam4view_button = uicontrol('Parent',view_sig,'Style','pushbutton','String','Camera 4','FontSize',12,'Position',[235 55 70 25],'Callback',{@cam4view_button_callback});


% Create Button Group
anal_data = uibuttongroup('Parent',p1,'Title','Analyze Data','FontSize',12,'Position',[0.275 0.015 .272 .180]);

anal_select = uicontrol('Parent',anal_data,'Style','popupmenu','FontSize',12,'String',{'-----','Activation','Conduction','APD','Phase','Dominant Frequency','Wavefront'},'Position',[5 85 165 25],'Callback',{@anal_select_callback});

% Invert Color Map Option
invert_cmap = uicontrol('Parent',anal_data,'Style','checkbox','FontSize',12,'String','Invert Colormaps','Position',[175 88 150 25],'Visible','on','Callback',{@invert_cmap_callback});

% Mapping buttons
starttimemap_text = uicontrol('Parent',anal_data,'Style','text','FontSize',12,'String','Start Time','Position',[12 57 57 25],'Visible','on');
starttimemap_edit = uicontrol('Parent',anal_data,'Style','edit','FontSize',14,'Position',[72 62 45 22],'Visible','on','Callback',{@maptime_edit_callback});
endtimemap_text = uicontrol('Parent',anal_data,'Style','text','FontSize',12,'String','End Time','Position',[12 30 54 25],'Visible','on');
endtimemap_edit = uicontrol('Parent',anal_data,'Style','edit','FontSize',14,'Position',[72 35 45 22],'Visible','on','Callback',{@maptime_edit_callback});
createmap_button = uicontrol('Parent',anal_data,'Style','pushbutton','FontSize',12,'String','Calculate Map','Position',[10 2 110 30],'Visible','on','Callback',{@createmap_button_callback});
% APD specific buttons
minapd_text = uicontrol('Parent',anal_data,'Style','text','FontSize',12,'String','Min APD','Visible','on','Position',[125 57 57 25]);
minapd_edit = uicontrol('Parent',anal_data,'Style','edit','FontSize',12,'String','0','Visible','on','Position',[180 62 45 22],'Callback',{@minapd_edit_callback});
maxapd_text = uicontrol('Parent',anal_data,'Style','text','FontSize',12,'String','Max APD','Visible','on','Position',[125 30 54 25]);
maxapd_edit = uicontrol('Parent',anal_data,'Style','edit','FontSize',12,'String','1000','Visible','on','Position',[180 35 45 22],'Callback',{@maxapd_edit_callback});
percentapd_text= uicontrol('Parent',anal_data,'Style','text','FontSize',12,'String','%APD','Visible','on','Position',[230 57 45 25]);
percentapd_edit= uicontrol('Parent',anal_data,'Style','edit','FontSize',12,'String','0.8','Visible','on','Position',[275 62 45 22],'callback',{@percentapd_edit_callback});
remove_motion_click = uicontrol('Parent',anal_data,'Style','checkbox','FontSize',12,'String','Remove','Visible','on','Position',[230 35 100 25]);
remove_motion_click_txt = uicontrol('Parent',anal_data,'Style','text','FontSize',12,'String','Motion','Visible','on','Position',[248 15 50 25]);
calc_apd_button = uicontrol('Parent',anal_data,'Style','pushbutton','FontSize',12,'String','Regional APD','Position',[125 2 103 30],'Callback',{@calc_apd_button_callback});

% Allow all GUI structures to be scaled when window is dragged
set([f,p1,filelist,selectdir,refreshdir,loadfile,movie_scrn,movie_slider, signal_scrn1,signal_scrn2,signal_scrn3,...
    signal_scrn4,signal_scrn5,sweep_bar,play_button,stop_button,dispwave_button,expmov_button,view_sig,anal_data,...
    anal_select,invert_cmap,starttimemap_text,starttimemap_edit,endtimemap_text,endtimemap_edit,createmap_button,...
    minapd_text,minapd_edit,maxapd_text,maxapd_edit,percentapd_text,percentapd_edit,remove_motion_click,...
    remove_motion_click_txt,calc_apd_button,expwave_button,starttimesig_text,starttimesig_edit,endtimesig_text,...
    endtimesig_edit,az_txt,az_edit,el_txt,el_edit,cam1view_button,cam2view_button,cam3view_button,...
    cam4view_button],'Units','normalized')

% Disable buttons that will not be needed until data is loaded
set([anal_select,starttimemap_edit,starttimemap_text,endtimemap_edit,endtimemap_text,...
    createmap_button,minapd_edit,minapd_text,maxapd_edit,maxapd_text,percentapd_edit,...
    percentapd_text,remove_motion_click,remove_motion_click_txt,calc_apd_button,...
    play_button,stop_button,dispwave_button,expmov_button,starttimesig_edit,...
    endtimesig_edit,expwave_button,loadfile,refreshdir,invert_cmap,az_txt,...
    az_edit,el_txt,el_edit,cam1view_button,cam2view_button,cam3view_button,...
    cam4view_button],'Enable','off')

% Hide all analysis buttons
set([invert_cmap,starttimemap_text,starttimemap_edit,endtimemap_text,...
    endtimemap_edit,createmap_button,minapd_text,minapd_edit,maxapd_text,...
    maxapd_edit,percentapd_text,percentapd_edit,remove_motion_click,...
    calc_apd_button,remove_motion_click_txt],'Visible','off')

% % 
% Center GUI on screen
movegui(f,'center')
set(f,'Visible','on')

%% Create handles
handles.filename = [];
handles.cmosData = [];
handles.rawData = [];
handles.time = [];
handles.wave_window = 1;
handles.normflag = 0;
handles.Fs = 1000; % this is the default value. it will be overwritten
handles.starttime = 0;
handles.fileLength = 1;
handles.endtime = 1;
handles.grabbed = -1;
handles.M = []; % this handle stores the locations of the markers
handles.slide=-1; % parameter for recognize clicking location
%%minimum values pixels require to be drawn
handles.minVisible = 6;
handles.normalizeMinVisible = .3;
handles.cmap = colormap('jet'); %saves the default colormap values
handles.apdC = [];  % variable for storing apd calculations
handles.az = [];
handles.el = [];

%% All Callback functions


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% USER FUNCTIONALITY
%% Listen for mouse clicks for the point-dragger
% When mouse button is clicked and held find associated marker
    function button_down_function(obj,~)
        set(obj,'CurrentAxes',movie_scrn)
        ps = get(gca,'CurrentPoint');
        i_temp = round(ps(1,1));
        j_temp = round(ps(2,2));
        % if one of the markers on the movie screen is clicked
        if i_temp<=size(handles.cmosData,1) || j_temp<size(handles.cmosData,2) || i_temp>1 || j_temp>1
            if size(handles.M,1) > 0
                for i=1:size(handles.M,1)
                    if i_temp == handles.M(i,1) && handles.M(i,2) == j_temp
                        handles.grabbed = i;
                        break
                    end
                end
            end
        end
    end
%% When mouse button is released
    function button_up_function(~,~)
        handles.grabbed = -1;
    end

%% Update appropriate screens or slider when mouse is moved
    function button_motion_function(obj,~)
        % Update movie screen marker location
        if handles.grabbed > -1
            set(obj,'CurrentAxes',movie_scrn)
            ps = get(gca,'CurrentPoint');
            i_temp = round(ps(1,1));
            j_temp = round(ps(2,2));
            if i_temp<=size(handles.cmosData,1) && j_temp<=size(handles.cmosData,2) && i_temp>1 && j_temp>1
                handles.M(handles.grabbed,:) = [i_temp j_temp];
                i = i_temp;
                j = j_temp;
                switch handles.grabbed
                    case 1
                        plot(handles.time,squeeze(handles.cmosData(j,i,:)),'b','LineWidth',2,'Parent',signal_scrn1)
                        handles.M(1,:) = [i j];
                    case 2
                        plot(handles.time,squeeze(handles.cmosData(j,i,:)),'g','LineWidth',2,'Parent',signal_scrn2)
                        handles.M(2,:) = [i j];
                    case 3
                        plot(handles.time,squeeze(handles.cmosData(j,i,:)),'m','LineWidth',2,'Parent',signal_scrn3)
                        handles.M(3,:) = [i j];
                    case 4
                        plot(handles.time,squeeze(handles.cmosData(j,i,:)),'k','LineWidth',2,'Parent',signal_scrn4)
                        handles.M(4,:) = [i j];
                    case 5
                        plot(handles.time,squeeze(handles.cmosData(j,i,:)),'y','LineWidth',2,'Parent',signal_scrn5)
                        handles.M(5,:) = [i j];
                end
                cla
                currentframe = handles.frame;
                drawFrame(currentframe);
                M = handles.M; colax='bgmky'; [a,~]=size(M);
                hold on
                for x=1:a
                    plot(M(x,1),M(x,2),'cs','MarkerSize',8,'MarkerFaceColor',colax(x),'MarkerEdgeColor','w','Parent',movie_scrn);
                    set(movie_scrn,'YTick',[],'XTick',[],'ZTick',[]);% Hide tick markers
                end
                hold off
            end
        end
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOAD DATA
%% List that contains all files in directory
    function filelist_callback(source,~)
        str = get(source, 'String');
        val = get(source,'Value');
        file = char(str(val));
        handles.filename = file;
    end

%% Load selected files in filelist
    function loadfile_callback(~,~)
        if isempty(handles.filename)
            msgbox('Warning: No data selected','Title','warn')
        else
            % Clear off all images from previous set of data
            cla(movie_scrn); cla(signal_scrn1); cla(signal_scrn2); cla(signal_scrn3)
            cla(signal_scrn4); cla(signal_scrn5);  cla(sweep_bar)
            % Initialize handles
            handles.M = []; % this handle stores the locations of the markers
            handles.normflag = 0;% this handle indicate if normalize is clicked
            handles.wave_window = 1;% this handle indicate the window number of the next wave displayed
            handles.frame = 1;% this handles indicate the current frame being displayed by the movie screen
            handles.slide=-1;% this handle indicate if the movie slider is clicked
            % Check for *.mat file, if none convert
            filename = [handles.dir,'/',handles.filename];
            
            % Load data from *.mat file
            Data = load([filename(1:end-3),'mat']);
            
            % Load from single camera
            handles.cmosData = double(Data.dataProj(:,2:end));
            % Data dimensions
            if size(handles.cmosData,3) == 0
                handles.dataSize = 3;
            else
                handles.dataSize = 2;
            end
            % Load data points
            handles.pts = Data.pts;
            % Load triangles, centroids, and normals
            handles.cells = Data.cells;
            handles.centroids = Data.centroids;
            handles.normals = Data.norms;
            % Load neighbors and number of neighbors
            handles.nbrs = Data.neighs;
            handles.numnbrs = Data.neighnum;
            
% % %             handles.bg = double(Data.bgimage);
            % Save out pacing spike
% % %             handles.ecg = Data.channel{1}(2:end)*-1;
            % Save out frequency
            handles.Fs = double(Data.frequency);

% % %             % Save a variable to preserve  the raw cmos data
% % %             handles.cmosRawData = Data.dataProj;

            %%%%%%%%% WINDOWED DATA %%%%%%%%%%
            handles.matrixMax = .9 * max(handles.cmosData(:));
            % Initialize movie screen to the first frame
            set(f,'CurrentAxes',movie_scrn)
            handles.movie_img = trisurf(handles.cells,handles.pts(:,1),...
                handles.pts(:,2),handles.pts(:,3),handles.cmosData(:,1),...
                'LineStyle','none','Parent',movie_scrn);
            view([0 0])
            handles.az = 0;
            handles.el = 0;
            axis square
            colormap jet
% % %             set(movie_scrn,'NextPlot','replacechildren','YLim',[0.5 size(I,1)+0.5],...
% % %                 'YTick',[],'XLim',[0.5 size(I,2)+0.5],'XTick',[])
            % Scale signal screens and sweep bar to appropriate time scale
            timeStep = 1/handles.Fs;
            handles.time = 0:timeStep:size(handles.cmosData,2)*timeStep-timeStep;
            set(signal_scrn1,'XLim',[min(handles.time) max(handles.time)])
            set(signal_scrn1,'NextPlot','replacechildren')
            set(signal_scrn2,'XLim',[min(handles.time) max(handles.time)])
            set(signal_scrn2,'NextPlot','replacechildren')
            set(signal_scrn3,'XLim',[min(handles.time) max(handles.time)])
            set(signal_scrn3,'NextPlot','replacechildren')
            set(signal_scrn4,'XLim',[min(handles.time) max(handles.time)])
            set(signal_scrn4,'NextPlot','replacechildren')
            set(signal_scrn5,'XLim',[min(handles.time) max(handles.time)])
            set(signal_scrn5,'NextPlot','replacechildren')
            set(sweep_bar,'XLim',[min(handles.time) max(handles.time)])
            set(sweep_bar,'NextPlot','replacechildren')
            % Fill times into activation map editable textboxes
            handles.starttime = 0;
            handles.endtime = max(handles.time);
            set(starttimesig_edit,'String',num2str(handles.starttime))
            set(endtimesig_edit,'String',num2str(handles.endtime))
            set(starttimemap_edit,'String',num2str(handles.starttime))
            set(endtimemap_edit,'String',num2str(handles.endtime))
            % Initialize movie slider to the first frame
            set(movie_slider,'Value',0)
% % %             drawFrame(1);
            % Enable signal processing and analysis tools
            set([play_button,anal_select,stop_button,dispwave_button,...
                expmov_button,starttimesig_edit,endtimesig_edit,...
                expwave_button,az_txt,az_edit,el_txt,el_edit,...
                cam1view_button,cam2view_button,cam3view_button,...
                cam4view_button],'Enable','on')
        end
    end

%% Select directory for optical files
    function selectdir_callback(~,~)
        dir_name = uigetdir;
        if dir_name ~= 0
            handles.dir = dir_name;
            search_name = [dir_name,'/*.mat'];
%             search_nameNew = [dir_name,'/*.gsh'];
            handles.file_list = struct2cell(dir(search_name));
%             filesNew = struct2cell(dir(search_nameNew));
%             handles.file_list = [files(1,:)'; filesNew(1,:)'];
            set(filelist,'String',handles.file_list(1,:)')
            handles.filename = char(handles.file_list(1));
            % enable the refresh directory and load file buttons
            set([loadfile,refreshdir],'Enable','on')
            % reset analysis window
            set(anal_select,'Value',1)
            set([invert_cmap,starttimemap_text,starttimemap_edit,endtimemap_text,...
                endtimemap_edit,createmap_button,minapd_text,minapd_edit,maxapd_text,...
                maxapd_edit,percentapd_text,percentapd_edit,remove_motion_click,...
                remove_motion_click_txt],'Visible','off','Enable','on')
            % turn off all other buttons
            set([anal_select,starttimemap_edit,starttimemap_text,endtimemap_edit,...
                endtimemap_text,createmap_button,minapd_edit,minapd_text,...
                maxapd_edit,maxapd_text,percentapd_edit,percentapd_text,...
                remove_motion_click,remove_motion_click_txt,play_button,...
                stop_button,dispwave_button,expmov_button,starttimesig_edit,...
                endtimesig_edit,expwave_button,invert_cmap,],'Enable','off')
        end
    end

%% Refresh file list (in case more files are open after directory is selected)
    function refreshdir_callback(~,~)
        dir_name = handles.dir;
        search_name = [dir_name,'/*.rsh'];
        search_nameNew = [dir_name,'/*.gsh'];
        files = struct2cell(dir(search_name));
        filesNew = struct2cell(dir(search_nameNew));
        handles.file_list = [files(1,:)'; filesNew(1,:)'];
        set(filelist,'String',handles.file_list)
        handles.filename = char(handles.file_list(1));
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MOVIE SCREEN
%% Movie Slider Functionality
    function movieslider_callback(source,~)
        % Check which type of data is mapped
        if get(anal_select,'Value') == 1
            data = handles.cmosData;
        elseif get(anal_select,'Value') == 5
            data = handles.phase;
        elseif get(anal_select,'Value') == 7
            data = handles.wf;
        end
        % Update data based on slider
        val = get(source,'Value');
        i = round(val*size(data,2))+1;
        handles.frame = i;
        if handles.frame == size(data,2) + 1
            i = size(data,2);
            handles.frame = size(data,2);
        end   
        % Update movie screen
        set(movie_scrn,'NextPlot','replacechildren','YTick',[],'XTick',[]);
        set(f,'CurrentAxes',movie_scrn)
        handles.movie_img = trisurf(handles.cells,handles.pts(:,1),...
            handles.pts(:,2),handles.pts(:,3),data(:,i),...
            'LineStyle','none','Parent',movie_scrn);
        view([handles.az handles.el])
        axis square
        colormap jet

        if get(anal_select,'Value') == 1
            % Update markers with each frame
            M = handles.M;[a,~]=size(M); colax='bgmky';
            hold on
            for x=1:a
                scatter3(M(x,1),M(x,2),M(x,3),colax(x),'filled','MarkerEdgeColor','k','LineWidth',2,'SizeData',48,'Parent',movie_scrn)
            end
            pause(0.01)        % Update sweep bar
        end
        set(f,'CurrentAxes',sweep_bar)
        a = [handles.time(i) handles.time(i)];b = [0 1]; cla
        plot(a,b,'r','Parent',sweep_bar)
        axis([handles.starttime handles.endtime 0 1])
        hold off; axis off
    end

%% Draw
    function drawFrame(frame)
        G = handles.bgRGB;
        Mframe = handles.cmosData(:,:,frame);
        if handles.normflag == 0
            Mmax = handles.matrixMax;
            Mmin = handles.minVisible;
            numcol = size(jet,1);
            J = ind2rgb(round((Mframe - Mmin) ./ (Mmax - Mmin) * (numcol - 1)), 'jet');
            A = real2rgb(Mframe >= handles.minVisible, 'gray');
        else
            J = real2rgb(Mframe, 'jet');
            A = real2rgb(Mframe >= handles.normalizeMinVisible, 'gray');
        end
        I = J .* A + G .* (1 - A);
        image(I,'Parent',movie_scrn);
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DISPLAY CONTROL
%% Play button functionality
    function play_button_callback(~,~)
        if isempty(handles.cmosData)
            msgbox('Warning: No data selected','Title','warn')
        else
            % Check which type of data is mapped
            if get(anal_select,'Value') == 1
                data = handles.cmosData;
            elseif get(anal_select,'Value') == 5
                data = handles.phase;
            elseif get(anal_select,'Value') == 7
                data = handles.wf;
            end
            handles.playback = 1; % if the PLAY button is clicked
            startframe = handles.frame;
            % Update movie screen with new frames
            for i = startframe:5:size(data,2)
                if handles.playback == 1 % recheck if the PLAY button is clicked
                    set(movie_scrn,'NextPlot','replacechildren','YTick',[],'XTick',[]);
                    set(f,'CurrentAxes',movie_scrn)
                    handles.movie_img = trisurf(handles.cells,handles.pts(:,1),...
                        handles.pts(:,2),handles.pts(:,3),data(:,i),...
                        'LineStyle','none','Parent',movie_scrn);
                    view([handles.az handles.el])
                    axis square
                    colormap jet
                    pause(0.01)
                    if get(anal_select,'Value') == 7
                        caxis([0 1])
                    end
                    %                     set(movie_scrn,'NextPlot','replacechildren','YTick',[],'XTick',[]);
                    
                    handles.frame = i;
                    % Update markers with each frame
                    if get(anal_select,'Value') == 1 || 7
                        M = handles.M;[a,~]=size(M); colax='bgmky';
                        hold on
                        for x=1:a
                            scatter3(M(x,1),M(x,2),M(x,3),colax(x),'filled','MarkerEdgeColor','k','LineWidth',2,'SizeData',48,'Parent',movie_scrn)
                            % % %                         set(movie_scrn,'YTick',[],'XTick',[],'ZTick',[]);% Hide tick markes
                        end
                        % %                     pause(0.01)
                    end
                    % Update movie slider
                    set(movie_slider,'Value',(i-1)/size(data,2))
                    % Update sweep bar
                    set(f,'CurrentAxes',sweep_bar)
                    a = [handles.time(i) handles.time(i)];b = [0 1]; cla
                    plot(a,b,'r','Parent',sweep_bar)
                    axis([handles.starttime handles.endtime 0 1])
                    hold off; axis off
                    %                     pause(0.01);
                else
                    break
                end
            end
            handles.frame = i;
            set(f,'CurrentAxes',movie_scrn)
            handles.movie_img = trisurf(handles.cells,handles.pts(:,1),...
                handles.pts(:,2),handles.pts(:,3),data(:,handles.frame),...
                'LineStyle','none','Parent',movie_scrn);
            view([handles.az handles.el])
            axis square
            colormap jet
%             set(movie_scrn,'NextPlot','replacechildren','YTick',[],'XTick',[],'ZTick',[]);

            % Update movie slider
            set(movie_slider,'Value',(i-1)/size(data,2))
            % Update sweep bar
            set(f,'CurrentAxes',sweep_bar)
            a = [handles.time(i) handles.time(i)];b = [0 1]; cla
            plot(a,b,'r','Parent',sweep_bar)
            axis([handles.starttime handles.endtime 0 1])
            hold off; axis off
        end
    end

%% Stop button functionality
    function stop_button_callback(~,~)
        handles.playback = 0;
    end

%% Display Wave Button Functionality
    function dispwave_button_callback(~,~)
        % Check which type of data is mapped
        if get(anal_select,'Value') == 1
            data = handles.cmosData;
        elseif get(anal_select,'Value') == 5
            data = handles.phase;
        elseif get(anal_select,'Value') == 7
            data = handles.wf;
        end
        
        set(f,'CurrentAxes',movie_scrn)
        % Data cursor
        datacursormode on
        dcmObj = datacursormode(f);
        set(dcmObj,'SnapToDataVertex','off','Enable','on')
        % %         loop = 1;
        
        waitforbuttonpress;
        point1 = getCursorInfo(dcmObj);
        if isempty(point1)
            % Tell user they need to have their eyes checked
            msgbox('Warning: Selection not on surface!','Title','help')
            % Set check to 0
            check = 0;
        else
            % Set check to 1
            check = 1;
            % Get coordinates of selected point
            x = point1.Position(1);
            y = point1.Position(2);
            z = point1.Position(3);
            % Write exit option
            
            % Remove data cursor
%             set(dcmObj,'Enable','off')
            % % %             delete(findall(gcf,'Type','hggroup'));
            
            % 1. find the nearest face centroid
            % 2. identify if the normal faces away or toward the camera
            % 3. if away, draw a line through the heart to find a point on the camera facing side
            % 4. if toward plot point and signal of said face
            
            % 1.
            nearCent = handles.centroids - repmat([x y z],[size(handles.centroids,1) 1]);
            nearCent = sqrt(sum(nearCent.^2,2));
            [~,nearCentInd] = min(nearCent);
            % 2.
            % % %             faceNormal = handles.normals(nearCentInd,:);
            % Calculate normal vector of camera view
            camH = cosd(handles.el)*1;
            camY = -1*cosd(handles.az)*camH;
            camX = sind(handles.az)*camH;
            camZ = sind(handles.el)*1;
            camAng = [camX camY camZ];
            % Find the angle between the camera vector and the centroid normal
            angDiff = acosd((camAng*point1.Position')/(sqrt(sum(camAng.^2))*sqrt(sum(point1.Position.^2))));
            if angDiff > 90
                % % %                 % Plot selected point
                % % %                 backCent = [handles.centroids(nearCentInd,1) handles.centroids(nearCentInd,2) handles.centroids(nearCentInd,3)];
                % % %                 hold on
                % % %                 scatter3(backCent(1),backCent(2),backCent(3),'ro','filled','SizeData',96,'Parent',movie_scrn)
                % % %                 plot3([backCent(1) backCent(1)+camX*20],[backCent(2) backCent(2)+camY*20],[backCent(3) backCent(3)+camZ*20],'c')
                % Remove the nearest centroid index from the list of indices
                otherInd = (1:size(handles.centroids,1))';
                otherInd(nearCentInd) = [];
                % Find the angles between selected point and all` other points
                % % %             camAng = repmat(camAng,[size(handles.centroids,1)-1 1]);
                % Calculate the vectors to each centroid from the selected one
                otherVec = handles.centroids(otherInd,:) - repmat(handles.centroids(nearCentInd,:),[size(handles.centroids,1)-1 1]);
                otherVecMag = sqrt(sum(otherVec.^2,2));
                % Find the projection of the camera vector onto each of these
                otherDiff = acosd(camAng/sqrt(sum(camAng.^2))*(otherVec./repmat(otherVecMag,[1 size(otherVec,2)]))');
                % % %             otherDiff = acosd((camAng*handles.centroids(otherInd,:)')./...
                % % %                 (sqrt(sum(camAng.^2)).*sqrt(sum(otherVec.^2,2)))');
                % Find the point with the smallest angle
                [~,angInd] = min(otherDiff);
                % Assign new point
                if angInd < nearCentInd
                    nearCentInd = angInd;
                    newDispPt = handles.centroids(nearCentInd,:);
                else
                    % Compensate for removal of first centroid from selection
                    nearCentInd = angInd+1;
                    newDispPt = handles.centroids(angInd,:);
                end
                % Plot new point
                % % %                 hold on
                scatter3(newDispPt(1),newDispPt(2),newDispPt(3),'ro','filled','SizeData',96,'Parent',movie_scrn)
            else
                % Update point
                newDispPt = point1.Position;
                % Plot original point
                scatter3(newDispPt(1),newDispPt(2),newDispPt(3),'ko','filled','SizeData',96,'Parent',movie_scrn)
            end
        end
        
        % Plot to surface
        if check == 1;
            % Find the correct wave window
            if handles.wave_window == 6
                handles.wave_window = 1;
            end
            wave_window = handles.wave_window;
            switch wave_window
                case 1
                    plot(handles.time,handles.cmosData(nearCentInd,:),'b','LineWidth',2,'Parent',signal_scrn1)
                    handles.M(1,:) = newDispPt;
                case 2
                    plot(handles.time,handles.cmosData(nearCentInd,:),'g','LineWidth',2,'Parent',signal_scrn2)
                    handles.M(2,:) = newDispPt;
                case 3
                    plot(handles.time,handles.cmosData(nearCentInd,:),'m','LineWidth',2,'Parent',signal_scrn3)
                    handles.M(3,:) = newDispPt;
                case 4
                    plot(handles.time,handles.cmosData(nearCentInd,:),'k','LineWidth',2,'Parent',signal_scrn4)
                    handles.M(4,:) = newDispPt;
                case 5
                    plot(handles.time,handles.cmosData(nearCentInd,:),'y','LineWidth',2,'Parent',signal_scrn5)
                    handles.M(5,:) = newDispPt;
            end
            
            handles.wave_window = wave_window + 1; % Dial up the wave window count
            % Update movie screen with new markers
            cla(movie_scrn)
            trisurf(handles.cells,handles.pts(:,1),...
                handles.pts(:,2),handles.pts(:,3),data(:,1),...
                'LineStyle','none','Parent',movie_scrn);
            view([handles.az handles.el])
            % Setup color and size of markers
            M = handles.M; colax='bgmky'; [a,~]=size(M);
            hold on
            for x=1:a
                scatter3(M(x,1),M(x,2),M(x,3),colax(x),'filled','MarkerEdgeColor','k','LineWidth',2,'SizeData',48,'Parent',movie_scrn)
                axis square
%                 set(movie_scrn,'YTick',[],'XTick',[],'ZTick',[]);% Hide tick markes
            end
            hold off
        end
    end

%% Export movie to .avi file
%Construct a VideoWriter object and view its properties. Set the frame rate to 60 frames per second:
    function expmov_button_callback(~,~)
        % Save the movie to the same directory as the cmos data
        % Request the directory for saving the file
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
        filename = char(filename);
        % Create path to file
        movname = [handles.dir,'/',filename,'.avi'];
        % Create the figure to be filmed        
        fig=figure('Name',filename,'NextPlot','replacechildren','NumberTitle','off',...
            'Visible','off','OuterPosition',[170, 140, 556,715]);
        % Start writing the video
        vidObj = VideoWriter(movname,'Motion JPEG AVI');
        open(vidObj);
        movegui(fig,'center')
        set(fig,'Visible','on')
        axis tight
        set(gca,'nextplot','replacechildren');
        % Designate the step of based on the frequency
        
        % Creat pop up screen; the start time and end time are determined
        % by the windowing of the signals on the Rhythm GUI interface
        
        % Grab start and stop time times and convert to index values by
        % multiplying by frequency, add one to shift from zero
        start = str2double(get(starttimesig_edit,'String'))*handles.Fs+1;   
        fin = str2double(get(endtimesig_edit,'String'))*handles.Fs+1;
        % Designate the resolution of the video: ex. 5 = every fifth frame
        step = 5;
        for i = start:step:fin
            % Plot sweep bar on bottom subplot
            subplot('Position',[0.05, 0.1, 0.9,0.15])
            a = [handles.time(i) handles.time(i)];
            b = [min(handles.ecg) max(handles.ecg)];
            cla
            plot(a,b,'r','LineWidth',1.5);hold on
            % Plot ecg data on bottom subplot
            subplot('Position',[0.05, 0.1, 0.9,0.15])
            % Create a variable for the endtime index
            endtime = round(handles.endtime*handles.Fs);
            % Plot the desired
            plot(handles.time(start:endtime),handles.ecg(start:endtime));
            % 
            axis([handles.time(start) handles.time(fin) min(handles.ecg) max(handles.ecg)])
            % Set the xick mark to start from zero
            xlabel('Time (sec)');hold on
            % Image movie frames on the top subplot
            subplot('Position',[0.05, 0.28, 0.9,0.68])
            % Update image
            G = handles.bgRGB;
            Mframe = handles.cmosData(:,:,i);
            if handles.normflag == 0
                Mmax = handles.matrixMax;
                Mmin = handles.minVisible;
                numcol = size(jet,1);
                J = ind2rgb(round((Mframe - Mmin) ./ (Mmax - Mmin) * (numcol - 1)), jet);
                A = real2rgb(Mframe >= handles.minVisible, 'gray');
            else
                J = real2rgb(Mframe, 'jet');
                A = real2rgb(Mframe >= handles.normalizeMinVisible, 'gray');
            end
            
            I = J .* A + G .* (1 - A);
            image(I);
            axis off; hold off
            F = getframe(fig);
            writeVideo(vidObj,F);% Write each frame to the file.
        end
        close(fig);
        close(vidObj); % Close the file.
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SIGNAL SCREENS
%% Start Time Editable Textbox for Signal Screens
    function starttimesig_edit_callback(source,~)
        %get the val01 (lower limit) and val02 (upper limit) plot values
        val01 = str2double(get(source,'String'));
        val02 = str2double(get(endtimesig_edit,'String'));
        if val01 >= 0 && val01 <= (size(handles.cmosData,handles.dataSize)-1)*handles.Fs
            set(signal_scrn1,'XLim',[val01 val02]);
            set(signal_scrn2,'XLim',[val01 val02]);
            set(signal_scrn3,'XLim',[val01 val02]);
            set(signal_scrn4,'XLim',[val01 val02]);
            set(signal_scrn5,'XLim',[val01 val02]);
            set(sweep_bar,'XLim',[val01 val02]);
        else
            error = 'The START TIME must be greater than %d and less than %.3f.';
            msgbox(sprintf(error,0,max(handles.time)),'Incorrect Input','Warn');
            set(source,'String',0)
        end
        % Update the start time value
        handles.starttime = val01;
    end

%% End Time Editable Textbox for Signal Screens
    function endtimesig_edit_callback(source,~)
        val01 = str2double(get(starttimesig_edit,'String'));
        val02 = str2double(get(source,'String'));
        if val02 >= 0 && val02 <= (size(handles.cmosData,handles.dataSize)-1)*handles.Fs
            set(signal_scrn1,'XLim',[val01 val02]);
            set(signal_scrn2,'XLim',[val01 val02]);
            set(signal_scrn3,'XLim',[val01 val02]);
            set(signal_scrn4,'XLim',[val01 val02]);
            set(signal_scrn5,'XLim',[val01 val02]);
            set(sweep_bar,'XLim',[val01 val02]);
        else
            error = 'The END TIME must be greater than %d and less than %.3f.';
            msgbox(sprintf(error,0,max(handles.time)),'Incorrect Input','Warn');
            set(source,'String',max(handles.time))
        end
        % Update the end time value
        handles.endtime = val02;
    end

%% Export signal waves to new screen
    function expwave_button_callback(~,~)
        M = handles.M; colax='bgmky'; [a,~]=size(M);
        if isempty(M)
            msgbox('No wave to export. Please use "Display Wave" button to select pixels on movie screen.','Icon','help')
        else
            w=figure('Name','Signal Waves','NextPlot','add','NumberTitle','off',...
                'Visible','off','OuterPosition',[100, 50, 555,120*a+80]);
            for x = 1:a
                subplot('Position',[0.06 (120*(a-x)+70)/(120*a+80) 0.9 110/(120*a+80)])
                plot(handles.time,squeeze(handles.cmosData(M(x,2),M(x,1),:)),'color',colax(x),'LineWidth',2)
                xlim([handles.starttime handles.endtime]);
                hold on
                if x == a
                else
                    set(gca,'XTick',[])
                end
            end
            xlabel('Time (sec)')
            hold off
            movegui(w,'center')
            set(w,'Visible','on')
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Data Analysis Selection
    function anal_select_callback(~,~)
        % Get the type of analysis
        anal_state = get(anal_select,'Value');
        % Adjustment of buttons based on analysis
        if anal_state == 1
            % Turn all buttons off and hide
            set([invert_cmap,starttimemap_text,starttimemap_edit,endtimemap_text,...
                endtimemap_edit,minapd_text,minapd_edit,maxapd_text,...
                maxapd_edit,percentapd_text,percentapd_edit,remove_motion_click,...
                remove_motion_click_txt,calc_apd_button],'Visible','off',...
                'Enable','off')
            % Turn createmap button off
            set(createmap_button,'Enable','off')
           
            % MEMBRANE POTENTIAL
            % Current frame
            i = handles.frame;
            % Plot
            set(f,'CurrentAxes',movie_scrn)
            handles.movie_img = trisurf(handles.cells,handles.pts(:,1),...
                handles.pts(:,2),handles.pts(:,3),handles.cmosData(:,handles.frame),...
                'LineStyle','none','Parent',movie_scrn);
            view([handles.az handles.el])
            axis square
            colormap jet
            %             set(movie_scrn,'NextPlot','replacechildren','YTick',[],'XTick',[],'ZTick',[]);
            
            % Update movie slider
            set(movie_slider,'Value',(i-1)/size(handles.cmosData,2))
            % Update sweep bar
            set(f,'CurrentAxes',sweep_bar)
            a = [handles.time(i) handles.time(i)];b = [0 1]; cla
            plot(a,b,'r','Parent',sweep_bar)
            axis([handles.starttime handles.endtime 0 1])
            hold off; axis off
            % Turn on movie slider
            set(movie_slider,'Visible','on')
            % Turn colorbar off just in case
            colorbar off
        elseif anal_state == 2
            % Turn needed buttons on
            set([invert_cmap,starttimemap_text,starttimemap_edit,endtimemap_text,...
                endtimemap_edit,createmap_button],'Visible','on','Enable','on')
            % Turn unneeded buttons off
            set([minapd_text,minapd_edit,maxapd_text,maxapd_edit,percentapd_text,...
                percentapd_edit,remove_motion_click,remove_motion_click_txt,...
                calc_apd_button],'Visible','off','Enable','off')
        elseif anal_state == 3
            % Turn needed buttons on
            set([invert_cmap,starttimemap_text,starttimemap_edit,endtimemap_text,...
                endtimemap_edit,createmap_button],'Visible','on','Enable','on')
            % Turn unneeded buttons off
            set([minapd_text,minapd_edit,maxapd_text,maxapd_edit,percentapd_text,...
                percentapd_edit,remove_motion_click,remove_motion_click_txt,...
                calc_apd_button],'Visible','off','Enable','off')
        elseif anal_state == 4
            % Turn needed buttons on
            set([invert_cmap,starttimemap_text,starttimemap_edit,endtimemap_text,...
                endtimemap_edit,createmap_button,minapd_text,minapd_edit,maxapd_text,...
                maxapd_edit,percentapd_text,percentapd_edit,remove_motion_click,...
                calc_apd_button,remove_motion_click_txt],'Visible','on','Enable','on')
        elseif anal_state == 5
            % Turn on create map button
            set(createmap_button,'Visible','on','Enable','on')
            % Turn all buttons off except the create map button
            set([invert_cmap,starttimemap_text,starttimemap_edit,endtimemap_text,...
                endtimemap_edit,minapd_text,minapd_edit,maxapd_text,maxapd_edit,...
                percentapd_text,percentapd_edit,remove_motion_click,calc_apd_button,...
                remove_motion_click_txt],'Visible','off','Enable','off')
        elseif anal_state == 6
            % Turn on create map button
            set(createmap_button,'Visible','on','Enable','on')
            % Turn all buttons off except the create map button
            set([invert_cmap,starttimemap_text,starttimemap_edit,endtimemap_text,...
                endtimemap_edit,minapd_text,minapd_edit,maxapd_text,maxapd_edit,...
                percentapd_text,percentapd_edit,remove_motion_click,calc_apd_button,...
                remove_motion_click_txt],'Visible','off','Enable','off')
        elseif anal_state == 7
            % Turn on create map button
            set(createmap_button,'Visible','on','Enable','on')
            % Turn all buttons off except the create map button
            set([invert_cmap,starttimemap_text,starttimemap_edit,endtimemap_text,...
                endtimemap_edit,minapd_text,minapd_edit,maxapd_text,maxapd_edit,...
                percentapd_text,percentapd_edit,remove_motion_click,calc_apd_button,...
                remove_motion_click_txt],'Visible','off','Enable','off')
        end 
    end

%% Regional APD Calculation
    function calc_apd_button_callback(~,~)
        % Read APD Parameters
        handles.percentAPD = str2double(get(percentapd_edit,'String'));
        handles.maxapd = str2double(get(maxapd_edit,'String'));
        handles.minapd = str2double(get(minapd_edit,'String'));
        % Read remove motion check box
        remove_motion_state =get(remove_motion_click,'Value');
        axes(movie_scrn)
        coordinate=getrect(movie_scrn);
        gg=msgbox('Creating Regional APD...');
        apdCalc(handles.cmosData,handles.a_start,handles.a_end,handles.Fs,...
            handles.percentAPD,handles.maxapd,handles.minapd,remove_motion_state,...
            coordinate,handles.bg,handles.cmap);
        close(gg)
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INVERT COLORMAP: inverts the colormaps for all isochrone maps
    function invert_cmap_callback(~,~)
        % Function Description: The checkbox function like toggle button. 
        % There are only 2 options and since the box starts unchecked, 
        % checking it will invert the map, uncheckecking it will invert it 
        % back to its original state. As such no additional code is needed.
        
        % grab the current value of the colormap
        cmap = handles.cmap;
        % invert the existing colormap values
        handles.cmap = flipud(cmap);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ACTIVATION MAP
%% Callback for Start and End Time for Analysis
     function maptime_edit_callback(~,~)
         % get the bounds of the viewing window
         vw_start = str2double(get(starttimesig_edit,'String'));
         vw_end = str2double(get(endtimesig_edit,'String'));
         % get the bounds of the activation window
         a_start = str2double(get(starttimemap_edit,'String'));
         a_end = str2double(get(endtimemap_edit,'String'));
         if a_start >= 0 && a_start <= max(handles.time)
             if a_end >= 0 && a_end <= max(handles.time)
                 set(f,'CurrentAxes',sweep_bar)
                 a = [a_start a_start];b = [0 1];cla
                 plot(a,b,'g','Parent',sweep_bar)
                 hold on
                 a = [a_end a_end];b = [0 1];
                 plot(a,b,'-g','Parent',sweep_bar)
                 axis([vw_start vw_end 0 1])
                 hold off; axis off
                 hold off
                 handles.a_start = a_start;
                 handles.a_end = a_end;
             else
                 error = 'The END TIME must be greater than %d and less than %.3f.';
                 msgbox(sprintf(error,0,max(handles.time)),'Incorrect Input','Warn');
                 set(endtimemap_edit,'String',max(handles.time))
             end
         else
             error = 'The START TIME must be greater than %d and less than %.3f.';
             msgbox(sprintf(error,0,max(handles.time)),'Incorrect Input','Warn');
             set(starttimemap_edit,'String',0)
         end
     end
 
%% Button to create analysis maps
    function createmap_button_callback(~,~)
        % CHECK ANALYSIS MODE
        check = get(anal_select,'Value');
        % FOR ACTIVATION
        if check == 2
            gg=msgbox('Building  Activation Map...');
            % Activation map function
            handles.actMap = aMap(handles.cmosData,handles.a_start,handles.a_end,handles.Fs,handles.cmap);
            close(gg)
            % If panoramic, map to geometry
            if size(handles.cmosData,3) == 1
                % Update movie screen with new markers
                cla(movie_scrn)
                trisurf(handles.cells,handles.pts(:,1),...
                    handles.pts(:,2),handles.pts(:,3),handles.actMap,...
                    'LineStyle','none','Parent',movie_scrn);
                view([handles.az handles.el])
                colorbar
% % %                 % Setup color and size of markers
% % %                 M = handles.M; colax='bgmky'; [a,~]=size(M);
% % %                 hold on
% % %                 for x=1:a
% % %                     scatter3(M(x,1),M(x,2),M(x,3),colax(x),'filled','MarkerEdgeColor','k','LineWidth',2,'SizeData',48,'Parent',movie_scrn)
% % %                     axis square
% % %                     % set(movie_scrn,'YTick',[],'XTick',[],'ZTick',[]);% Hide tick markes
% % %                 end
% % %                 hold off
            end
            set(movie_slider,'Visible','off')
            
        % FOR CONDUCTION VELOCITY
        elseif check == 3
            rect = getrect(movie_scrn);
            gg=msgbox('Building Conduction Velocity Map...');
            cMap(handles.cmosData,handles.a_start,handles.a_end,handles.Fs,handles.bg,rect);
            close(gg)
        % FOR ACTION POTENTIAL DURATION
        elseif check == 4
            gg=msgbox('Creating Global APD Map...');
            handles.percentAPD = str2double(get(percentapd_edit,'String'));
            apdMap(handles.cmosData,handles.a_start,handles.a_end,handles.Fs,handles.percentAPD,handles.cmap);
            close(gg)
        % FOR PHASE MAP CALCULATION
        elseif check == 5
            phase = phaseMap(handles.cmosData,handles.starttime,handles.endtime,handles.Fs,handles.cmap);
             % If panoramic, map to geometry
            if size(handles.cmosData,3) == 1
                % Update movie screen with new markers
                cla(movie_scrn)
                trisurf(handles.cells,handles.pts(:,1),...
                    handles.pts(:,2),handles.pts(:,3),phase(:,handles.frame),...
                    'LineStyle','none','Parent',movie_scrn);
                view([handles.az handles.el])
                axis square
            end
            handles.phase = phase;
            % Enable movie slider
            set(movie_slider,'Visible','on')
        % FOR DOMINANT FREQUENCY CALCULATION 
        elseif check == 6
            gg=msgbox('Calculating Dominant Frequency Map...');
            maxf = calDomFreq(handles.cmosData,handles.Fs,handles.cmap);
            close(gg)
            if size(handles.cmosData,3) == 1
                % Update movie screen with new markers
                cla(movie_scrn)
                trisurf(handles.cells,handles.pts(:,1),...
                    handles.pts(:,2),handles.pts(:,3),maxf,...
                    'LineStyle','none','Parent',movie_scrn);
                view([handles.az handles.el])
                colorbar
                axis square
            end
            handles.maxf = maxf;
            % Disable movie slider
            set(movie_slider,'Visible','off')
        % WAVEFRONT VISUALIZATION
        elseif check == 7
            gg=msgbox('Generating Wavefront Visualization...');
            wf = waveFront(handles.cmosData);
            close(gg)
            % Update movie screen
            cla(movie_scrn)
            trisurf(handles.cells,handles.pts(:,1),...
                handles.pts(:,2),handles.pts(:,3),wf(:,handles.frame),...
                'LineStyle','none','Parent',movie_scrn);
            view([handles.az handles.el])
            colorbar
            axis square
            % Save wavefront information
            handles.wf = wf;
            % Enable movie slider
            set(movie_slider,'Visible','on')
        end
    end

%% Azimuth Angle Callback %%
    function az_edit_callback(source,~)
        % Grab angle value from edit box
        az = str2double(source.String);
        % Verify that the angle lies between -360 and 360
        if az > 360
            set(az_edit,'String',num2str(handles.az))
        elseif az < -360
            set(az_edit,'String',num2str(handles.az))
        elseif isnan(az)
            set(az_edit,'String',num2str(handles.az))
        else
            % Adjust view according to new azimuth value
            set(f,'CurrentAxes',movie_scrn)
            view([az handles.el])
            axis square
            % Save new azimuth value to handles
            handles.az = az;
        end
    end

%% Elevation Angle Callback %%
    function el_edit_callback(source,~)
         % Grab angle value from edit box
        el = str2double(source.String);
        % Verify that the angle lies between -360 and 360
        if el > 360
            set(el_edit,'String',num2str(handles.el))
        elseif el < -360
            set(el_edit,'String',num2str(handles.el))
        elseif isnan(el)
            set(el_edit,'String',num2str(handles.el))
        else
            % Adjust view according to new azimuth value
            set(f,'CurrentAxes',movie_scrn)
            view([handles.az el])
            axis square
            % Save new elevation value to handles
            handles.el = el;
        end
    end

%% Camera View 1 Button Callback %%
    function cam1view_button_callback(~,~)
        % Adjust view according to camera 1 position
        set(f,'CurrentAxes',movie_scrn)
        % Adjust azimuth and elevation values
        handles.az = -45;
        set(az_edit,'String',num2str(handles.az))
        handles.el = 0;
        set(el_edit,'String',num2str(handles.el))
        % Adjust the view
        view([handles.az handles.el])
        axis square
    end

%% Camera View 2 Button Callback %%
    function cam2view_button_callback(~,~)
        % Adjust view according to camera 1 position
        set(f,'CurrentAxes',movie_scrn)
        % Adjust azimuth and elevation values
        handles.az = -135;
        set(az_edit,'String',num2str(handles.az))
        handles.el = 0;
        set(el_edit,'String',num2str(handles.el))
        % Adjust the view
        view([handles.az handles.el])
        axis square
    end

%% Camera View 3 Button Callback %%
    function cam3view_button_callback(~,~)
        % Adjust view according to camera 1 position
        set(f,'CurrentAxes',movie_scrn)
        % Adjust azimuth and elevation values
        handles.az = -225;
        set(az_edit,'String',num2str(handles.az))
        handles.el = 0;
        set(el_edit,'String',num2str(handles.el))
        % Adjust the view
        view([handles.az handles.el])
        axis square
    end

%% Camera View 4 Button Callback %%
    function cam4view_button_callback(~,~)
        % Adjust view according to camera 1 position
        set(f,'CurrentAxes',movie_scrn)
        % Adjust azimuth and elevation values
        handles.az = 45;
        set(az_edit,'String',num2str(handles.az))
        handles.el = 0;
        set(el_edit,'String',num2str(handles.el))
        % Adjust the view
        view([handles.az handles.el])
        axis square
    end


end

