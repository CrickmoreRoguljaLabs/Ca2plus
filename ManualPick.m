function varargout = ManualPick(varargin)
% MANUALPICK MATLAB code for ManualPick.fig
%      MANUALPICK, by itself, creates a new MANUALPICK or raises the existing
%      singleton*.
%
%      H = MANUALPICK returns the handle to a new MANUALPICK or the handle to
%      the existing singleton*.
%
%      MANUALPICK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALPICK.M with the given input arguments.
%
%      MANUALPICK('Property','Value',...) creates a new MANUALPICK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ManualPick_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ManualPick_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Coded by Stephen Zhang
% Edit the above text to modify the response to help ManualPick

% Last Modified by GUIDE v2.5 10-Feb-2014 22:00:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ManualPick_OpeningFcn, ...
                   'gui_OutputFcn',  @ManualPick_OutputFcn, ...
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


% --- Executes just before ManualPick is made visible.
function ManualPick_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ManualPick (see VARARGIN)

% Choose default command line output for ManualPick
handles.output = hObject;

YesNo = evalin('base','exist(''ica_segments'',''var'')');

if YesNo==1
    handles.ica_segments=evalin('base','ica_segments');
    %handles.segcentroid=evalin('base','segcentroid');
    handles.fn=evalin('base','fn');
    handles.totalfilters=size(handles.ica_segments,1);
    sampleim=imread(handles.fn,1);
else
    msgbox('Please make sure CellSort data are loaded to workspace','Need data to initiate');
end

YesNo = evalin('base','exist(''pass_or_fail'',''var'')');

if YesNo==1
    handles.pass_or_fail=evalin('base','pass_or_fail');
else
    handles.pass_or_fail=zeros(handles.totalfilters,2);
    handles.pass_or_fail(:,1)=1:handles.totalfilters;
end

handles.filtertoshow=repmat(sampleim,[1,1,3]);
handles.allfilters=handles.filtertoshow;
handles.filtertoshow(:,:,3)=0;
handles.allfilters(:,:,3)=squeeze(sum(handles.ica_segments>0,1))*100;

handles.filterindex=1;
handles.overlapcleared=0;
set(handles.text1,'String',handles.fn);


set(handles.filterslider,'Max',handles.totalfilters);
set(handles.filterslider,'SliderStep',[1/handles.totalfilters,0.1]);

txtspaceholder = repmat({'  '}, handles.totalfilters, 1);
handles.txtspaceholder=txtspaceholder;

set(handles.edit1,'String',[num2str(handles.filterindex),'/',num2str(handles.totalfilters)]);

handles.filtertoshow(:,:,1)=120*(handles.ica_segments(handles.filterindex,:,:)>0);
handles.allfilters(:,:,1)=120*(handles.ica_segments(handles.filterindex,:,:)>0);
imshow(handles.filtertoshow, 'Parent', handles.axes1)
imshow(handles.allfilters, 'Parent', handles.axes2)

set(handles.listbox1,'String',strcat(num2str(handles.pass_or_fail(:,1)),txtspaceholder,num2str(handles.pass_or_fail(:,2))));

handles.checked=0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ManualPick wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ManualPick_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonpass.
function pushbuttonpass_Callback(hObject, ~, handles)
% hObject    handle to pushbuttonpass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.pass_or_fail(handles.filterindex,2)=2;
currentfilter=squeeze(handles.ica_segments(handles.filterindex,:,:)>0);
pastfilters=handles.filtertoshow(:,:,3)>0;
handles.pastfilters=(currentfilter+pastfilters)>0;
handles.filtertoshow(:,:,3)=120*handles.pastfilters;

if handles.filterindex~=handles.totalfilters
    handles.filterindex=handles.filterindex+1;
else
    undone=sum(handles.pass_or_fail(:,2)==0);
    if undone <=0 
        msgbox('Scoring is complete','Complete')
        set(handles.text1,'String',[handles.fn,' - complete']);
    else
        msgbox([num2str(undone),' to go.'],'Incomplete')
    end
end

handles.filtertoshow(:,:,1)=120*(handles.ica_segments(handles.filterindex,:,:)>0);
handles.allfilters(:,:,1)=120*(handles.ica_segments(handles.filterindex,:,:)>0);
imshow(handles.filtertoshow, 'Parent', handles.axes1)
imshow(handles.allfilters, 'Parent', handles.axes2)
set(handles.edit1,'String',[num2str(handles.filterindex),'/',num2str(handles.totalfilters)]);
set(handles.filterslider,'Value',handles.filterindex);
assignin('base', 'pass_or_fail', handles.pass_or_fail);
set(handles.listbox1,'String',strcat(num2str(handles.pass_or_fail(:,1)),handles.txtspaceholder,num2str(handles.pass_or_fail(:,2))));
set(handles.listbox1,'Value',handles.filterindex);

