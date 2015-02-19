function varargout = SQIannot(varargin)
% SQIANNOT MATLAB code for SQIannot.fig
%      SQIANNOT, by itself, creates a new SQIANNOT or raises the existing
%      singleton*.
%
%      H = SQIANNOT returns the handle to a new SQIANNOT or the handle to
%      the existing singleton*.
%
%      SQIANNOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SQIANNOT.M with the given input arguments.
%
%      SQIANNOT('Property','Value',...) creates a new SQIANNOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SQIannot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SQIannot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SQIannot

% Last Modified by GUIDE v2.5 19-Feb-2015 13:31:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SQIannot_OpeningFcn, ...
    'gui_OutputFcn',  @SQIannot_OutputFcn, ...
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


% --- Executes just before SQIannot is made visible.
function SQIannot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SQIannot (see VARARGIN)


%movegui(hObject,'center')     % move GUI to center
% Checking .png and loading former annotations
if isdeployed
    p = [ctfroot filesep 'data' filesep];
    sprintf('%s',p)
    handles.files=subdir(p,'*.png');
    folder_name = uigetdir('C:\','Please select folder containing/saving annotations');
    handles.afile = [folder_name filesep 'anotations.dat'];
    sprintf('%s',handles.afile)
else
    p = mfilename('fullpath');
    [~,perr] = strtok(p(end:-1:1),filesep);
    p = perr(end:-1:1);
    handles.files = subdir([p 'data'],'*.png');
    handles.afile = [p 'anotations.dat'];
end
clear perr
handles.files = arrayfun(@(x) x.name,handles.files,'UniformOutput',0);
% for i = 1:length(handles.files)
%     sprintf('%s',handles.files{i})
% end


% annotation file
if ~exist(handles.afile,'file')
    handles.data = zeros(length(handles.files),9);
    handles.data(:,1) = randperm(length(handles.files));
    csvwrite(handles.afile,handles.data);
    handles.pointer = 1;
else
    handles.data = csvread(handles.afile);
    handles.pointer = find(handles.data(:,2)==0,1);
    if isempty(handles.pointer)
        handles.pointer = length(handles.files);
    end
end


loadfig(hObject, handles);

% Choose default command line output for SQIannot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SQIannot wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%--- Loads a .png --%
function loadfig(hObject,handles)
if handles.pointer > length(handles.files)
    handles.pointer = length(handles.files);
    guidata(hObject, handles);
    selection = questdlg('Congrats, you are done annotating! Want to exit the program?',...
        'Done!',...
        'Yes','No','Yes');
    switch selection,
        case 'Yes',
            hf=findobj('Name','SQIannot');
            close(hf)
            return
        case 'No'
            return
    end
elseif handles.pointer < 1
    handles.pointer = 1;
    guidata(hObject, handles);
    warndlg('First segment!')
    return
else
    myImage = imread(handles.files{handles.data(handles.pointer,1)});
    axes(handles.axes1);
    imshow(myImage);
    % checks if datasets were already annotated,
    % otherwise clears selection
    snr = handles.data(handles.pointer,2);
    fecg = handles.data(handles.pointer,3);
    if snr==0
        set(handles.uipanel1,'SelectedObject',[]);
    else
        eval(['set(handles.snr' num2str(snr) ',''Value'',1);'])
    end
    
    if fecg==0
        set(handles.uipanel2,'SelectedObject',[]);
    else
        eval(['set(handles.fecg' num2str(fecg)  ',''Value'',1);'])
    end
    % updating handles
    guidata(hObject, handles);
end




% --- Outputs from this function are returned to the command line.
function varargout = SQIannot_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in next_btn.
function next_btn_Callback(hObject, eventdata, handles)
% hObject    handle to next_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% does not allow that objects are empty
if isempty(get(handles.uipanel1,'SelectedObject')) || ...
        isempty(get(handles.uipanel2,'SelectedObject'))
    return
end

% Saving data
switch get(get(handles.uipanel1,'SelectedObject'),'Tag')
    case 'snr1',    handles.data(handles.pointer,2) = 1;
    case 'snr2',    handles.data(handles.pointer,2) = 2;
    case 'snr3',    handles.data(handles.pointer,2) = 3;
    case 'snr4',    handles.data(handles.pointer,2) = 4;
    case 'snr5',    handles.data(handles.pointer,2) = 5;
    otherwise,  error('Wierd')
end
switch get(get(handles.uipanel2,'SelectedObject'),'Tag')
    case 'fecg1',    handles.data(handles.pointer,3) = 1;
    case 'fecg2',    handles.data(handles.pointer,3) = 2;
    case 'fecg3',    handles.data(handles.pointer,3) = 3;
    case 'fecg4',    handles.data(handles.pointer,3) = 4;
    otherwise,  error('Wierd')
end
handles.data(handles.pointer,4:9) = clock;
handles.pointer = handles.pointer+1;

% updating handles
guidata(hObject, handles);
% loading next
loadfig(hObject,handles)

csvwrite(handles.afile,handles.data);


% --- Executes on button press in previous_btn.
function previous_btn_Callback(hObject, eventdata, handles)
% hObject    handle to previous_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.pointer = handles.pointer-1;
% updating handles
guidata(hObject, handles);
% loading previous
loadfig(hObject,handles)

% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, e, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch e.Key
    case {'1' '2' '3' '4' '5'}
        eval(['set(handles.snr' e.Key ',''Value'',1);'])
    case {'a' 's' 'd' 'f'}
        idx = strmatch(e.Key,{'a' 's' 'd' 'f'});
        eval(['set(handles.fecg' num2str(idx) ',''Value'',1);'])
%     otherwise
%         if strcmp(e.Key,'rightarrow')
%             next_btn_Callback(hObject, e, handles);
%         elseif strcmp(e.Key,'leftarrow')
%             previous_btn_Callback(hObject, e, handles);
%         end
end
if (handles.pointer == length(handles.files)) || (handles.pointer == 1)
    return
else
    guidata(hObject, handles);
end

