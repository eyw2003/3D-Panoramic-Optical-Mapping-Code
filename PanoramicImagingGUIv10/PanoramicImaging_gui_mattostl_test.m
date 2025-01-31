function varargout = PanoramicImaging_gui(varargin)
% DICERECONSTRUCTION_GUI MATLAB code for PanoramicImaging_gui.fig
%      DICERECONSTRUCTION_GUI, by itself, creates a new DICERECONSTRUCTION_GUI or raises the existing
%      singleton*.
%
%      H = DICERECONSTRUCTION_GUI returns the handle to a new DICERECONSTRUCTION_GUI or the handle to
%      the existing singleton*.
%
%      DICERECONSTRUCTION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DICERECONSTRUCTION_GUI.M with the given input arguments.
%
%      DICERECONSTRUCTION_GUI('Property','Value',...) creates a new DICERECONSTRUCTION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PanoramicImaging_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PanoramicImaging_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PanoramicImaging_gui

% Last Modified by GUIDE v2.5 17-Jul-2018 16:51:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PanoramicImaging_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @PanoramicImaging_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before PanoramicImaging_gui is made visible.
function PanoramicImaging_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PanoramicImaging_gui (see VARARGIN)

% Choose default command line output for PanoramicImaging_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PanoramicImaging_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PanoramicImaging_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- CALIBRATION When a Camera name is selected in the popup menu, the
% corresponding reference image is displayed in the top right figure panel.
function mask_fileselect_Callback(hObject, eventdata, handles)
% hObject    handle to mask_fileselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mask_fileselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mask_fileselect
handles.output = hObject;

popup_sel_index = get(handles.mask_fileselect, 'Value');

switch popup_sel_index
    case 1 % Select a file...
        % GUI does nothing
    case 2 % Camera A
        axes(handles.axes4);
        Im = imread('CamACalReference.png');
        imshow(Im);
        axis image
    case 3 % Camera B        
        axes(handles.axes4);
        Im = imread('CamBCalReference.png');
        imshow(Im);
        axis image
    case 4 % Camera C        
        axes(handles.axes4);
        Im = imread('CamCCalReference.png');
        imshow(Im);
        axis image
    case 5 % Camera D        
        axes(handles.axes4);
        Im = imread('CamDCalReference.png');
        imshow(Im);
        axis image
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function mask_fileselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mask_fileselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- CALIBRATION When the button Calculate Calibration matrices is
% pressed, the selected points and the reference points from the
% calibration file SmallDiceTilted_PierreCalibration are used as inputs of
% the function CalibratePhantom4OptMap4Cams.
function maskfinishedbutton_Callback(hObject, eventdata, handles)
% hObject    handle to maskfinishedbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;

% Dice3DCart variables in .mat file
load('SmallDiceTilted_PierreCalibration.mat')
% load('Bead_Calibration.mat')

if ~isfield(handles,'x1') || ~isfield(handles,'x2') || ~isfield(handles,'x3') ||~isfield(handles,'x4') 
    uiwait(msgbox('You need to select all the calibration points first!','','modal'));
    return
end
x1 = handles.x1;
x2 = handles.x2;
x3 = handles.x3;
x4 = handles.x4;
y1 = handles.y1;
y2 = handles.y3;
y3 = handles.y3;
y4 = handles.y4;

% Calculate the transformation matrices for the three cameras T, S, R and
% the derived 3-D coordinates of the reference dice
[TSquare, SSquare, RSquare, QSquare, k1, k2, k3, k4] = ... 
    CalibratePhantom4OptMap4Cams([x1 y1], [x2 y2], [x3 y3], ...
    [x4 y4], Dice3DCartA, Dice3DCartB, Dice3DCartC, Dice3DCartD);