set( handles.pushbuttonpass, 'Enable', 'off');
drawnow;
set( handles.pushbuttonpass, 'Enable', 'on');
guidata(hObject, handles);


% --- Executes on button press in pushbuttonfail.
function pushbuttonfail_Callback(hObject, ~, handles)
% hObject    handle to pushbuttonfail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.pass_or_fail(handles.filterindex,2)=1;


if handles.filterindex~=handles.totalfilters
    handles.filterindex=handles.filterindex+1;
else
    undone=sum(handles.pass_or_fail(:,2)==0);
    if undone <=0 
        msgbox('Scoring is complete','Complete')
        set(handles.text1,'String',[handles.fn,' - complete']);
        else
        msgbox([num2str(undone),' to go.'],'Incomplete')
    end
end

handles.filtertoshow(:,:,1)=120*(handles.ica_segments(handles.filterindex,:,:)>0);
handles.allfilters(:,:,1)=120*(handles.ica_segments(handles.filterindex,:,:)>0);
imshow(handles.filtertoshow, 'Parent', handles.axes1)
imshow(handles.allfilters, 'Parent', handles.axes2)
set(handles.edit1,'String',[num2str(handles.filterindex),'/',num2str(handles.totalfilters)]);
set(handles.filterslider,'Value',handles.filterindex);
assignin('base', 'pass_or_fail', handles.pass_or_fail);
set(handles.listbox1,'String',strcat(num2str(handles.pass_or_fail(:,1)),handles.txtspaceholder,num2str(handles.pass_or_fail(:,2))));
set(handles.listbox1,'Value',handles.filterindex);

set( handles.pushbuttonfail, 'Enable', 'off');
drawnow;
set( handles.pushbuttonfail, 'Enable', 'on');
guidata(hObject, handles);

% --- Executes on button press in pushbuttonexit.
function pushbuttonexit_Callback(~, ~, ~)
% hObject    handle to pushbuttonexit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf)


function edit1_Callback(~, ~, ~)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, ~, ~)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function filterslider_Callback(hObject, ~, handles)
% hObject    handle to filterslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.filterindex=round(get(hObject,'Value'));
handles.filtertoshow(:,:,1)=120*(handles.ica_segments(handles.filterindex,:,:)>0);
handles.allfilters(:,:,1)=120*(handles.ica_segments(handles.filterindex,:,:)>0);
imshow(handles.filtertoshow, 'Parent', handles.axes1)
imshow(handles.allfilters, 'Parent', handles.axes2)
set(handles.edit1,'String',[num2str(handles.filterindex),'/',num2str(handles.totalfilters)]);
set(handles.listbox1,'Value',handles.filterindex);

set( handles.filterslider, 'Enable', 'off');
drawnow;
set( handles.filterslider, 'Enable', 'on');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function filterslider_CreateFcn(hObject, ~, ~)
% hObject    handle to filterslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, ~, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
handles.filterindex=get(handles.listbox1,'Value');
handles.filtertoshow(:,:,1)=120*(handles.ica_segments(handles.filterindex,:,:)>0);
handles.allfilters(:,:,1)=120*(handles.ica_segments(handles.filterindex,:,:)>0);
imshow(handles.filtertoshow, 'Parent', handles.axes1)
imshow(handles.allfilters, 'Parent', handles.axes2)
set(handles.edit1,'String',[num2str(handles.filterindex),'/',num2str(handles.totalfilters)]);
set(handles.filterslider,'Value',handles.filterindex);

set( handles.listbox1, 'Enable', 'off');
drawnow;
set( handles.listbox1, 'Enable', 'on');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, ~, ~)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonclear.
function pushbuttonclear_Callback(hObject, ~, handles)
% hObject    handle to pushbuttonclear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.pass_or_fail=zeros(handles.totalfilters,2);
handles.pass_or_fail(:,1)=1:handles.totalfilters;
handles.filterindex=1;
set(handles.edit1,'String',[num2str(handles.filterindex),'/',num2str(handles.totalfilters)]);
set(handles.filterslider,'Value',handles.filterindex);
set(handles.listbox1,'String',strcat(num2str(handles.pass_or_fail(:,1)),handles.txtspaceholder,num2str(handles.pass_or_fail(:,2))));
set(handles.listbox1,'Value',handles.filterindex);
assignin('base', 'pass_or_fail', handles.pass_or_fail);
handles.pastfilters=0;
handles.filtertoshow(:,:,3)=handles.pastfilters;
imshow(handles.filtertoshow, 'Parent', handles.axes1)

set( handles.pushbuttonclear, 'Enable', 'off');
drawnow;
set( handles.pushbuttonclear, 'Enable', 'on');
guidata(hObject, handles);  


% --- Executes on button press in pushbuttoncheck.
function pushbuttoncheck_Callback(hObject, ~, handles)
% hObject    handle to pushbuttoncheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
undone=sum(handles.pass_or_fail(:,2)==0);
if undone <=0 
    set(handles.text1,'String',[handles.fn,' - complete']);
    pass_filter_numbers=handles.pass_or_fail(handles.pass_or_fail(:,2)==2,1);
    if handles.overlapcleared<1
        real_ica_segments=handles.ica_segments(pass_filter_numbers,:,:);
        handles.real_ica_segments=weirdmatrearrange3(real_ica_segments);
    end
    handles.finalfilters=handles.allfilters;
    handles.finalfilters(:,:,3)=0;
    handles.finalfilters(:,:,1)=squeeze(sum(handles.real_ica_segments>0,3))*100;
    imshow(handles.finalfilters, 'Parent', handles.axes1)
    set(handles.pushbuttonoverlap,'Enable','on')
    set(handles.pushbuttongen,'Enable','on')
    handles.checked=1;
else
    msgbox([num2str(undone),' to go.'],'Incomplete')
end

set( handles.pushbuttoncheck, 'Enable', 'off');
drawnow;
set( handles.pushbuttoncheck, 'Enable', 'on');
guidata(hObject, handles)


% --- Executes on button press in pushbuttonoverlap.
function pushbuttonoverlap_Callback(hObject, ~, handles)
% hObject    handle to pushbuttonoverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
overlappixels=squeeze(sum(handles.real_ica_segments>0,3))>1;

for i=1:size(handles.real_ica_segments,3)
    temp_ica_seg=squeeze(handles.real_ica_segments(:,:,i));
    temp_ica_seg(overlappixels)=0;
    handles.real_ica_segments(:,:,i)=temp_ica_seg;
end
handles.finalfilters(:,:,1)=squeeze(sum(handles.real_ica_segments>0,3))*100;
imshow(handles.finalfilters, 'Parent', handles.axes1)
handles.overlapcleared=1;

set( handles.pushbuttonoverlap, 'Enable', 'off');
drawnow;
set( handles.pushbuttonoverlap, 'Enable', 'on');
guidata(hObject, handles)


% --- Executes on button press in pushbuttongen.
function pushbuttongen_Callback(~, ~, handles)
% hObject    handle to pushbuttongen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
real_ica_segments=handles.real_ica_segments>0;
real_ica_segments2=real_ica_segments;
real_ica_count=1;
for i=1:size(real_ica_segments,3)
    [labeled_objects,num_of_objects]=bwlabel(real_ica_segments(:,:,i),4);
    if num_of_objects>1
        for j=1:num_of_objects
            real_ica_segments2(:,:,real_ica_count)=labeled_objects==j;
            real_ica_count=real_ica_count+1;
        end
    elseif num_of_objects==1
        real_ica_segments2(:,:,real_ica_count)=labeled_objects>0;
        real_ica_count=real_ica_count+1;
    end
end

set( handles.pushbuttongen, 'Enable', 'off');
drawnow;
set( handles.pushbuttongen, 'Enable', 'on');
assignin('base', 'real_ica_segments', real_ica_segments2);


% --- Executes on button press in pushbuttoncut.
function pushbuttoncut_Callback(hObject, ~, handles)
% hObject    handle to pushbuttoncut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cutpixels=getlinepixels(handles.filtertoshow,0);
currentfilter=squeeze(handles.ica_segments(handles.filterindex,:,:)>0);
currentfilter(cutpixels>0)=0;
handles.ica_segments(handles.filterindex,:,:)=currentfilter;
handles.filtertoshow(:,:,1)=120*(handles.ica_segments(handles.filterindex,:,:)>0);
imshow(handles.filtertoshow, 'Parent', handles.axes1)

set( handles.pushbuttoncut, 'Enable', 'off');
drawnow;
set( handles.pushbuttoncut, 'Enable', 'on');
guidata(hObject, handles)


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
    case 'd'
        pushbuttonpass_Callback(hObject, [], handles);
    case 'f'
        pushbuttonfail_Callback(hObject, [], handles);
    case 's'
        pushbuttoncut_Callback(hObject, [], handles);
    case 'c'
        pushbuttoncheck_Callback(hObject, [], handles);
    case 'e'
        if handles.checked==1
            pushbuttonoverlap_Callback(hObject, [], handles);
        end
    case 'g'
        if handles.checked==1
            pushbuttongen_Callback([], [], handles)
        end
    case 3
        pushbuttonclear_Callback(hObject, [], handles) % Ctrl+c
    case 5
        pushbuttonexit_Callback([], [], []) %Ctrl+e
end