handles.TSquare = TSquare;
handles.SSquare = SSquare;
handles.RSquare = RSquare;
handles.QSquare = QSquare;
filenameCal = strcat(handles.pathname,'\',handles.filenameCalCamC(1:end-5),'_Calibration');
save(filenameCal,'TSquare','RSquare','QSquare','SSquare')
set(handles.text23,'String','Calibration done and saved.');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- CALIBRATION When the button Load image and select points is pressed,
% the corresponding dice image is displayed in the top left panel and the
% user is asked to select the reference points.
function updateAxes1_Callback(hObject, eventdata, handles)
% hObject    handle to updateAxes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
% Identify and clear axes
axes(handles.axes1);
cla;

% Dice3DCart variables in .mat file
load('SmallDiceTilted_PierreCalibration.mat')
% load('Bead_Calibration.mat')

x1 = zeros(size(Dice3DCartA,1),1);
y1 = zeros(size(Dice3DCartA,1),1);
x2 = zeros(size(Dice3DCartB,1),1);
y2 = zeros(size(Dice3DCartB,1),1);
x3 = zeros(size(Dice3DCartC,1),1);
y3 = zeros(size(Dice3DCartC,1),1);
x4 = zeros(size(Dice3DCartD,1),1);
y4 = zeros(size(Dice3DCartD,1),1);

if ~isfield(handles,'FrameCal')
    handles.FrameCal = 1;
end
popup_sel_index = get(handles.mask_fileselect, 'Value');
switch popup_sel_index
    case 1 % Select a file...
        % GUI does nothing
    case 2 % Camera A
        % Run image processing for camera A view
        if ~isfield(handles,'filenameCalCamA')
            uiwait(msgbox('You need to select a calibration image to load!','','modal'));
            return
        end
        [MaskA,handles.cmosDataCal] = Calibration_LoadImages(handles.filenameCalCamA,handles.pathname,1,handles.FrameCal);
        axes(handles.axes1);
        contrastCal = [get(handles.slider2, 'Value') get(handles.slider1, 'Value')]; 
        MaskA2=imadjust(MaskA,[contrastCal(1) contrastCal(1) contrastCal(1); contrastCal(2) contrastCal(2) contrastCal(2)],[]);
        image(MaskA2);  title(strcat('Frame #',num2str(handles.FrameCal))); axis image    
        set(handles.text23,'String','Select corners of the dice in the order indicated by numbers');
        % User selects points
        for ii = 1:size(Dice3DCartA,1)
            [x1(ii,1),y1(ii,1)] = ginputRed(1);
            % Display selected points
            hold(handles.axes1,'on');
            plot(x1(ii,1),y1(ii,1),'or')
            hold(handles.axes1,'off');
            handles.CalADone= 1;
        end
        handles.x1 = x1;
        handles.y1 = y1;
        if handles.CalADone && ~handles.CalBDone && ~handles.CalCDone && ~handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam A');
        elseif handles.CalADone && handles.CalBDone && ~handles.CalCDone && ~handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam A and B');
        elseif handles.CalADone && ~handles.CalBDone && handles.CalCDone && ~handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam A and C');
        elseif handles.CalADone && ~handles.CalBDone && ~handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam A and D');
        elseif handles.CalADone && handles.CalBDone && handles.CalCDone && ~handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam A, B and C');
        elseif handles.CalADone && handles.CalBDone && ~handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam A, B and D');
        elseif handles.CalADone && ~handles.CalBDone && handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam A, C and D');
        elseif handles.CalADone && handles.CalBDone && handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for all cams. Click on Calculate calibration matrices');
        end
        handles.MaskACal = MaskA;
        % Update handles structure
        guidata(hObject, handles);
    case 3 % Camera B
        % Run image processing for camera B view
        if ~isfield(handles,'filenameCalCamB')
            uiwait(msgbox('You need to select a calibration image to load!','','modal'));
            return
        end
        [MaskB,handles.cmosDataCal] = Calibration_LoadImages(handles.filenameCalCamB,handles.pathname, 2,handles.FrameCal);
        axes(handles.axes1);
        contrastCal = [get(handles.slider2, 'Value') get(handles.slider1, 'Value')]; 
        MaskB2=imadjust(MaskB,[contrastCal(1) contrastCal(1) contrastCal(1); contrastCal(2) contrastCal(2) contrastCal(2)],[]);
        image(MaskB2);      title(strcat('Frame #',num2str(handles.FrameCal)));  axis image             
        set(handles.text23,'String','Select corners of the dice in the order indicated by numbers');
        % User selects points
        for ii = 1:size(Dice3DCartB,1)
            [x2(ii,1),y2(ii,1)] = ginputRed(1);
            % Display selected points
            hold(handles.axes1,'on');
            plot(x2(ii,1),y2(ii,1),'or')
            hold(handles.axes1,'off');
            handles.CalBDone = 1;
        end
        handles.x2 = x2;
        handles.y2 = y2;
        if ~handles.CalADone && handles.CalBDone && ~handles.CalCDone && ~handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam B');
        elseif handles.CalADone && handles.CalBDone && ~handles.CalCDone && ~handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam A and B');
        elseif ~handles.CalADone && handles.CalBDone && handles.CalCDone && ~handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam B and C');
        elseif ~handles.CalADone && handles.CalBDone && ~handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam B and D');
        elseif handles.CalADone && handles.CalBDone && handles.CalCDone && ~handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam A, B and C');
        elseif handles.CalADone && handles.CalBDone && ~handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam A, B and D');
        elseif ~handles.CalADone && handles.CalBDone && handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam B, C and D');
        elseif handles.CalADone && handles.CalBDone && handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for all cams. Click on Calculate calibration matrices');
        end
        handles.MaskBCal = MaskB;
        % Update handles structure
        guidata(hObject, handles);
    case 4 % Camera C
        % Run image processing for camera C view
        if ~isfield(handles,'filenameCalCamC')
            uiwait(msgbox('You need to select a calibration image to load!','','modal'));
            return
        end
        [MaskC,handles.cmosDataCal] = Calibration_LoadImages(handles.filenameCalCamC,handles.pathname, 3,handles.FrameCal);
        axes(handles.axes1);
        contrastCal = [get(handles.slider2, 'Value') get(handles.slider1, 'Value')]; 
        MaskC2=imadjust(MaskC,[contrastCal(1) contrastCal(1) contrastCal(1); contrastCal(2) contrastCal(2) contrastCal(2)],[]);
        image(MaskC2);       title(strcat('Frame #',num2str(handles.FrameCal))); axis image    
        set(handles.text23,'String','Select corners of the dice in the order indicated by numbers');
        % User selects points
        for ii = 1:size(Dice3DCartC,1)
            [x3(ii,1),y3(ii,1)] = ginputRed(1);
            % Display selected points
            hold(handles.axes1,'on');
            plot(x3(ii,1),y3(ii,1),'or')
            hold(handles.axes1,'off')
            handles.CalCDone = 1;
        end
        handles.x3 = x3;
        handles.y3 = y3;
        if ~handles.CalADone && ~handles.CalBDone && handles.CalCDone && ~handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam C');
        elseif handles.CalADone && ~handles.CalBDone && handles.CalCDone && ~handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam A and C');
        elseif ~handles.CalADone && handles.CalBDone && handles.CalCDone && ~handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam B and C');
        elseif ~handles.CalADone && ~handles.CalBDone && handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam C and D');
        elseif handles.CalADone && handles.CalBDone && handles.CalCDone && ~handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam A, B and C');
        elseif handles.CalADone && ~handles.CalBDone && handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam A, C and D');
        elseif ~handles.CalADone && handles.CalBDone && handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam B, C and D');
        elseif handles.CalADone && handles.CalBDone && handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for all cams. Click on Calculate calibration matrices');
        end
        handles.MaskCCal = MaskC;
        % Update handles structure
        guidata(hObject, handles);
    case 5 % Camera D
        % Run image processing for camera D view
        if ~isfield(handles,'filenameCalCamD')
            uiwait(msgbox('You need to select a calibration image to load!','','modal'));
            return
        end
        [MaskD,handles.cmosDataCal] = Calibration_LoadImages(handles.filenameCalCamD,handles.pathname, 4,handles.FrameCal);
        axes(handles.axes1);
        contrastCal = [get(handles.slider2, 'Value') get(handles.slider1, 'Value')]; 
        MaskD2=imadjust(MaskD,[contrastCal(1) contrastCal(1) contrastCal(1); contrastCal(2) contrastCal(2) contrastCal(2)],[]);
        image(MaskD2);     title(strcat('Frame #',num2str(handles.FrameCal))); axis image   
        set(handles.text23,'String','Select corners of the dice in the order indicated by numbers');
        % User selects points
        for ii = 1:size(Dice3DCartD,1)
            [x4(ii,1),y4(ii,1)] = ginputRed(1);
            % Display selected points
            hold(handles.axes1,'on');
            plot(x4(ii,1),y4(ii,1),'or')
            hold(handles.axes1,'off')
            handles.CalDDone = 1;
        end
        handles.x4 = x4;
        handles.y4 = y4;
        if ~handles.CalADone && ~handles.CalBDone && ~handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam D');
        elseif handles.CalADone && ~handles.CalBDone && ~handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam A and D');
        elseif ~handles.CalADone && handles.CalBDone && ~handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam B and D');
        elseif ~handles.CalADone && ~handles.CalBDone && handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam C and D');
        elseif handles.CalADone && handles.CalBDone && ~handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam A, B and D');
        elseif handles.CalADone && ~handles.CalBDone && handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam A, C and D');
        elseif ~handles.CalADone && handles.CalBDone && handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for Cam B, C and D');
        elseif handles.CalADone && handles.CalBDone && handles.CalCDone && handles.CalDDone
            set(handles.text23,'String','Calibration points selected for all cams. Click on Calculate calibration matrices');
        end
        handles.MaskDCal = MaskD;
        % Update handles structure
        guidata(hObject, handles);
end
guidata(hObject, handles);

% --- CALIBRATION When Select an existing calibration file is pressed, a
% calibration file chosen by the user is loaded.
function selectcalibrationfile_Callback(hObject, eventdata, handles)
% hObject    handle to selectcalibrationfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
[file_name, path_name] = uigetfile('*.mat', 'Select calibration file');
load(strcat(path_name,file_name));
set(handles.text23,'String',['Calibration file selected: ',file_name]);
handles.TSquare = TSquare;
handles.SSquare = SSquare;
handles.RSquare = RSquare;
handles.QSquare = QSquare;
handles.pathname = path_name;
guidata(hObject, handles);


% --- CALIBRATION CalibrationCamA is a button of selection of the dice
% image taken by the camera A. The images taken by the other cameras are
% automatically loaded.
function calibrationCamA_Callback(hObject, eventdata, handles)
% hObject    handle to calibrationCamA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
[file_name,path_name] = uigetfile({'*.mat','MAT-file';'*.rsh','Camera file'},'Select the dice image from CamA');
handles.filenameCalCamA = file_name;
handles.pathname = path_name;
set(handles.text11,'String',file_name);
handles.CalADone = 0; % Flags to check if the calibration has been done for each cam
findletterCam = strfind(file_name,'A');
handles.filenameCalCamB = strcat(file_name(1:findletterCam-1),'B',file_name(findletterCam+1:end));
handles.CalBDone = 0;
handles.filenameCalCamC = strcat(file_name(1:findletterCam-1),'C',file_name(findletterCam+1:end));
handles.CalCDone = 0;
handles.filenameCalCamD = strcat(file_name(1:findletterCam-1),'D',file_name(findletterCam+1:end));;
handles.CalDDone = 0;
guidata(hObject, handles);

% --- SILHOUETTE Cam A 1st acq is a button of selection of the image of the
% heart taken by Camera A at the first angular step. The images taken by 
% the other cameras are automatically loaded.
function photoCamA_Callback(hObject, eventdata, handles)
% hObject    handle to photoCamA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
if ~isfield(handles,'pathname')
    handles.pathname = cd;
end
[file_name,path_name] = uigetfile({'*.mat','MAT-file';'*.rsh','Camera file'},'Select the heart image from CamA',handles.pathname);
handles.filenameFirstPhotoCamA = file_name;
handles.pathname = path_name;
set(handles.text15,'String',file_name);
handles.ExistingAxRot = 0;

frame = 1;
if strcmp(file_name(end),'h')
    CMOSconverter(handles.pathname,file_name); % Convert directly from the .rsh    
end
Data1 = load(strcat(handles.pathname,file_name(1:end-3)));

minVisible = 6;
clear G Mframe J A
axes(handles.axes4);
cmosData1 = double(Data1.cmosData(:,:,2:end));
bg1 = double(Data1.bgimage);
G = real2rgb(bg1, 'gray');
Mframe = cmosData1(:,:,frame);
J = real2rgb(Mframe, 'jet');
A = real2rgb(Mframe >= minVisible, 'gray');
A1 = J .* A + G .* (1-A);
A2 = rgb2gray(A1); % Made 2D
A3 = imadjust(A2); % Increase contrast
imagesc(A3);
colormap(gray)
axis image
guidata(hObject, handles);

% --- SILHOUETTE Cam A Last acq is a button of selection of the image of the
% heart taken by Camera A at the last angular step. The images taken by 
% the other cameras are automatically loaded.
function photoCamB_Callback(hObject, eventdata, handles)
% hObject    handle to photoCamB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
if ~isfield(handles,'pathname')
    handles.pathname = cd;
end
[file_name,path_name] = uigetfile({'*.mat','MAT-file';'*.rsh','Camera file'},'Select the heart image from CamB',handles.pathname);
handles.filenameLastPhotoCamA = file_name;
handles.pathname = path_name;
set(handles.text16,'String',file_name);
handles.ExistingAxRot = 0;

frame = 1;
if strcmp(file_name(end),'h')
    CMOSconverter(handles.pathname,file_name); % Convert directly from the .rsh    
end
Data1 = load(strcat(handles.pathname,file_name(1:end-3)));

minVisible = 6;
clear G Mframe J A
axes(handles.axes4);
cmosData1 = double(Data1.cmosData(:,:,2:end));
bg1 = double(Data1.bgimage);
G = real2rgb(bg1, 'gray');
Mframe = cmosData1(:,:,frame);
J = real2rgb(Mframe, 'jet');
A = real2rgb(Mframe >= minVisible, 'gray');
A1 = J .* A + G .* (1-A);
A2 = rgb2gray(A1); % Made 2D
A3 = imadjust(A2); % Increase contrast
imagesc(A3);
axis image
colormap(gray)
guidata(hObject, handles);


% --- PROJECTION Optical Map Cam A is a button of selection of the optical
% map taken by Camera A. The images taken by the other cameras are 
% automatically loaded.
function optmapCamA_Callback(hObject, eventdata, handles)
% hObject    handle to optmapCamA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
if ~isfield(handles,'pathname')
    handles.pathname = cd;
end
[file_name,path_name] = uigetfile({'*.mat','MAT-file';'*.rsh','Camera file'},'Select the optical map image from CamA',handles.pathname);
handles.filenameOptCamA = file_name;
handles.pathname = path_name;
set(handles.text31,'String',file_name);
guidata(hObject, handles);

% --- CALIBRATION Adjusts the contrast of the calibration pictures
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.output = hObject;

popup_sel_index = get(handles.mask_fileselect, 'Value');
switch popup_sel_index
    case 1
        
    case 2
        if ~isfield(handles,'MaskACal')
            uiwait(msgbox('You need to load a dice image first!','','modal'));
            return
        end
        contrastCal = [get(handles.slider2, 'Value') get(handles.slider1, 'Value')]; 
        MaskACalContrast=imadjust(handles.MaskACal,[contrastCal(1) contrastCal(1) contrastCal(1); contrastCal(2) contrastCal(2) contrastCal(2)],[]);
        axes(handles.axes1);
        image(MaskACalContrast);  
    case 3
        if ~isfield(handles,'MaskBCal')
            uiwait(msgbox('You need to load a dice image first!','','modal'));
            return
        end
        contrastCal = [get(handles.slider2, 'Value') get(handles.slider1, 'Value')]; 
        MaskBCalContrast=imadjust(handles.MaskBCal,[contrastCal(1) contrastCal(1) contrastCal(1); contrastCal(2) contrastCal(2) contrastCal(2)],[]);        
        axes(handles.axes1);
        image(MaskBCalContrast);  
    case 4
        if ~isfield(handles,'MaskCCal')
            uiwait(msgbox('You need to load a dice image first!','','modal'));
            return
        end
        contrastCal = [get(handles.slider2, 'Value') get(handles.slider1, 'Value')]; 
        MaskCCalContrast=imadjust(handles.MaskCCal,[contrastCal(1) contrastCal(1) contrastCal(1); contrastCal(2) contrastCal(2) contrastCal(2)],[]);
        axes(handles.axes1);
        image(MaskCCalContrast);  
    case 5
        if ~isfield(handles,'MaskDCal')
            uiwait(msgbox('You need to load a dice image first!','','modal'));
            return
        end
        contrastCal = [get(handles.slider2, 'Value') get(handles.slider1, 'Value')]; 
        MaskDCalContrast=imadjust(handles.MaskDCal,[contrastCal(1) contrastCal(1) contrastCal(1); contrastCal(2) contrastCal(2) contrastCal(2)],[]);
        axes(handles.axes1);
        image(MaskDCalContrast);
end
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- CALIBRATION Adjusts the contrast of the calibration pictures
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.output = hObject;

popup_sel_index = get(handles.mask_fileselect, 'Value');
switch popup_sel_index
    case 1
        
    case 2
        if ~isfield(handles,'MaskACal')
            uiwait(msgbox('You need to load a dice image first!','','modal'));
            return
        end
        contrastCal = [get(handles.slider2, 'Value') get(handles.slider1, 'Value')]; 
        MaskACalContrast=imadjust(handles.MaskACal,[contrastCal(1) contrastCal(1) contrastCal(1); contrastCal(2) contrastCal(2) contrastCal(2)],[]);        
        axes(handles.axes1);
        image(MaskACalContrast);  
    case 3
        if ~isfield(handles,'MaskBCal')
            uiwait(msgbox('You need to load a dice image first!','','modal'));
            return
        end
        contrastCal = [get(handles.slider2, 'Value') get(handles.slider1, 'Value')]; 
        MaskBCalContrast=imadjust(handles.MaskBCal,[contrastCal(1) contrastCal(1) contrastCal(1); contrastCal(2) contrastCal(2) contrastCal(2)],[]);
        axes(handles.axes1);
        image(MaskBCalContrast);  
    case 4
        if ~isfield(handles,'MaskCCal')
            uiwait(msgbox('You need to load a dice image first!','','modal'));
            return
        end
        contrastCal = [get(handles.slider2, 'Value') get(handles.slider1, 'Value')]; 
        hMaskCCalContrast=imadjust(handles.MaskCCal,[contrastCal(1) contrastCal(1) contrastCal(1); contrastCal(2) contrastCal(2) contrastCal(2)],[]);
        axes(handles.axes1);
        image(MaskCCalContrast);  
    case 5
        if ~isfield(handles,'MaskDCal')
            uiwait(msgbox('You need to load a dice image first!','','modal'));
            return
        end
        contrastCal = [get(handles.slider2, 'Value') get(handles.slider1, 'Value')]; 
        MaskDCalContrast=imadjust(handles.MaskDCal,[contrastCal(1) contrastCal(1) contrastCal(1); contrastCal(2) contrastCal(2) contrastCal(2)],[]);
        axes(handles.axes1);
        image(MaskDCalContrast);
end
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- CALIBRATION Selection of a different frame from the calibration pictures
function sliderFrameCal_Callback(hObject, eventdata, handles)
% hObject    handle to sliderFrameCal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.output = hObject;
sliderMax = get(hObject,'Max');
sliderMin = get(hObject,'Min');
sliderStep = [1, 1] / (sliderMax - sliderMin);
set(hObject,'SliderStep',sliderStep);
handles.FrameCal = round(get(hObject,'Value'));

if ~isfield(handles,'cmosDataCal')
    uiwait(msgbox('You need to load a dice image first!','','modal'));
    return
end
set(hObject,'Max',size(handles.cmosDataCal,3));

popup_sel_index = get(handles.mask_fileselect, 'Value');
switch popup_sel_index
    case 1 % Select a file...
        % GUI does nothing
    case 2 % Camera A
        % Run image processing for camera A view        
        [MaskA,handles.cmosDataCal] = Calibration_LoadImages(handles.filenameCalCamA,handles.pathname,1,handles.FrameCal);
        axes(handles.axes1);
        contrastCal = [get(handles.slider2, 'Value') get(handles.slider1, 'Value')]; 
        MaskA2=imadjust(MaskA,[contrastCal(1) contrastCal(1) contrastCal(1); contrastCal(2) contrastCal(2) contrastCal(2)],[]);
        image(MaskA2);  title(strcat('Frame #',num2str(handles.FrameCal)));      
         guidata(hObject, handles);
    case 3 % Camera B
        % Run image processing for camera B view
        [MaskB,handles.cmosDataCal] = Calibration_LoadImages(handles.filenameCalCamB,handles.pathname, 2,handles.FrameCal);
        axes(handles.axes1);
        contrastCal = [get(handles.slider2, 'Value') get(handles.slider1, 'Value')]; 
        MaskB2=imadjust(MaskB,[contrastCal(1) contrastCal(1) contrastCal(1); contrastCal(2) contrastCal(2) contrastCal(2)],[]);
        image(MaskB2);      title(strcat('Frame #',num2str(handles.FrameCal)));  
        guidata(hObject, handles);
    case 4 % Camera C
        % Run image processing for camera C view
        [MaskC,handles.cmosDataCal] = Calibration_LoadImages(handles.filenameCalCamC,handles.pathname, 3,handles.FrameCal);
        axes(handles.axes1);
        contrastCal = [get(handles.slider2, 'Value') get(handles.slider1, 'Value')]; 
        MaskC2=imadjust(MaskC,[contrastCal(1) contrastCal(1) contrastCal(1); contrastCal(2) contrastCal(2) contrastCal(2)],[]);
        image(MaskC2);       title(strcat('Frame #',num2str(handles.FrameCal)));  
        guidata(hObject, handles);
    case 5 % Camera D
        % Run image processing for camera D view
        [MaskD,handles.cmosDataCal] = Calibration_LoadImages(handles.filenameCalCamD,handles.pathname, 4,handles.FrameCal);
        axes(handles.axes1);
        contrastCal = [get(handles.slider2, 'Value') get(handles.slider1, 'Value')]; 
        MaskD2=imadjust(MaskD,[contrastCal(1) contrastCal(1) contrastCal(1); contrastCal(2) contrastCal(2) contrastCal(2)],[]);
        image(MaskD2);     title(strcat('Frame #',num2str(handles.FrameCal))); 
        guidata(hObject, handles);
end
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliderFrameCal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderFrameCal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- SILHOUETTE Read the user input for the angle between acquisitions
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
handles.output = hObject;
handles.AngleBtwViews = str2double(get(handles.edit2,'String'));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- SILHOUETTE Check the accuracy of the automatic segmentation
function pushbutton37_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
if ~isfield(handles,'filenameFirstPhotoCamA')    
    uiwait(msgbox('You need to select a first heart picture!','','modal'));
    return
end
if ~isfield(handles,'filenameLastPhotoCamA')    
    uiwait(msgbox('You need to select the last heart picture!','','modal'));
    return
end

PosDashName = strfind(handles.filenameFirstPhotoCamA,'-');
PosCamName = strfind(handles.filenameFirstPhotoCamA,'A');
numInit = str2double(handles.filenameFirstPhotoCamA(PosDashName+1:PosCamName-1));
numViews = str2double(handles.filenameLastPhotoCamA(PosDashName+1:PosCamName-1))-str2double(handles.filenameFirstPhotoCamA(PosDashName+1:PosCamName-1))+1;

handles.Threshold = str2double(get(handles.edit3,'String'));

CheckSegmentation(numInit,numViews,handles.Threshold,handles.filenameFirstPhotoCamA,handles.pathname);
% Update handles structure
guidata(hObject, handles);

% --- SILHOUETTE Calculate the silhouette of the heart
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
if ~isfield(handles,'filenameFirstPhotoCamA')    
    uiwait(msgbox('You need to select a first heart picture!','','modal'));
    return
end
if ~isfield(handles,'filenameLastPhotoCamA')    
    uiwait(msgbox('You need to select the last heart picture!','','modal'));
    return
end

PosDashName = strfind(handles.filenameFirstPhotoCamA,'-');
PosCamName = strfind(handles.filenameFirstPhotoCamA,'A');
numInit = str2double(handles.filenameFirstPhotoCamA(PosDashName+1:PosCamName-1));
numViews = str2double(handles.filenameLastPhotoCamA(PosDashName+1:PosCamName-1))-str2double(handles.filenameFirstPhotoCamA(PosDashName+1:PosCamName-1))+1;

% Definition of a virtual box that fully contains the heart (in mm)
xmin = -20;
xmax = 20;
ymin = -20;
ymax = 20;
zmin = -20;
zmax = 20;
stepX = 0.1;%(xmax-xmin)/(xmax*10);
stepY = 0.1;%(ymax-ymin)/(ymax*10);
stepZ = 0.1;%(zmax-zmin)/(zmax*10);
AxX = (xmin:stepX:xmax);
AxY = (ymin:stepY:ymax);
AxZ = (zmin:stepZ:zmax);

% Define the limits for the z-sliders for the final figure
set(handles.slider10,'Min',round(length(AxZ)/2));
set(handles.slider10,'Max',length(AxZ));
set(handles.slider10,'Value',length(AxZ));
set(handles.slider11,'Min',1);
set(handles.slider11,'Max',round(length(AxZ)/2));
set(handles.slider11,'Value',1);

handles.AngleBtwViews = str2double(get(handles.edit2,'String'));

handles.Threshold = str2double(get(handles.edit3,'String'));

if ~isfield(handles,'TSquare')
    uiwait(msgbox('You need to load an existing calibration file or perform a new one!','','modal'));
    return
end

handles.Silhouettes = CalculateSilhouettesHeart(numInit,numViews,handles.Threshold,handles.TSquare,handles.SSquare,handles.RSquare,handles.QSquare,handles.filenameFirstPhotoCamA,handles.pathname,AxX,AxY,AxZ);
set(handles.text26,'String','The successive silhouettes have been calculated.');
if handles.ExistingAxRot == 0
    axes(handles.axes4);
    colormap(parula)
    axis image
    handles.FitRod = CalculateAxisRotation(handles.filenameFirstPhotoCamA,handles.pathname,handles.TSquare,handles.SSquare,handles.RSquare,handles.QSquare,handles.axes4,handles.text26,AxX,AxY,AxZ);
    set(handles.text26,'String','The axis of rotation has been calculated.');
end
handles.SilhouetteTotal = CalculateFinalSilhouette(numViews,handles.AngleBtwViews,handles.Silhouettes,handles.FitRod,AxX,AxY,AxZ);
set(handles.text26,'String','The final silhouette has been calculated.');
[handles.SilhouetteFinal] = DisplaySilhouetteHeart(handles.SilhouetteTotal,handles.axes2,AxX,AxY,AxZ);

handles.AxX = AxX;
handles.AxY = AxY;
handles.AxZ = AxZ;
% Update handles structure
guidata(hObject, handles);


% --- SILHOUETTE Save the silhouette of the heart.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
if ~isfield(handles,'filenameFirstPhotoCamA')    
    uiwait(msgbox('You need to select a first heart picture!','','modal'));
    return
end
if ~isfield(handles,'Silhouettes')    
    uiwait(msgbox('You need to perform the silhouette calculation first!','','modal'));
    return
end
PosDashName = strfind(handles.filenameFirstPhotoCamA,'-');
filenameSaveSilh = strcat(handles.pathname,handles.filenameFirstPhotoCamA(1:PosDashName-1),'Silhouette');
filenameSaveAxRot = strcat(handles.pathname,handles.filenameFirstPhotoCamA(1:PosDashName-1),'RotationAxis');
Silhouettes = handles.Silhouettes;
SilhouetteFinal = handles.SilhouetteFinal;
SilhouetteTotal = handles.SilhouetteTotal;
FitRod = handles.FitRod;
AxX = handles.AxX;
AxY = handles.AxY;
AxZ = handles.AxZ;
save(filenameSaveSilh,'Silhouettes','SilhouetteFinal','SilhouetteTotal','AxX','AxY','AxZ','-v7.3')
save(filenameSaveAxRot,'FitRod')
fidu = fopen(filenameSaveSilh,'w');
fwrite(fidu,SilhouetteFinal,'double');
fclose(fidu);
% Update handles structure
guidata(hObject, handles);

% --- SILHOUETTE Select and display an existing silhouette
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
if ~isfield(handles,'pathname')
    handles.pathname = cd;
end
[file_nameSilhouette,path_name] = uigetfile({'*.mat','MAT-file'},'Select a silhouette of the heart',handles.pathname);
handles.pathname = path_name;
load(strcat(handles.pathname,file_nameSilhouette))
handles.Silhouettes = Silhouettes;
handles.SilhouetteFinal = SilhouetteFinal;
handles.SilhouetteTotal = SilhouetteTotal;
handles.AxX = AxX;
handles.AxY = AxY;
handles.AxZ = AxZ;
SilhouetteFinal_v2 = DisplaySilhouetteHeart(SilhouetteTotal,handles.axes2,AxX,AxY,AxZ);
set(handles.text26,'String',strcat('Existing silhouette selected:',file_nameSilhouette));
guidata(hObject, handles);

% --- SILHOUETTE Select an existing axis of rotation
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
if ~isfield(handles,'pathname')
    handles.pathname = cd;
end
[file_nameAxRot,path_name] = uigetfile({'*.mat','MAT-file'},'Select an axis of rotation',handles.pathname);
handles.pathname = path_name;
load(strcat(handles.pathname,file_nameAxRot))
handles.FitRod = FitRod;
handles.ExistingAxRot = 1;
set(handles.text26,'String',strcat('Existing rotation axis selected:',file_nameAxRot));
guidata(hObject, handles);

% --- SILHOUETTE Read the user input for the segmentation threshold
function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
handles.output = hObject;
handles.Threshold = str2double(get(handles.edit3,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- PROJECTION Read the user input for the index of the first frame of
% the phase movie
function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
handles.output = hObject;
handles.FirstFrameOptMap = str2double(get(handles.edit4,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- PROJECTION Read the user input for the index of the last frame of
% the phase movie
function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
handles.output = hObject;
handles.LastFrameOptMap = str2double(get(handles.edit5,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- PROJECTION Project the optical maps onto the previously calculated
% silhouette of the heart
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
handles.Axesbutton_state = get(handles.radiobutton1,'Value');
handles.Gridbutton_state = get(handles.radiobutton2,'Value');
handles.RefMapbutton_state = get(handles.radiobutton3,'Value');
handles.Threshold = str2double(get(handles.edit3,'String'));
if ~isfield(handles,'pathname')
    handles.pathname = cd;
end
handles.FirstFrameOptMap = str2double(get(handles.edit4,'String'));
handles.LastFrameOptMap = str2double(get(handles.edit5,'String'));

handles.ColorbarMax = str2double(get(handles.edit7,'String'));

if ~isfield(handles,'filenameOptCamA')    
    uiwait(msgbox('You need to choose an optical map to project!','','modal'));
    return
end
if ~isfield(handles,'TSquare')    
    uiwait(msgbox('You need to load an existing calibration file or perform a new one!','','modal'));
    return
end
if ~isfield(handles,'SilhouetteFinal')    
    uiwait(msgbox('You need to load an existing heart silhouette or perform a new calculation!','','modal'));
    return
end

% Define the limits for the z-sliders for the final figure
set(handles.slider10,'Min',round(length(handles.AxZ)/2));
set(handles.slider10,'Max',length(handles.AxZ));
set(handles.slider10,'Value',length(handles.AxZ));
set(handles.slider11,'Min',1);
set(handles.slider11,'Max',round(length(handles.AxZ)/2));
set(handles.slider11,'Value',1);

% For still maps (activation, dominant frequency or APduration), the Last
% frame value is set to be the same as the first frame.
if  ~isempty(strfind(lower(handles.filenameOptCamA),'activationmap')) || ~isempty(strfind(lower(handles.filenameOptCamA),'domfreqmap')) || ~isempty(strfind(lower(handles.filenameOptCamA),'apdmap'))
    [handles.MapFinalCamA,handles.MapFinalCamB,handles.MapFinalCamC,handles.MapFinalCamD,handles.MapTotal,handles.MapRef] = ProjectionOptMapv3(handles.SilhouetteTotal,handles.Threshold,handles.AxX,handles.AxY,handles.AxZ,handles.TSquare,handles.SSquare,handles.RSquare,handles.QSquare,handles.filenameOptCamA,handles.pathname);
    [handles.ProjectedMap,handles.OptMapFMovie,handles.R,handles.ThetaMeshAxis,handles.ZMeshAxis] = DisplayOptMapv2(handles.MapTotal,handles.SilhouetteFinal,handles.AxX,handles.AxY,handles.AxZ);
    [handles.ProjectedMapRef,handles.OptMapFMovieRef,handles.RRef,handles.ThetaMeshAxisRef,handles.ZMeshAxisRef] = DisplayOptMapv2(handles.MapRef,handles.SilhouetteFinal,handles.AxX,handles.AxY,handles.AxZ);
   
    axes(handles.axes3)
    h = surf(handles.R.*cos(handles.ThetaMeshAxis).',handles.R.*sin(handles.ThetaMeshAxis).',handles.ZMeshAxis.',squeeze(handles.OptMapFMovie));
    set(h,'LineStyle','none')
    axis image
    colormap(jet)
    caxis([0 handles.ColorbarMax])

    handles.fig = figure;
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        h = surf(handles.R.*cos(handles.ThetaMeshAxis).',handles.R.*sin(handles.ThetaMeshAxis).',handles.ZMeshAxis.',squeeze(handles.OptMapFMovie));
        set(h,'LineStyle','none')
        axis image
        colormap(jet)
        caxis([0 handles.ColorbarMax])
        subplot(122)
        hRef = surf(handles.RRef.*cos(handles.ThetaMeshAxisRef).',handles.RRef.*sin(handles.ThetaMeshAxisRef).',handles.ZMeshAxisRef.',squeeze(handles.OptMapFMovieRef));
        set(hRef,'LineStyle','none')
        axis image
        colormap(jet)
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        h = surf(handles.R.*cos(handles.ThetaMeshAxis).',handles.R.*sin(handles.ThetaMeshAxis).',handles.ZMeshAxis.',squeeze(handles.OptMapFMovie));
        set(h,'LineStyle','none')
        axis image
        colormap(jet)
        caxis([0 handles.ColorbarMax])
    end
elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
    [handles.MapFinalCamA,handles.MapFinalCamB,handles.MapFinalCamC,handles.MapFinalCamD,handles.MapTotal,handles.MapRef] = ProjectionOptMapPhaseMoviev2(handles.SilhouetteTotal,handles.Threshold,handles.FirstFrameOptMap,handles.LastFrameOptMap,handles.AxX,handles.AxY,handles.AxZ,handles.TSquare,handles.SSquare,handles.RSquare,handles.QSquare,handles.filenameOptCamA,handles.pathname);
    [handles.ProjectedMap,handles.OptMapFMovie,handles.R,handles.ThetaMeshAxis,handles.ZMeshAxis] = ProjectionOptMapPhaseMovie(handles.MapTotal,handles.SilhouetteFinal,handles.FirstFrameOptMap,handles.LastFrameOptMap,handles.AxX,handles.AxY,handles.AxZ);
    [handles.ProjectedMapRef,handles.OptMapFMovieRef,handles.RRef,handles.ThetaMeshAxisRef,handles.ZMeshAxisRef] = DisplayOptMapv2(handles.MapRef,handles.SilhouetteFinal,handles.AxX,handles.AxY,handles.AxZ);
    %     OptMapFinal = PreprocessProjectionOptMapPhaseMovie(handles.filenameOptCamA,handles.pathname,handles.FirstFrameOptMap,handles.LastFrameOptMap,handles.Threshold,handles.TSquare,handles.SSquare,handles.RSquare,handles.QSquare,handles.AxX,handles.AxY,handles.AxZ);
%     [handles.ProjectedMap,handles.OptMapFMovie,handles.R,handles.ThetaMeshAxis,handles.ZMeshAxis] = ProjectionOptMapPhaseMovie(OptMapFinal,handles.SilhouetteFinal,handles.FirstFrameOptMap,handles.LastFrameOptMap,handles.AxX,handles.AxY,handles.AxZ);
%     
%     if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
%         OptMapRef = PreprocessProjectionOptMapRef(handles.filenameOptCamA,handles.pathname,handles.Threshold,handles.TSquare,handles.SSquare,handles.RSquare,handles.QSquare,handles.AxX,handles.AxY,handles.AxZ);
%         [handles.ProjectedMapRef,handles.OptMapFMovieRef,handles.RRef,handles.ThetaMeshAxisRef,handles.ZMeshAxisRef] = ProjectionOptMap(OptMapRef,handles.SilhouetteFinal,handles.AxX,handles.AxY,handles.AxZ);
%     end
    
    axes(handles.axes3)
    h = surf(handles.R.*cos(handles.ThetaMeshAxis).',handles.R.*sin(handles.ThetaMeshAxis).',handles.ZMeshAxis.',squeeze(handles.OptMapFMovie(:,:,1)));
    set(h,'LineStyle','none')
    axis image
    colormap(jet)
    caxis([-handles.ColorbarMax handles.ColorbarMax])
    
    handles.fig = figure;
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        h = surf(handles.R.*cos(handles.ThetaMeshAxis).',handles.R.*sin(handles.ThetaMeshAxis).',handles.ZMeshAxis.',squeeze(handles.OptMapFMovie(:,:,1)));
        set(h,'LineStyle','none')
        axis image
        colormap(jet)
        caxis([-handles.ColorbarMax handles.ColorbarMax])
        subplot(122)
        h = surf(handles.RRef.*cos(handles.ThetaMeshAxisRef).',handles.RRef.*sin(handles.ThetaMeshAxisRef).',handles.ZMeshAxisRef.',squeeze(handles.OptMapFMovieRef));
        set(h,'LineStyle','none')
        axis image
        colormap(jet)
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        h = surf(handles.R.*cos(handles.ThetaMeshAxis).',handles.R.*sin(handles.ThetaMeshAxis).',handles.ZMeshAxis.',squeeze(handles.OptMapFMovie));
        set(h,'LineStyle','none')
        axis image
        colormap(jet)
        caxis([0 handles.ColorbarMax])
    end        
end

if handles.Axesbutton_state == get(handles.radiobutton1,'Max')
    handles.axes3.Visible = 'on';
elseif handles.Axesbutton_state == get(handles.radiobutton1,'Min')
    handles.axes3.Visible = 'off';
end
if handles.Gridbutton_state == get(handles.radiobutton2,'Max')
    grid on;
elseif handles.Gridbutton_state == get(handles.radiobutton2,'Min')
    grid off;
end
figure(handles.fig)
if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
    subplot(121)
    ax = gca;
    if handles.Axesbutton_state == get(hObject,'Max')
        ax.Visible = 'on';
    elseif handles.Axesbutton_state == get(hObject,'Min')
        ax.Visible = 'off';
    end
    if handles.Gridbutton_state == get(hObject,'Max')
        grid on;
    elseif handles.Gridbutton_state == get(hObject,'Min')
        grid off;
    end
    subplot(122)
    ax = gca;
    if handles.Axesbutton_state == get(hObject,'Max')
        ax.Visible = 'on';
    elseif handles.Axesbutton_state == get(hObject,'Min')
        ax.Visible = 'off';
    end
    if handles.Gridbutton_state == get(hObject,'Max')
        grid on;
    elseif handles.Gridbutton_state == get(hObject,'Min')
        grid off;
    end
elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
    ax = gca;
    if handles.Axesbutton_state == get(hObject,'Max')
        ax.Visible = 'on';
    elseif handles.Axesbutton_state == get(hObject,'Min')
        ax.Visible = 'off';
    end
    if handles.Gridbutton_state == get(hObject,'Max')
        grid on;
    elseif handles.Gridbutton_state == get(hObject,'Min')
        grid off;
    end    
end
guidata(hObject, handles);

% --- PROJECTION Save phase movie in an external .avi file
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;

handles.Axesbutton_state = get(handles.radiobutton1,'Value');
handles.Gridbutton_state = get(handles.radiobutton2,'Value');

handles.ColorbarMax = str2double(get(handles.edit7,'String'));
StrFirstFrameOptMap = (get(handles.edit4,'String'));
StrLastFrameOptMap = (get(handles.edit5,'String'));
handles.FirstFrameOptMap = str2double(get(handles.edit4,'String'));
handles.LastFrameOptMap = str2double(get(handles.edit5,'String'));

if ~isfield(handles,'filenameOptCamA')    
    uiwait(msgbox('You need to select an activation map to project!','','modal'));
    return
end
if ~isfield(handles,'ThetaMeshAxis')    
    uiwait(msgbox('You need to perform the projection before saving the movie!','','modal'));
    return
end
PosCamName = strfind(handles.filenameOptCamA,'A');
PosExtension = strfind(handles.filenameOptCamA,'.mat');
FilenameSaveVid = strcat(handles.pathname,handles.filenameOptCamA(1:PosCamName-1),handles.filenameOptCamA(PosCamName+1:PosExtension-1),'Projected',StrFirstFrameOptMap,'To',StrLastFrameOptMap);

Zmin = round(get(handles.slider11,'Value'));
Zmax = round(get(handles.slider10,'Value'));

v = VideoWriter(strcat(FilenameSaveVid,'.avi'));
handles.FrameRate = get(handles.edit6,'String');
v.FrameRate = str2double(handles.FrameRate); % Number of frames per second
v.Quality = 90; % Quality of the video between 0 and 100

open(v);

axes(handles.axes3)
[az,el] = view;

figVid = figure;
ax = gca;

for iFrame=handles.FirstFrameOptMap:handles.LastFrameOptMap
    h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,iFrame-handles.FirstFrameOptMap+1)));
    set(h,'LineStyle','none')
    axis image
    view(az,el);
    title(iFrame)
    colormap(jet)
    caxis([-handles.ColorbarMax handles.ColorbarMax])
    if handles.Axesbutton_state == get(handles.radiobutton1,'Max')
        ax.Visible = 'on';
    elseif handles.Axesbutton_state == get(handles.radiobutton1,'Min')
        ax.Visible = 'off';
        set(findall(ax, 'type', 'text'), 'visible', 'on')
    end
    if handles.Gridbutton_state == get(handles.radiobutton2,'Max')
        grid on;
    elseif handles.Gridbutton_state == get(handles.radiobutton2,'Min')
        grid off;
    end

    frame = getframe(gcf);
    writeVideo(v,frame);
end

close(v);
close(figVid);

guidata(hObject, handles);


% --- PROJECTION Save a movie where the camera rotates around the 3-D map
% in an external .avi file
function pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;

ax = gca;

handles.ElevationAngle = str2double(get(handles.edit8,'String'));

handles.Axesbutton_state = get(handles.radiobutton1,'Value');
handles.Gridbutton_state = get(handles.radiobutton2,'Value');

handles.ColorbarMax = str2double(get(handles.edit7,'String'));

if handles.Axesbutton_state == get(handles.radiobutton1,'Max')
    ax.Visible = 'on';
elseif handles.Axesbutton_state == get(handles.radiobutton1,'Min')
    ax.Visible = 'off';
end

Zmin = round(get(handles.slider11,'Value'));
Zmax = round(get(handles.slider10,'Value'));

if handles.Gridbutton_state == get(handles.radiobutton2,'Max')
    grid on;
elseif handles.Gridbutton_state == get(handles.radiobutton2,'Min')
    grid off;
end
if ~isfield(handles,'filenameOptCamA')    
    uiwait(msgbox('You need to select an activation map to project!','','modal'));
    return
end
if ~isfield(handles,'ThetaMeshAxis')    
    uiwait(msgbox('You need to perform the projection before saving the movie!','','modal'));
    return
end
figVid = figure;

PosCamName = strfind(handles.filenameOptCamA,'A');
PosExtension = strfind(handles.filenameOptCamA,'.mat');
FilenameSaveVid = strcat(handles.pathname,handles.filenameOptCamA(1:PosCamName-1),handles.filenameOptCamA(PosCamName+1:PosExtension-1),'RotMovie');

v = VideoWriter(strcat(FilenameSaveVid,'.avi'));

handles.FrameRate = get(handles.edit6,'String');
v.FrameRate = str2double(handles.FrameRate); % Number of frames per second
v.Quality = 90; % Quality of the video between 0 and 100

open(v);
AngleAz = linspace(0,360,361);
for iAngleAz = 1:length(AngleAz)
    h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));    
    set(h,'LineStyle','none')
    axis image
    colormap(jet)
    if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
        caxis([0 handles.ColorbarMax])
    elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
        caxis([-handles.ColorbarMax handles.ColorbarMax])
    end
    view(AngleAz(iAngleAz),handles.ElevationAngle)
%     pause(0.1)
    frame = getframe(gcf);
    writeVideo(v,frame);
end
close(v);
close(figVid);
guidata(hObject, handles);

% --- PROJECTION Save the figure in the format indicated by the user in the
% pop-up menu
function pushbutton34_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;

handles.Axesbutton_state = get(handles.radiobutton1,'Value');
handles.Gridbutton_state = get(handles.radiobutton2,'Value');

handles.RefMapbutton_state = get(handles.radiobutton3,'Value');

handles.ColorbarMax = str2double(get(handles.edit7,'String'));

popup_selFileFormat_index = get(handles.popupmenu3, 'Value');
if ~isfield(handles,'pathname')
    handles.pathname = cd;
end
if ~isfield(handles,'filenameOptCamA')    
    uiwait(msgbox('You need to select an activation map to project!','','modal'));
    return
end
if ~isfield(handles,'ThetaMeshAxis')    
    uiwait(msgbox('You need to perform the projection before saving the figure!','','modal'));
    return
end
PosCamName = strfind(handles.filenameOptCamA,'A');
PosExtension = strfind(handles.filenameOptCamA,'.mat');
FileNameToSave = strcat(handles.pathname,handles.filenameOptCamA(1:PosCamName-1),handles.filenameOptCamA(PosCamName+1:PosExtension-1),'Projected');
Zmin = round(get(handles.slider11,'Value'));
Zmax = round(get(handles.slider10,'Value'));

axes(handles.axes3)
[az,el] = view;

if ~isvalid(handles.fig)
    handles.fig = figure;
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
        set(h,'LineStyle','none')
        axis image
        view(az,el);
        colormap(jet)
        if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
            caxis([0 handles.ColorbarMax])
        elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
            caxis([-handles.ColorbarMax handles.ColorbarMax])
        end
        if handles.Axesbutton_state == get(handles.radiobutton1,'Max')
            handles.fig.Visible = 'on';
        elseif handles.Axesbutton_state == get(handles.radiobutton1,'Min')
            handles.fig.Visible = 'off';
        end
        if handles.Gridbutton_state == get(handles.radiobutton2,'Max')
            grid on;
        elseif handles.Gridbutton_state == get(handles.radiobutton2,'Min')
            grid off;
        end
        subplot(122)
        h = surf(handles.RRef(:,Zmin:Zmax).*cos(handles.ThetaMeshAxisRef(Zmin:Zmax,:)).',handles.RRef(:,Zmin:Zmax).*sin(handles.ThetaMeshAxisRef(Zmin:Zmax,:)).',handles.ZMeshAxisRef(Zmin:Zmax,:).',squeeze(handles.OptMapFMovieRef(:,Zmin:Zmax,1)));
        set(h,'LineStyle','none')
        axis image
        view(az,el);
        colormap(jet)
        if handles.Axesbutton_state == get(handles.radiobutton1,'Max')
            handles.fig.Visible = 'on';
        elseif handles.Axesbutton_state == get(handles.radiobutton1,'Min')
            handles.fig.Visible = 'off';
        end
        if handles.Gridbutton_state == get(handles.radiobutton2,'Max')
            grid on;
        elseif handles.Gridbutton_state == get(handles.radiobutton2,'Min')
            grid off;
        end
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
        set(h,'LineStyle','none')
        axis image
        view(az,el);
        colormap(jet)
        if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
            caxis([0 handles.ColorbarMax])
        elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
            caxis([-handles.ColorbarMax handles.ColorbarMax])
        end
        if handles.Axesbutton_state == get(handles.radiobutton1,'Max')
            handles.fig.Visible = 'on';
        elseif handles.Axesbutton_state == get(handles.radiobutton1,'Min')
            handles.fig.Visible = 'off';
        end
        if handles.Gridbutton_state == get(handles.radiobutton2,'Max')
            grid on;
        elseif handles.Gridbutton_state == get(handles.radiobutton2,'Min')
            grid off;
        end
    end
else
    figure(handles.fig);
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        view(az,el);
        subplot(122)
        view(az,el);
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        view(az,el);
    end
end
switch popup_selFileFormat_index
    case 1 % Select a figure format...
        % GUI does nothing
    case 2 % png
        print(handles.fig,FileNameToSave,'-dpng') % For a 300DPI resolution print(handles.fig,FileNameToSave,'-dpng','-r300')
    case 3 % jpg            
        print(handles.fig,FileNameToSave,'-djpeg')
    case 4 % tiff
        print(handles.fig,FileNameToSave,'-dtiff')
    case 5 % fig 
        savefig(handles.fig,FileNameToSave)
    case 6 % pdf
        print(handles.fig,FileNameToSave,'-dpdf')
    case 7 % eps
        print(handles.fig,FileNameToSave,'-deps')
end

guidata(hObject, handles);


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- PROJECTION Play the phase movie through the different frames
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1
handles.output = hObject;

handles.Axesbutton_state = get(handles.radiobutton1,'Value');
handles.Gridbutton_state = get(handles.radiobutton2,'Value');

handles.FirstFrameOptMap = str2double(get(handles.edit4,'String'));
handles.LastFrameOptMap = str2double(get(handles.edit5,'String'));

handles.FrameRate = get(handles.edit6,'String');
PausingTime = 1/str2double(handles.FrameRate);

handles.ColorbarMax = str2double(get(handles.edit7,'String'));

if ~isfield(handles,'filenameOptCamA')    
    uiwait(msgbox('You need to select an activation map to project!','','modal'));
    return
end
if ~isfield(handles,'ThetaMeshAxis')    
    uiwait(msgbox('You need to perform the projection before playing the movie!','','modal'));
    return
end
% For still maps (activation, Dominant frequency, APDuration) there is only
% one frame.
if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
   handles.LastFrameOptMap = handles.FirstFrameOptMap; 
end

Zmin = round(get(handles.slider11,'Value'));
Zmax = round(get(handles.slider10,'Value'));

axes(handles.axes3)
[az,el] = view;
for iFrame=handles.FirstFrameOptMap:handles.LastFrameOptMap
    h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,iFrame-handles.FirstFrameOptMap+1)));
    
    set(h,'LineStyle','none')
    axis image
    view(az,el);
    title(iFrame)
    colormap(jet)
    caxis([-handles.ColorbarMax handles.ColorbarMax])

    if handles.Axesbutton_state == get(handles.radiobutton1,'Max')
        handles.axes3.Visible = 'on';
    elseif handles.Axesbutton_state == get(handles.radiobutton1,'Min')
        handles.axes3.Visible = 'off';
    end
    if handles.Gridbutton_state == get(handles.radiobutton2,'Max')
        grid on;
    elseif handles.Gridbutton_state == get(handles.radiobutton2,'Min')
        grid off;
    end
    pause(PausingTime)
end

guidata(hObject, handles);


% --- PROJECTION Play a movie where the camera rotates around the heart
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2
handles.output = hObject;

handles.ElevationAngle = str2double(get(handles.edit8,'String'));

handles.Axesbutton_state = get(handles.radiobutton1,'Value');
handles.Gridbutton_state = get(handles.radiobutton2,'Value');

handles.FirstFrameOptMap = str2double(get(handles.edit4,'String'));
handles.LastFrameOptMap = str2double(get(handles.edit5,'String'));

handles.FrameRate = get(handles.edit6,'String');
PausingTime = 1/str2double(handles.FrameRate);

handles.ColorbarMax = str2double(get(handles.edit7,'String'));

Zmin = round(get(handles.slider11,'Value'));
Zmax = round(get(handles.slider10,'Value'));

if ~isfield(handles,'filenameOptCamA')    
    uiwait(msgbox('You need to select an activation map to project!','','modal'));
    return
end
if ~isfield(handles,'ThetaMeshAxis')    
    uiwait(msgbox('You need to perform the projection before playing the movie!','','modal'));
    return
end

button_state = get(hObject,'Value');
while button_state == get(hObject,'Max')
	set(hObject,'String','Stop Movie')
    
    axes(handles.axes3)
    AngleAz = linspace(0,360,361);
    for iAngleAz = 1:length(AngleAz)        
        button_state = get(hObject,'Value');
        if button_state == get(hObject,'Max')
            h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
            set(h,'LineStyle','none')
            axis image
            colormap(jet)
            if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
                caxis([0 handles.ColorbarMax])
            elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
                caxis([-handles.ColorbarMax handles.ColorbarMax])
            end
            view(AngleAz(iAngleAz),handles.ElevationAngle)
            if handles.Axesbutton_state == get(handles.radiobutton1,'Max')
                handles.axes3.Visible = 'on';
            elseif handles.Axesbutton_state == get(handles.radiobutton1,'Min')
                handles.axes3.Visible = 'off';
            end
            if handles.Gridbutton_state == get(handles.radiobutton2,'Max')
                grid on;
            elseif handles.Gridbutton_state == get(handles.radiobutton2,'Min')
                grid off;
            end
            pause(PausingTime)
        else             
            set(hObject,'String','Play Movie')
            return
        end
    end
end    
set(hObject,'String','Stop Movie')


guidata(hObject, handles);


% --- PROJECTION Chooses to display or not a white box and the axes in the
% final figure
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
handles.output = hObject;

Axesbutton_state = get(hObject,'Value');

handles.RefMapbutton_state = get(handles.radiobutton3,'Value');

Zmin = round(get(handles.slider11,'Value'));
Zmax = round(get(handles.slider10,'Value'));
handles.ColorbarMax = str2double(get(handles.edit7,'String'));

if ~isfield(handles,'ThetaMeshAxis')    
    uiwait(msgbox('You need to perform the projection first!','','modal'));
    return
end

[az,el] = view;
axes(handles.axes3)
if Axesbutton_state == get(hObject,'Max')
    h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
    set(h,'LineStyle','none')
    axis image
    colormap(jet)
    if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
        caxis([0 handles.ColorbarMax])
    elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
        caxis([-handles.ColorbarMax handles.ColorbarMax])
    end
    view(az,el)
    handles.axes3.Visible = 'on';
    figure(handles.fig)
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
            caxis([0 handles.ColorbarMax])
        elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
            caxis([-handles.ColorbarMax handles.ColorbarMax])
        end
        view(az,el)
        ax = gca;
        ax.Visible = 'on';
        subplot(122)
        view(az,el)
        ax = gca;
        ax.Visible = 'on';
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
            caxis([0 handles.ColorbarMax])
        elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
            caxis([-handles.ColorbarMax handles.ColorbarMax])
        end
        view(az,el)
        ax = gca;
        ax.Visible = 'on';
    end
elseif Axesbutton_state == get(hObject,'Min')
    h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
    set(h,'LineStyle','none')
    axis image
    colormap(jet)
    if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
        caxis([0 handles.ColorbarMax])
    elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
        caxis([-handles.ColorbarMax handles.ColorbarMax])
    end
    view(az,el)
    handles.axes3.Visible = 'off';
    figure(handles.fig)
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
            caxis([0 handles.ColorbarMax])
        elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
            caxis([-handles.ColorbarMax handles.ColorbarMax])
        end
        view(az,el)
        ax = gca;
        ax.Visible = 'off';
        subplot(122)
        view(az,el)
        ax = gca;
        ax.Visible = 'off';
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
            caxis([0 handles.ColorbarMax])
        elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
            caxis([-handles.ColorbarMax handles.ColorbarMax])
        end
        view(az,el)
        ax = gca;
        ax.Visible = 'off';
    end
end
handles.Axesbutton_state = Axesbutton_state;
guidata(hObject, handles);

% --- PROJECTION Chooses to display or not the grid in the final figure
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
handles.output = hObject;

Gridbutton_state = get(hObject,'Value');

handles.RefMapbutton_state = get(handles.radiobutton3,'Value');
handles.ColorbarMax = str2double(get(handles.edit7,'String'));

Zmin = round(get(handles.slider11,'Value'));
Zmax = round(get(handles.slider10,'Value'));

if ~isfield(handles,'ThetaMeshAxis')    
    uiwait(msgbox('You need to perform the projection first!','','modal'));
    return
end

axes(handles.axes3)
[az,el] = view;
if Gridbutton_state == get(hObject,'Max')
    h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
    set(h,'LineStyle','none')
    axis image
    colormap(jet)
    if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
        caxis([0 handles.ColorbarMax])
    elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
        caxis([-handles.ColorbarMax handles.ColorbarMax])
    end
    if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
        caxis([0 handles.ColorbarMax])
    elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
        caxis([-handles.ColorbarMax handles.ColorbarMax])
    end
    view(az,el)
    grid on;
    figure(handles.fig)
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
            caxis([0 handles.ColorbarMax])
        elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
            caxis([-handles.ColorbarMax handles.ColorbarMax])
        end
        view(az,el)
        grid on;
        subplot(122)
        view(az,el)
        grid on;
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
            caxis([0 handles.ColorbarMax])
        elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
            caxis([-handles.ColorbarMax handles.ColorbarMax])
        end
        view(az,el)
        grid on;
    end
elseif Gridbutton_state == get(hObject,'Min')
    h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
    set(h,'LineStyle','none')
    view(az,el)
    axis image
    colormap(jet)
    if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
        caxis([0 handles.ColorbarMax])
    elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
        caxis([-handles.ColorbarMax handles.ColorbarMax])
    end
    grid off;
    figure(handles.fig)
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
            caxis([0 handles.ColorbarMax])
        elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
            caxis([-handles.ColorbarMax handles.ColorbarMax])
        end
        view(az,el)
        grid off;
        subplot(122)
        view(az,el)
        grid off;
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
            caxis([0 handles.ColorbarMax])
        elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
            caxis([-handles.ColorbarMax handles.ColorbarMax])
        end
        view(az,el)
        grid off;
    end
end
handles.Gridbutton_state = Gridbutton_state;
guidata(hObject, handles);


% --- PROJECTION Changes the range of z-axis shown in the figure
function slider10_Callback(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.output = hObject;
handles.RefMapbutton_state = get(handles.radiobutton3,'Value');
if ~isfield(handles,'ThetaMeshAxis')    
    uiwait(msgbox('You need to perform the projection first!','','modal'));
    return
end

Zmin = round(get(handles.slider11,'Value'));
Zmax = round(get(handles.slider10,'Value'));

handles.ColorbarMax = str2double(get(handles.edit7,'String'));

axes(handles.axes3)
[az,el] = view;
h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
set(h,'LineStyle','none')
view(az,el)
axis image
colormap(jet)
if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
    caxis([0 handles.ColorbarMax])
elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
    caxis([-handles.ColorbarMax handles.ColorbarMax])
end
figure(handles.fig)
if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
    subplot(121)
    h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
    set(h,'LineStyle','none')
    view(az,el)
    axis image
    colormap(jet)
    if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
        caxis([0 handles.ColorbarMax])
    elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
        caxis([-handles.ColorbarMax handles.ColorbarMax])
    end
    subplot(122)
    h = surf(handles.RRef(:,Zmin:Zmax).*cos(handles.ThetaMeshAxisRef(Zmin:Zmax,:)).',handles.RRef(:,Zmin:Zmax).*sin(handles.ThetaMeshAxisRef(Zmin:Zmax,:)).',handles.ZMeshAxisRef(Zmin:Zmax,:).',squeeze(handles.OptMapFMovieRef(:,Zmin:Zmax,1)));
    set(h,'LineStyle','none')
    view(az,el)
    axis image
    colormap(jet)
elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
    h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
    set(h,'LineStyle','none')
    view(az,el)
    axis image
    colormap(jet)
    if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
        caxis([0 handles.ColorbarMax])
    elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
        caxis([-handles.ColorbarMax handles.ColorbarMax])
    end
end
if handles.Axesbutton_state == get(handles.radiobutton1,'Max')
    handles.axes3.Visible = 'on';
    figure(handles.fig)
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        ax = gca;
        ax.Visible = 'on';
        subplot(122)
        ax = gca;
        ax.Visible = 'on';
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        ax = gca;
        ax.Visible = 'on';
    end
elseif handles.Axesbutton_state == get(handles.radiobutton1,'Min')
    handles.axes3.Visible = 'off';
    figure(handles.fig)
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        ax = gca;
        ax.Visible = 'off';
        subplot(122)
        ax = gca;
        ax.Visible = 'off';
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        ax = gca;
        ax.Visible = 'off';
    end
end
if handles.Gridbutton_state == get(handles.radiobutton2,'Max')
    axes(handles.axes3)
    grid on;
    figure(handles.fig);
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        grid on;
        subplot(122)
        grid on;
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        grid on;
    end
elseif handles.Gridbutton_state == get(handles.radiobutton2,'Min')
    axes(handles.axes3)
    grid off;
    figure(handles.fig);
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        grid off;
        subplot(122)
        grid off;
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        grid off;
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- PROJECTION Changes the range of z-axis shown in the figure
function slider11_Callback(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.output = hObject;
handles.RefMapbutton_state = get(handles.radiobutton3,'Value');
handles.ColorbarMax = str2double(get(handles.edit7,'String'));

if ~isfield(handles,'ThetaMeshAxis')    
    uiwait(msgbox('You need to perform the projection first!','','modal'));
    return
end

Zmin = round(get(handles.slider11,'Value'));
Zmax = round(get(handles.slider10,'Value'));
axes(handles.axes3)
[az,el] = view;
h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
set(h,'LineStyle','none')
view(az,el)
axis image
colormap(jet)
if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
    caxis([0 handles.ColorbarMax])
elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
    caxis([-handles.ColorbarMax handles.ColorbarMax])
end
figure(handles.fig)
if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
    subplot(121)
    h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
    set(h,'LineStyle','none')
    axis image
    view(az,el)
    colormap(jet)
    if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
        caxis([0 handles.ColorbarMax])
    elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
        caxis([-handles.ColorbarMax handles.ColorbarMax])
    end
    subplot(122)
    h = surf(handles.RRef(:,Zmin:Zmax).*cos(handles.ThetaMeshAxisRef(Zmin:Zmax,:)).',handles.RRef(:,Zmin:Zmax).*sin(handles.ThetaMeshAxisRef(Zmin:Zmax,:)).',handles.ZMeshAxisRef(Zmin:Zmax,:).',squeeze(handles.OptMapFMovieRef(:,Zmin:Zmax,1)));
    set(h,'LineStyle','none')
    axis image
    view(az,el)
    colormap(jet)
elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
    h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
    set(h,'LineStyle','none')
    axis image
    view(az,el)
    colormap(jet)
    if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
        caxis([0 handles.ColorbarMax])
    elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
        caxis([-handles.ColorbarMax handles.ColorbarMax])
    end
end
    
if handles.Axesbutton_state == get(handles.radiobutton1,'Max')
    handles.axes3.Visible = 'on';
    figure(handles.fig)
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        ax = gca;
        ax.Visible = 'on';
        subplot(122)
        ax = gca;
        ax.Visible = 'on';
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        ax = gca;
        ax.Visible = 'on';
    end
elseif handles.Axesbutton_state == get(handles.radiobutton1,'Min')
    handles.axes3.Visible = 'off';
    figure(handles.fig)
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        ax = gca;
        ax.Visible = 'off';
        subplot(122)
        ax = gca;
        ax.Visible = 'off';
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        ax = gca;
        ax.Visible = 'off';
    end
end
if handles.Gridbutton_state == get(handles.radiobutton2,'Max')
    axes(handles.axes3)
    grid on;
    figure(handles.fig);
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        grid on;
        subplot(122)
        grid on;
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
       grid on; 
    end
elseif handles.Gridbutton_state == get(handles.radiobutton2,'Min')
    axes(handles.axes3)
    grid off;
    figure(handles.fig);
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        grid off;
        subplot(122)
        grid off;
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        grid off;
    end
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- PROJECTION Saves projected map data in a Matlab format and in a raw
% format for Amira processing.
function pushbutton35_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
R = handles.R;
ThetaMeshAxis = handles.ThetaMeshAxis;
ZMeshAxis = handles.ZMeshAxis;
OptMapFMovie = handles.OptMapFMovie;
RRef = handles.RRef;
ThetaMeshAxisRef = handles.ThetaMeshAxisRef;
ZMeshAxisRef = handles.ZMeshAxisRef;
OptMapFMovieRef = handles.OptMapFMovieRef;
FirstFrameOptMap = handles.FirstFrameOptMap;
LastFrameOptMap = handles.LastFrameOptMap;
ProjectedMap = handles.ProjectedMap;

handles.MapTotal(handles.MapTotal==0) = -1000;
MapTotal = handles.MapTotal;
MapTotalBW = MapTotal(:,:,:,1);
MapTotalBW(MapTotalBW>-314) = 1;
MapTotalBW(MapTotalBW<-314) = 0;
MapTotalBW = logical(MapTotalBW);
stats = regionprops3BoundingBox(MapTotalBW);
BbCoords = stats{1,2};
BbCoords = floor(BbCoords);
MapTotalCrop = zeros(BbCoords(5)+1,BbCoords(4)+1,BbCoords(6)+1,size(MapTotal,4));
for iFrame = 1:size(MapTotal,4)
   MapTotalCrop(:,:,:,iFrame) = MapTotal(BbCoords(2):BbCoords(2)+BbCoords(5),BbCoords(1):BbCoords(1)+BbCoords(4),BbCoords(3):BbCoords(3)+BbCoords(6),iFrame);
end

handles.MapFinalCamA(handles.MapFinalCamA==0) = -1000;
handles.MapFinalCamB(handles.MapFinalCamB==0) = -1000;
handles.MapFinalCamC(handles.MapFinalCamC==0) = -1000;
handles.MapFinalCamD(handles.MapFinalCamD==0) = -1000;

PosCamName = strfind(handles.filenameOptCamA,'A');
PosExtension = strfind(handles.filenameOptCamA,'.mat');
if ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
    FileNameToSave = strcat(handles.pathname,handles.filenameOptCamA(1:PosCamName-1),handles.filenameOptCamA(PosCamName+1:PosExtension-1),'Projected-Frames',num2str(FirstFrameOptMap),'to',num2str(LastFrameOptMap));
else
    FileNameToSave = strcat(handles.pathname,handles.filenameOptCamA(1:PosCamName-1),handles.filenameOptCamA(PosCamName+1:PosExtension-1),'Projected');
end
FileNameToSaveShort = strcat(handles.filenameOptCamA(1:PosCamName-1),handles.filenameOptCamA(PosCamName+1:PosExtension-1),'Projected');

if exist(strcat(FileNameToSave,'.mat'),'file') == 2
    OverwriteIndex = chooseSavedialog;
else
    OverwriteIndex = 1;
end
   
if OverwriteIndex == 1
    save(FileNameToSave,'R','ThetaMeshAxis','ZMeshAxis','OptMapFMovie','FirstFrameOptMap','LastFrameOptMap','ProjectedMap','MapTotal','-v7.3')
end

% The data (full map and individual maps) is saved in a raw format to be viewed later in Amira (if it was not already saved earlier)
if ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
    dir = cd;
    cd(handles.pathname);
    if ~exist(FileNameToSaveShort,'dir')        
        mkdir(FileNameToSaveShort)
    end
    cd(strcat(handles.pathname,FileNameToSaveShort));        
    for iFrame=handles.FirstFrameOptMap:handles.LastFrameOptMap
        if OverwriteIndex == 1          
%             % Projected and displayed map
%             fidu = fopen(strcat(FileNameToSaveShort,'v2',num2str(iFrame)),'w');
%             fwrite(fidu,squeeze(handles.ProjectedMap(:,:,:,iFrame-FirstFrameOptMap+1)),'double');
%             fclose(fidu);
            % Projected map before display 
            fidu = fopen(strcat(FileNameToSaveShort,num2str(iFrame)),'w');
            fwrite(fidu,squeeze(handles.MapTotal(:,:,:,iFrame-FirstFrameOptMap+1)),'double');
            fclose(fidu);
%             % Individual projected maps
%             fidu = fopen(strcat(FileNameToSaveShort,'CamAOnly',num2str(iFrame)),'w');
%             fwrite(fidu,squeeze(handles.MapFinalCamA(:,:,:,iFrame-FirstFrameOptMap+1)),'double');
%             fclose(fidu);
%             fidu = fopen(strcat(FileNameToSaveShort,'CamBOnly',num2str(iFrame)),'w');
%             fwrite(fidu,squeeze(handles.MapFinalCamB(:,:,:,iFrame-FirstFrameOptMap+1)),'double');
%             fclose(fidu);
%             fidu = fopen(strcat(FileNameToSaveShort,'CamCOnly',num2str(iFrame)),'w');
%             fwrite(fidu,squeeze(handles.MapFinalCamC(:,:,:,iFrame-FirstFrameOptMap+1)),'double');
%             fclose(fidu);
%             fidu = fopen(strcat(FileNameToSaveShort,'CamDOnly',num2str(iFrame)),'w');
%             fwrite(fidu,squeeze(handles.MapFinalCamD(:,:,:,iFrame-FirstFrameOptMap+1)),'double');
%             fclose(fidu);                      
        end
    end
    if OverwriteIndex == 1
        % Reference map with the repartition of the different cams onto
        % the final map
        fidu = fopen(strcat(FileNameToSaveShort,'CamRef'),'w');
        fwrite(fidu,handles.MapRef(:,:,:),'double');
        fclose(fidu);
    end
    cd(dir);
else  
    if OverwriteIndex == 1
        % Projected and displayed map
        fidu = fopen(strcat(FileNameToSave,'v2'),'w');
        fwrite(fidu,handles.ProjectedMap,'double');
        fclose(fidu);
        % Projected map
        fidu = fopen(FileNameToSave,'w');
        fwrite(fidu,handles.MapTotal,'double');
        fclose(fidu);
        % Individual projected maps
        fidu = fopen(strcat(FileNameToSave,'CamAOnly'),'w');
        fwrite(fidu,handles.MapFinalCamA,'double');
        fclose(fidu);
        fidu = fopen(strcat(FileNameToSave,'CamBOnly'),'w');
        fwrite(fidu,handles.MapFinalCamB,'double');
        fclose(fidu);
        fidu = fopen(strcat(FileNameToSave,'CamCOnly'),'w');
        fwrite(fidu,handles.MapFinalCamC,'double');
        fclose(fidu);
        fidu = fopen(strcat(FileNameToSave,'CamDOnly'),'w');
        fwrite(fidu,handles.MapFinalCamD,'double');
        fclose(fidu);
        % Reference map with the repartition of the different cams onto
        % the final map
        fidu = fopen(strcat(FileNameToSave,'CamRef'),'w');
        fwrite(fidu,handles.MapRef,'double');
        fclose(fidu);
    end
end
guidata(hObject, handles);

% --- PROJECTION Load an existing map for visualization
function pushbutton36_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
if ~isfield(handles,'pathname')
    handles.pathname = cd;
end
[file_nameOptMap,path_name] = uigetfile({'*.mat','MAT-file'},'Select an existing map',handles.pathname);
handles.pathname = path_name;
load(strcat(handles.pathname,file_nameOptMap))
handles.R = R;
handles.ThetaMeshAxis = ThetaMeshAxis;
handles.ZMeshAxis = ZMeshAxis;
handles.OptMapFMovie = OptMapFMovie;
if exist('RRef')==1
    handles.RRef = RRef;
    handles.ThetaMeshAxisRef = ThetaMeshAxisRef;
    handles.ZMeshAxisRef = ZMeshAxisRef;
    handles.OptMapFMovieRef = OptMapFMovieRef;
else
   handles.RefMapbutton_state = get(handles.radiobutton3,'Min');
   set(handles.radiobutton3,'Value',handles.RefMapbutton_state);
end
handles.FirstFrameOptMap = FirstFrameOptMap;
handles.LastFrameOptMap = LastFrameOptMap;
set(handles.edit4,'String',FirstFrameOptMap);
set(handles.edit5,'String',LastFrameOptMap);
handles.ProjectedMap = ProjectedMap;

PosActivationMap = strfind(file_nameOptMap,'ActivationMap');
PosDomFreqMap = strfind(file_nameOptMap,'DomFreqMap');
PosAPDMap = strfind(file_nameOptMap,'APDMap');
PosPhaseMapMovie = strfind(file_nameOptMap,'PhaseMapMovie');

if ~isempty(PosActivationMap)
    handles.filenameOptCamA = strcat(file_nameOptMap(1:PosActivationMap-1),'AActivationMap.mat');
elseif ~isempty(PosDomFreqMap)
    handles.filenameOptCamA = strcat(file_nameOptMap(1:PosDomFreqMap-1),'ADomFreq.mat');
elseif  ~isempty(PosAPDMap)
    handles.filenameOptCamA = strcat(file_nameOptMap(1:PosAPDMap-1),'AAPDMap.mat');
elseif  ~isempty(PosPhaseMapMovie)
    handles.filenameOptCamA = strcat(file_nameOptMap(1:PosPhaseMapMovie-1),'APhaseMapMovie.mat');
end

handles.Axesbutton_state = get(handles.radiobutton1,'Value');
handles.Gridbutton_state = get(handles.radiobutton2,'Value');
handles.RefMapbutton_state = get(handles.radiobutton3,'Value');

Zmin = round(get(handles.slider11,'Value'));
Zmax = round(get(handles.slider10,'Value'));

if Zmax == 1 && Zmin == 0
    set(handles.slider10,'Min',round(size(R,2)/2));
    set(handles.slider10,'Max',size(R,2));
    set(handles.slider10,'Value',size(R,2));
    set(handles.slider11,'Min',1);
    set(handles.slider11,'Max',round(size(R,2)/2));
    set(handles.slider11,'Value',1);
    Zmin = round(get(handles.slider11,'Value'));
    Zmax = round(get(handles.slider10,'Value'));

end
handles.ColorbarMax = str2double(get(handles.edit7,'String'));

axes(handles.axes3)
[az,el] = view;
h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
set(h,'LineStyle','none')
view(az,el)
axis image
colormap(jet)
if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
    caxis([0 handles.ColorbarMax])
elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
    caxis([-handles.ColorbarMax handles.ColorbarMax])
end
if ~isfield(handles,'fig')
    handles.fig = figure;
end
figure(handles.fig)
if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
    subplot(121)
    h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
    set(h,'LineStyle','none')
    view(az,el)
    axis image
    colormap(jet)
    if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
        caxis([0 handles.ColorbarMax])
    elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
        caxis([-handles.ColorbarMax handles.ColorbarMax])
    end
    subplot(122)
    h = surf(handles.RRef(:,Zmin:Zmax).*cos(handles.ThetaMeshAxisRef(Zmin:Zmax,:)).',handles.RRef(:,Zmin:Zmax).*sin(handles.ThetaMeshAxisRef(Zmin:Zmax,:)).',handles.ZMeshAxisRef(Zmin:Zmax,:).',squeeze(handles.OptMapFMovieRef(:,Zmin:Zmax,1)));
    set(h,'LineStyle','none')
    view(az,el)
    axis image
    colormap(jet)
elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
    h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
    set(h,'LineStyle','none')
    view(az,el)
    axis image
    colormap(jet)
    if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
        caxis([0 handles.ColorbarMax])
    elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
        caxis([-handles.ColorbarMax handles.ColorbarMax])
    end
    
end
if handles.Axesbutton_state == get(handles.radiobutton1,'Max')
    handles.axes3.Visible = 'on';
    figure(handles.fig)
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        ax = gca;
        ax.Visible = 'on';
        subplot(122)
        ax = gca;
        ax.Visible = 'on';
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')        
        ax = gca;
        ax.Visible = 'on';
    end
elseif handles.Axesbutton_state == get(handles.radiobutton1,'Min')
    handles.axes3.Visible = 'off';
    figure(handles.fig)
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        ax = gca;
        ax.Visible = 'off';
        subplot(122)
        ax = gca;
        ax.Visible = 'off';
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        ax = gca;
        ax.Visible = 'off';
    end
end
if handles.Gridbutton_state == get(handles.radiobutton2,'Max')
    axes(handles.axes3)
    grid on;
    figure(handles.fig);    
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        grid on;
        subplot(122)
        grid on;
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        grid on;
    end
elseif handles.Gridbutton_state == get(handles.radiobutton2,'Min')
    axes(handles.axes3)
    grid off;
    figure(handles.fig);
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        grid off;
        subplot(122)
        grid off;    
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        grid off;
    end
end
guidata(hObject, handles);

% PROJECTION Choose the movie frame rate
function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
handles.output = hObject;
handles.FrameRate = get(handles.edit6,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% PROJECTION Choose the max of the colorbar (in case of activation map the
% min is 0, in phase movie it is -max)
function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
handles.output = hObject;

Zmin = round(get(handles.slider11,'Value'));
Zmax = round(get(handles.slider10,'Value'));

handles.ColorbarMax = str2double(get(handles.edit7,'String'));
handles.RefMapbutton_state = get(handles.radiobutton3,'Value');
axes(handles.axes3)
[az,el] = view;
h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
set(h,'LineStyle','none')
view(az,el)
axis image
colormap(jet)
if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
    caxis([0 handles.ColorbarMax])
elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
    caxis([-handles.ColorbarMax handles.ColorbarMax])
end
figure(handles.fig)
if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
    subplot(121)
    h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
    set(h,'LineStyle','none')
    view(az,el)
    axis image
    colormap(jet)
    if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
        caxis([0 handles.ColorbarMax])
    elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
        caxis([-handles.ColorbarMax handles.ColorbarMax])
    end
    subplot(122)
    h = surf(handles.RRef(:,Zmin:Zmax).*cos(handles.ThetaMeshAxisRef(Zmin:Zmax,:)).',handles.RRef(:,Zmin:Zmax).*sin(handles.ThetaMeshAxisRef(Zmin:Zmax,:)).',handles.ZMeshAxisRef(Zmin:Zmax,:).',squeeze(handles.OptMapFMovieRef(:,Zmin:Zmax,1)));
    set(h,'LineStyle','none')
    view(az,el)
    axis image
    colormap(jet)
elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
    h = surf(handles.R(:,Zmin:Zmax).*cos(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.R(:,Zmin:Zmax).*sin(handles.ThetaMeshAxis(Zmin:Zmax,:)).',handles.ZMeshAxis(Zmin:Zmax,:).',squeeze(handles.OptMapFMovie(:,Zmin:Zmax,1)));
    set(h,'LineStyle','none')
    view(az,el)
    axis image
    colormap(jet)
    if  ~isempty(strfind(handles.filenameOptCamA,'ActivationMap')) || ~isempty(strfind(handles.filenameOptCamA,'DomFreqMap')) || ~isempty(strfind(handles.filenameOptCamA,'APDMap'))
        caxis([0 handles.ColorbarMax])
    elseif ~isempty(strfind(handles.filenameOptCamA,'PhaseMapMovie'))
        caxis([-handles.ColorbarMax handles.ColorbarMax])
    end
end
if handles.Axesbutton_state == get(handles.radiobutton1,'Max')
    handles.axes3.Visible = 'on';
    figure(handles.fig)
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        ax = gca;
        ax.Visible = 'on';
        subplot(122)
        ax = gca;
        ax.Visible = 'on';
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        ax = gca;
        ax.Visible = 'on';
    end
elseif handles.Axesbutton_state == get(handles.radiobutton1,'Min')
    handles.axes3.Visible = 'off';
    figure(handles.fig)
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        ax = gca;
        ax.Visible = 'off';
        subplot(122)
        ax = gca;
        ax.Visible = 'off';
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        ax = gca;
        ax.Visible = 'off';
    end
end
if handles.Gridbutton_state == get(handles.radiobutton2,'Max')
    axes(handles.axes3)
    grid on;
    figure(handles.fig);
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        grid on;
        subplot(122)
        grid on;
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        grid on;
    end
elseif handles.Gridbutton_state == get(handles.radiobutton2,'Min')
    axes(handles.axes3)
    grid off;
    figure(handles.fig);
    if handles.RefMapbutton_state == get(handles.radiobutton3,'Max')
        subplot(121)
        grid off;
        subplot(122)
        grid off;
    elseif handles.RefMapbutton_state == get(handles.radiobutton3,'Min')
        grid off;
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% PROJECTION Choose the elevation angle from which the heart is seen in the
% camera rotation movie
function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
handles.output = hObject;
handles.ElevationAngle = str2double(get(handles.edit8,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
handles.output = hObject;
handles.RefMapbutton_state = get(hObject,'Value');
guidata(hObject, handles);



function [Vertices, Triangle, Quads] = make_STL_of_Array(FileName,Data,scaleX,scaleY,scaleZ)  
% make_STL_of_Array  Convert a voxelised object contained within a 3D logical array into an STL surface mesh

    Vertices = zeros(8*size(Data,1)* size(Data,2)* size(Data,3), 3);    
    Quads = zeros(6*size(Data,1)* size(Data,2)* size(Data,3), 4);
    Triangle = zeros(12*size(Data,1)* size(Data,2)* size(Data,3), 3);
    
    Vertices_Pointer = 1;
    Quads_Pointer = 1;
    Triangle_Pointer = 1;
    GoIn3D = 0;
    ZlayerVertexNum = 0;
    PrevZlayerVertexNum = 0;
    PrevVertexPointer = 0;
%======================================================
%   LOOPING THROUGH EVERY ELEMENTS OF 3D LOGICAL ARRAY(Data)
%======================================================
   
    for i3 = 1 : size(Data,3)
        ZlayerVertexNum = 0;
        for i2 = 1 : size(Data,2)
            for i1 = 1 : size(Data,1)
                % i1 and i2 will change inside a for loop so we use i11 and
                % i22 to save the value before changing and we will use them
                i11 = i1;
                i22 = i2;

                % check that Data(i1,i2,i3) is not surronded by 1s!
                if i1 ~= 1 && i2 ~= 1 && i3 ~= 1 && i1 ~= size(Data,1) && i2 ~= size(Data,2) && i3 ~= size(Data,3) && Data(i1 - 1,i2,i3) == 2 && Data(i1,i2 - 1,i3) == 2 && Data(i1,i2,i3 - 1) == 2 && (Data(i1 + 1,i2,i3) == 1 || Data(i1 + 1,i2,i3) == 2 ) && (Data(i1,i2 + 1,i3) == 1 || Data(i1,i2 + 1,i3) == 2 ) && (Data(i1,i2,i3 + 1) == 1 || Data(i1,i2,i3 + 1) == 2 ) && Data(i1,i2,i3) ~= 0
                    Data(i1,i2,i3) = 2;
                    continue;
                end
                
                
                if Data(i1,i2,i3) == 1
                    %======================================================
                    %   LOOKING FOR THE BIGGEST RECTANGLE (BY ITS AREA) FROM THIS PONT
                    %   IN 2D!
                    %   FOR THIS WE LOOPING THROUGH X AND Y TILL FINDING A ZERO IN THAT DIRECTION!
                    %   WE SAVE THE INDEX OF X AND Y OF THE BIGGEST AREA IN
                    %   maxX, maxY
                    %======================================================

                    maxX = 0;
                    maxY = 0;

                    loop2Len = size(Data,2);
                    for i1 = i1 : size(Data,1)
                        i2 = i22;
                        % IF WE REACH A VOXEL FROM OUTSIDE WE BREAK FROM THE
                        % LOOP
                        if Data(i1,i2,i3) ~= 1
                            i1 = i1 - 1;
                            break;
                        end
                        for i2 = i2 : loop2Len
                            % IF WE REACH A VOXEL FROM OUTSIDE WE BREAK FROM THE
                            % LOOP
                            if Data(i1,i2,i3) ~= 1
                                loop2Len = i2 -1;
                                i2 = i2 - 1;
                                break;
                            else
                                if maxX*maxY < (i1 - i11 + 1) * (i2 - i22 + 1)
                                    maxX = i1 - i11;
                                    maxY = i2 - i22;
                                end
                            end
                        end
                    end

                    % WE CHANGE THE VALUE OF THE BIGGEST AREA TO 2, IT
                    % MEANS THAT WE'LL NOT CONSIDER THIS AREA AGAIN
                    Data(i11:i11 + maxX, i22:i22 + maxY, i3) = 2;
                    
                    % CREATE THE VERTICES AND ADD THEM TO Vertices MATRIX
                    % AND INCREAS THE Vertices_Pointer
                    V1 = [ (i11 - 1) * scaleX , (i22 - 1) * scaleY, (i3 - 1) * scaleZ];
                    V2 = [ (i11 + maxX) * scaleX , (i22 - 1) * scaleY, (i3 - 1) * scaleZ];
                    V3 = [ (i11 - 1) * scaleX , (i22 + maxY) * scaleY, (i3 - 1) * scaleZ];
                    V4 = [ (i11 + maxX) * scaleX , (i22 + maxY) * scaleY, (i3 - 1) * scaleZ];

                    V5 = [ (i11 - 1) * scaleX , (i22 - 1) * scaleY, (i3) * scaleZ];
                    V6 = [ (i11 + maxX) * scaleX , (i22 - 1) * scaleY, (i3) * scaleZ];
                    V7 = [ (i11 - 1) * scaleX , (i22 + maxY) * scaleY, (i3) * scaleZ];
                    V8 = [ (i11 + maxX) * scaleX , (i22 + maxY) * scaleY, (i3) * scaleZ];
                    
                    % CHCK IF IT CAN GO IN DEPTH OR NOT
                    GoIn3D = 0;
                    if PrevVertexPointer > 0
                        for i4 = PrevVertexPointer - PrevZlayerVertexNum : 8 : Vertices_Pointer - 8
                           if size(Vertices) > 0
                              if Vertices(i4,1) == V1(1) && Vertices(i4,2) == V1(2) && Vertices(i4 + 1,1) == V2(1) && Vertices(i4 + 1,2) == V2(2) && Vertices(i4 + 2,1) == V3(1) && Vertices(i4 + 2,2) == V3(2) && Vertices(i4 + 3,1) == V4(1) && Vertices(i4 + 3,2) == V4(2)  
                                  GoIn3D = 1;
                                  Vertices(i4 + 4,3) = Vertices(i4 + 4,3) + scaleZ;
                                  Vertices(i4 + 5,3) = Vertices(i4 + 5,3) + scaleZ;
                                  Vertices(i4 + 6,3) = Vertices(i4 + 6,3) + scaleZ;
                                  Vertices(i4 + 7,3) = Vertices(i4 + 7,3) + scaleZ;
                                  break;
                               end 
                           end
                        end
                    end
                    
                    if GoIn3D == 1
                        continue;
                    end
                    
                    ZlayerVertexNum = ZlayerVertexNum + 8;
                    
                    if Vertices_Pointer == 0
                        Vertices = cat(1,Vertices,V1);
                    end

                    Vertices(Vertices_Pointer,:) = V1;
                    V_pointer1 = Vertices_Pointer;
                    Vertices_Pointer = Vertices_Pointer + 1;

                    Vertices(Vertices_Pointer,:) = V2;
                    V_pointer2 = Vertices_Pointer;
                    Vertices_Pointer = Vertices_Pointer + 1;

                    Vertices(Vertices_Pointer,:) = V3;
                    V_pointer3 = Vertices_Pointer;
                    Vertices_Pointer = Vertices_Pointer + 1;

                    Vertices(Vertices_Pointer,:) = V4;
                    V_pointer4 = Vertices_Pointer;
                    Vertices_Pointer = Vertices_Pointer + 1;

                    Vertices(Vertices_Pointer,:) = V5;
                    V_pointer5 = Vertices_Pointer;
                    Vertices_Pointer = Vertices_Pointer + 1;
    
                    Vertices(Vertices_Pointer,:) = V6;
                    V_pointer6 = Vertices_Pointer;
                    Vertices_Pointer = Vertices_Pointer + 1;
    
                    Vertices(Vertices_Pointer,:) = V7;
                    V_pointer7 = Vertices_Pointer;
                    Vertices_Pointer = Vertices_Pointer + 1;

                    Vertices(Vertices_Pointer,:) = V8;
                    V_pointer8 = Vertices_Pointer;
                    Vertices_Pointer = Vertices_Pointer + 1;
                end
            end
        end
        PrevZlayerVertexNum = ZlayerVertexNum;
        PrevVertexPointer = Vertices_Pointer;
    end
    
    % CUT THE UNUSED ELEMENTS OF Vertices
    Vertices = Vertices(1:Vertices_Pointer - 1,:);
    
    % CREATE THE QUADS AND ADD THEM TO Quads MATRIX
    % AND INCREAS THE Quads_Pointer
    Quads_Pointer = 1;
    for iInVertices = 1 : 8: size(Vertices)
        Quads(Quads_Pointer,:) = [iInVertices, iInVertices + 1, iInVertices + 2, iInVertices + 3];
        Quads_Pointer = Quads_Pointer + 1;
        Quads(Quads_Pointer,:) = [iInVertices + 4, iInVertices + 5, iInVertices + 6, iInVertices + 7];
        Quads_Pointer = Quads_Pointer + 1;
        Quads(Quads_Pointer,:) = [iInVertices + 4, iInVertices + 5, iInVertices, iInVertices + 1];
        Quads_Pointer = Quads_Pointer + 1;
        Quads(Quads_Pointer,:) = [iInVertices + 2, iInVertices + 3, iInVertices + 6, iInVertices + 7];
        Quads_Pointer = Quads_Pointer + 1;
        Quads(Quads_Pointer,:) = [iInVertices + 4, iInVertices, iInVertices + 6, iInVertices + 2];
        Quads_Pointer = Quads_Pointer + 1;
        Quads(Quads_Pointer,:) = [iInVertices + 1, iInVertices + 5, iInVertices + 3, iInVertices + 7];
        Quads_Pointer = Quads_Pointer + 1;
    end
    
    % CUT THE UNUSED ELEMENTS OF Quads
    Quads = Quads(1:Quads_Pointer - 1,:);
    
    % REMOVE REPETITIOUS QUADS
    Quads = unique(Quads,'rows','stable');
    
    % CREATE THE TRIAGNLES FROM QUADS AND ADD THEM TO Triangle MATRIX
    % AND INCREAS THE Triangle_Pointer
    for i = 1 : size(Quads,1)
       Triangle(Triangle_Pointer,:) = [Quads(i,1) Quads(i,2) Quads(i,3)];
       Triangle_Pointer = Triangle_Pointer + 1;
       Triangle(Triangle_Pointer,:) = [Quads(i,4) Quads(i,2) Quads(i,3)];
       Triangle_Pointer = Triangle_Pointer + 1;
    end
    
    % CUT THE UNUSED ELEMENTS OF MATRIXES
    Triangle = Triangle(1:Triangle_Pointer - 1,:);
    
    % WRITE THE STL FILE
stlwrite(FileName, Triangle, Vertices);