function varargout = TraceSelect(varargin)
% TRACESELECT MATLAB code for TraceSelect.fig
%      TRACESELECT, by itself, creates a new TRACESELECT or raises the existing
%      singleton*.
%
%      H = TRACESELECT returns the handle to a new TRACESELECT or the handle to
%      the existing singleton*.
%
%      TRACESELECT('CALLBACK',hObject,~,handles,...) calls the local
%      function named CALLBACK in TRACESELECT.M with the given input arguments.
%
%      TRACESELECT('Property','Value',...) creates a new TRACESELECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TraceSelect_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TraceSelect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TraceSelect

% Coded by Stephen Zhang
% Last Modified by GUIDE v2.5 07-Feb-2014 18:11:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TraceSelect_OpeningFcn, ...
                   'gui_OutputFcn',  @TraceSelect_OutputFcn, ...
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


% --- Outputs from this function are returned to the command line.
function varargout = TraceSelect_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes just before TraceSelect is made visible.
function TraceSelect_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TraceSelect (see VARARGIN)

% Choose default command line output for TraceSelect
handles.output = hObject;
YesNo = evalin('base','exist(''real_ica_segments'',''var'')');
if YesNo==1
    handles.real_ica_segments=evalin('base','real_ica_segments');
    handles.cell_sig=evalin('base','cell_sig');
    handles.fn=evalin('base','fn');
else
    msgbox('Please make sure CellSort data are loaded to workspace','Need data to initiate');
end

handles.totalcount=size(handles.cell_sig,1);
handles.currentmax=0;
handles.imsize=size(squeeze(handles.real_ica_segments(:,:,1)));
handles.imlength=size(handles.cell_sig,2);
handles.imblack=zeros(handles.imsize);
handles.imnotrace=zeros(handles.imlength,1);
handles.pages=ceil(handles.totalcount/12);
handles.currentpage=1;
set(handles.text3,'String',[num2str(handles.currentpage),'/',num2str(handles.pages)])

YesNo = evalin('base','exist(''traces_select_or_not'',''var'')');
if YesNo==1
    handles.select_or_not=evalin('base','traces_select_or_not');
else
    handles.select_or_not=ones(handles.totalcount,1);
end


% box 1
if  handles.totalcount>=1+handles.currentmax
    set(handles.uipanel1,'Title',['Cell ', num2str(1+handles.currentmax)]);
    imshow(255*squeeze(handles.real_ica_segments(:,:,1+handles.currentmax)),'Parent',handles.axes1)
    plot(handles.axes2,handles.cell_sig(1+handles.currentmax,:));
    set(handles.axes2,'ytick',[]);
    set(handles.axes2,'xtick',[]);
    set(handles.checkbox1,'Value',handles.select_or_not(1+handles.currentmax));
else
    set(handles.uipanel1,'Title',['Blank']);
    imshow(255*handles.imblack,'Parent',handles.axes1)
    plot(handles.axes2,handles.imnotrace);
    set(handles.axes2,'ytick',[]);
    set(handles.axes2,'xtick',[]);
    set(handles.checkbox1,'Value',0);
end

% box 2
if  handles.totalcount>=2+handles.currentmax
    set(handles.uipanel2,'Title',['Cell ', num2str(2+handles.currentmax)]);
    imshow(255*squeeze(handles.real_ica_segments(:,:,2+handles.currentmax)),'Parent',handles.axes3)
    plot(handles.axes4,handles.cell_sig(2+handles.currentmax,:));
    set(handles.axes4,'ytick',[]);
    set(handles.axes4,'xtick',[]);
    set(handles.checkbox2,'Value',handles.select_or_not(2+handles.currentmax));
else
    set(handles.uipanel2,'Title',['Blank']);
    imshow(255*handles.imblack,'Parent',handles.axes3)
    plot(handles.axes4,handles.imnotrace);
    set(handles.axes4,'ytick',[]);
    set(handles.axes4,'xtick',[]);
    set(handles.checkbox2,'Value',0);
end

% box 3
if  handles.totalcount>=3+handles.currentmax
    set(handles.uipanel3,'Title',['Cell ', num2str(3+handles.currentmax)]);
    imshow(255*squeeze(handles.real_ica_segments(:,:,3+handles.currentmax)),'Parent',handles.axes5)
    plot(handles.axes6,handles.cell_sig(3+handles.currentmax,:));
    set(handles.axes6,'ytick',[]);
    set(handles.axes6,'xtick',[]);
    set(handles.checkbox3,'Value',handles.select_or_not(3+handles.currentmax));
else
    set(handles.uipanel3,'Title',['Blank']);
    imshow(255*handles.imblack,'Parent',handles.axes5)
    plot(handles.axes6,handles.imnotrace);
    set(handles.axes6,'ytick',[]);
    set(handles.axes6,'xtick',[]);
    set(handles.checkbox3,'Value',0);
end

% box 4
if  handles.totalcount>=4+handles.currentmax
    set(handles.uipanel4,'Title',['Cell ', num2str(4+handles.currentmax)]);
    imshow(255*squeeze(handles.real_ica_segments(:,:,4+handles.currentmax)),'Parent',handles.axes7)
    plot(handles.axes8,handles.cell_sig(4+handles.currentmax,:));
    set(handles.axes8,'ytick',[]);
    set(handles.axes8,'xtick',[]);
    set(handles.checkbox4,'Value',handles.select_or_not(4+handles.currentmax));
else
    set(handles.uipanel4,'Title',['Blank']);
    imshow(255*handles.imblack,'Parent',handles.axes7)
    plot(handles.axes8,handles.imnotrace);
    set(handles.axes8,'ytick',[]);
    set(handles.axes8,'xtick',[]);
    set(handles.checkbox4,'Value',0);
end

% box 5
if  handles.totalcount>=5+handles.currentmax
    set(handles.uipanel5,'Title',['Cell ', num2str(5+handles.currentmax)]);
    imshow(255*squeeze(handles.real_ica_segments(:,:,5+handles.currentmax)),'Parent',handles.axes9)
    plot(handles.axes10,handles.cell_sig(5+handles.currentmax,:));
    set(handles.axes10,'ytick',[]);
    set(handles.axes10,'xtick',[]);
    set(handles.checkbox5,'Value',handles.select_or_not(5+handles.currentmax));
else
    set(handles.uipanel5,'Title',['Blank']);
    imshow(255*handles.imblack,'Parent',handles.axes9)
    plot(handles.axes10,handles.imnotrace);
    set(handles.axes10,'ytick',[]);
    set(handles.axes10,'xtick',[]);
    set(handles.checkbox5,'Value',0);
end

% box 6
if  handles.totalcount>=6+handles.currentmax
    set(handles.uipanel6,'Title',['Cell ', num2str(6+handles.currentmax)]);
    imshow(255*squeeze(handles.real_ica_segments(:,:,6+handles.currentmax)),'Parent',handles.axes11)
    plot(handles.axes12,handles.cell_sig(6+handles.currentmax,:));
    set(handles.axes12,'ytick',[]);
    set(handles.axes12,'xtick',[]);
    set(handles.checkbox6,'Value',handles.select_or_not(6+handles.currentmax));
else
    set(handles.uipanel6,'Title',['Blank']);
    imshow(255*handles.imblack,'Parent',handles.axes11)
    plot(handles.axes12,handles.imnotrace);
    set(handles.axes12,'ytick',[]);
    set(handles.axes12,'xtick',[]);
    set(handles.checkbox6,'Value',0);
end

% box 7
if  handles.totalcount>=7+handles.currentmax
    set(handles.uipanel7,'Title',['Cell ', num2str(7+handles.currentmax)]);
    imshow(255*squeeze(handles.real_ica_segments(:,:,7+handles.currentmax)),'Parent',handles.axes13)
    plot(handles.axes14,handles.cell_sig(7+handles.currentmax,:));
    set(handles.axes14,'ytick',[]);
    set(handles.axes14,'xtick',[]);
    set(handles.checkbox7,'Value',handles.select_or_not(7+handles.currentmax));
else
    set(handles.uipanel7,'Title',['Blank']);
    imshow(255*handles.imblack,'Parent',handles.axes13)
    plot(handles.axes14,handles.imnotrace);
    set(handles.axes14,'ytick',[]);
    set(handles.axes14,'xtick',[]);
    set(handles.checkbox7,'Value',0);
end

% box 8
if  handles.totalcount>=8+handles.currentmax
    set(handles.uipanel8,'Title',['Cell ', num2str(8+handles.currentmax)]);
    imshow(255*squeeze(handles.real_ica_segments(:,:,8+handles.currentmax)),'Parent',handles.axes15)
    plot(handles.axes16,handles.cell_sig(8+handles.currentmax,:));
    set(handles.axes16,'ytick',[]);
    set(handles.axes16,'xtick',[]);
    set(handles.checkbox8,'Value',handles.select_or_not(8+handles.currentmax));
else
    set(handles.uipanel8,'Title',['Blank']);
    imshow(255*handles.imblack,'Parent',handles.axes15)
    plot(handles.axes16,handles.imnotrace);
    set(handles.axes16,'ytick',[]);
    set(handles.axes16,'xtick',[]);
    set(handles.checkbox8,'Value',0);
end

% box 9
if  handles.totalcount>=9+handles.currentmax
    set(handles.uipanel9,'Title',['Cell ', num2str(9+handles.currentmax)]);
    imshow(255*squeeze(handles.real_ica_segments(:,:,9+handles.currentmax)),'Parent',handles.axes17)
    plot(handles.axes18,handles.cell_sig(9+handles.currentmax,:));
    set(handles.axes18,'ytick',[]);
    set(handles.axes18,'xtick',[]);
    set(handles.checkbox9,'Value',handles.select_or_not(9+handles.currentmax));
else
    set(handles.uipanel9,'Title',['Blank']);
    imshow(255*handles.imblack,'Parent',handles.axes17)
    plot(handles.axes18,handles.imnotrace);
    set(handles.axes18,'ytick',[]);
    set(handles.axes18,'xtick',[]);
    set(handles.checkbox9,'Value',0);
end

% box 10
if  handles.totalcount>=10+handles.currentmax
    set(handles.uipanel10,'Title',['Cell ', num2str(10+handles.currentmax)]);
    imshow(255*squeeze(handles.real_ica_segments(:,:,10+handles.currentmax)),'Parent',handles.axes19)
    plot(handles.axes20,handles.cell_sig(10+handles.currentmax,:));
    set(handles.axes20,'ytick',[]);
    set(handles.axes20,'xtick',[]);
    set(handles.checkbox10,'Value',handles.select_or_not(10+handles.currentmax));
else
    set(handles.uipanel10,'Title',['Blank']);
    imshow(255*handles.imblack,'Parent',handles.axes19)
    plot(handles.axes20,handles.imnotrace);
    set(handles.axes20,'ytick',[]);
    set(handles.axes20,'xtick',[]);
    set(handles.checkbox10,'Value',0);
end

% box 11
if  handles.totalcount>=11+handles.currentmax
    set(handles.uipanel11,'Title',['Cell ', num2str(11+handles.currentmax)]);
    imshow(255*squeeze(handles.real_ica_segments(:,:,11+handles.currentmax)),'Parent',handles.axes21)
    plot(handles.axes22,handles.cell_sig(11+handles.currentmax,:));
    set(handles.axes22,'ytick',[]);
    set(handles.axes22,'xtick',[]);
    set(handles.checkbox11,'Value',handles.select_or_not(11+handles.currentmax));
else
    set(handles.uipanel11,'Title',['Blank']);
    imshow(255*handles.imblack,'Parent',handles.axes21)
    plot(handles.axes22,handles.imnotrace);
    set(handles.axes22,'ytick',[]);
    set(handles.axes22,'xtick',[]);
    set(handles.checkbox11,'Value',0);
end

% box 12
if  handles.totalcount>=12+handles.currentmax
    set(handles.uipanel12,'Title',['Cell ', num2str(12+handles.currentmax)]);
    imshow(255*squeeze(handles.real_ica_segments(:,:,12+handles.currentmax)),'Parent',handles.axes23)
    plot(handles.axes24,handles.cell_sig(12+handles.currentmax,:));
    set(handles.axes24,'ytick',[]);
    set(handles.axes24,'xtick',[]);
    set(handles.checkbox12,'Value',handles.select_or_not(12+handles.currentmax));
else
    set(handles.uipanel12,'Title',['Blank']);
    imshow(255*handles.imblack,'Parent',handles.axes23)
    plot(handles.axes24,handles.imnotrace);
    set(handles.axes24,'ytick',[]);
    set(handles.axes24,'xtick',[]);
    set(handles.checkbox12,'Value',0);
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, ~, handles)
% hObject    handle to checkbox1 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
select_or_not=get(handles.checkbox1,'Value');
handles.select_or_not(1+handles.currentmax)=select_or_not;
assignin('base', 'traces_select_or_not', handles.select_or_not);
guidata(hObject, handles);

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, ~, handles)
% hObject    handle to checkbox2 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
select_or_not=get(handles.checkbox2,'Value');
handles.select_or_not(2+handles.currentmax)=select_or_not;
assignin('base', 'traces_select_or_not', handles.select_or_not);
guidata(hObject, handles);

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, ~, handles)
% hObject    handle to checkbox3 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
select_or_not=get(handles.checkbox3,'Value');
handles.select_or_not(3+handles.currentmax)=select_or_not;
assignin('base', 'traces_select_or_not', handles.select_or_not);
guidata(hObject, handles);

% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, ~, handles)
% hObject    handle to checkbox4 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
select_or_not=get(handles.checkbox4,'Value');
handles.select_or_not(4+handles.currentmax)=select_or_not;
assignin('base', 'traces_select_or_not', handles.select_or_not);
guidata(hObject, handles);

% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, ~, handles)
% hObject    handle to checkbox5 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
select_or_not=get(handles.checkbox5,'Value');
handles.select_or_not(5+handles.currentmax)=select_or_not;
assignin('base', 'traces_select_or_not', handles.select_or_not);
guidata(hObject, handles);

% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, ~, handles)
% hObject    handle to checkbox6 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
select_or_not=get(handles.checkbox6,'Value');
handles.select_or_not(6+handles.currentmax)=select_or_not;
assignin('base', 'traces_select_or_not', handles.select_or_not);
guidata(hObject, handles);

% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, ~, handles)
% hObject    handle to checkbox7 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
select_or_not=get(handles.checkbox7,'Value');
handles.select_or_not(7+handles.currentmax)=select_or_not;
assignin('base', 'traces_select_or_not', handles.select_or_not);
guidata(hObject, handles);

% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, ~, handles)
% hObject    handle to checkbox8 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
select_or_not=get(handles.checkbox8,'Value');
handles.select_or_not(8+handles.currentmax)=select_or_not;
assignin('base', 'traces_select_or_not', handles.select_or_not);
guidata(hObject, handles);

% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, ~, handles)
% hObject    handle to checkbox9 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
select_or_not=get(handles.checkbox9,'Value');
handles.select_or_not(9+handles.currentmax)=select_or_not;
assignin('base', 'traces_select_or_not', handles.select_or_not);
guidata(hObject, handles);

% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, ~, handles)
% hObject    handle to checkbox10 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
select_or_not=get(handles.checkbox10,'Value');
handles.select_or_not(10+handles.currentmax)=select_or_not;
assignin('base', 'traces_select_or_not', handles.select_or_not);
guidata(hObject, handles);

% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, ~, handles)
% hObject    handle to checkbox11 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
select_or_not=get(handles.checkbox11,'Value');
handles.select_or_not(11+handles.currentmax)=select_or_not;
assignin('base', 'traces_select_or_not', handles.select_or_not);
guidata(hObject, handles);

% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, ~, handles)
% hObject    handle to checkbox12 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
select_or_not=get(handles.checkbox12,'Value');
handles.select_or_not(12+handles.currentmax)=select_or_not;
assignin('base', 'traces_select_or_not', handles.select_or_not);
guidata(hObject, handles);

% --- Executes on button press in pushbutton_next.
function pushbutton_next_Callback(hObject, ~, handles)
% hObject    handle to pushbutton_next (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.currentpage<handles.pages
    handles.currentpage=handles.currentpage+1;
    handles.currentmax=handles.currentmax+12;
    set(handles.text3,'String',[num2str(handles.currentpage),'/',num2str(handles.pages)])

    
    % box 1
    if  handles.totalcount>=1+handles.currentmax
        set(handles.uipanel1,'Title',['Cell ', num2str(1+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,1+handles.currentmax)),'Parent',handles.axes1)
        plot(handles.axes2,handles.cell_sig(1+handles.currentmax,:));
        set(handles.axes2,'ytick',[]);
        set(handles.axes2,'xtick',[]);
        set(handles.checkbox1,'Value',handles.select_or_not(1+handles.currentmax));
    else
        set(handles.uipanel1,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes1)
        plot(handles.axes2,handles.imnotrace);
        set(handles.axes2,'ytick',[]);
        set(handles.axes2,'xtick',[]);
        set(handles.checkbox1,'Value',0);
    end

    % box 2
    if  handles.totalcount>=2+handles.currentmax
        set(handles.uipanel2,'Title',['Cell ', num2str(2+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,2+handles.currentmax)),'Parent',handles.axes3)
        plot(handles.axes4,handles.cell_sig(2+handles.currentmax,:));
        set(handles.axes4,'ytick',[]);
        set(handles.axes4,'xtick',[]);
        set(handles.checkbox2,'Value',handles.select_or_not(2+handles.currentmax));
    else
        set(handles.uipanel2,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes3)
        plot(handles.axes4,handles.imnotrace);
        set(handles.axes4,'ytick',[]);
        set(handles.axes4,'xtick',[]);
        set(handles.checkbox2,'Value',0);
    end

    % box 3
    if  handles.totalcount>=3+handles.currentmax
        set(handles.uipanel3,'Title',['Cell ', num2str(3+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,3+handles.currentmax)),'Parent',handles.axes5)
        plot(handles.axes6,handles.cell_sig(3+handles.currentmax,:));
        set(handles.axes6,'ytick',[]);
        set(handles.axes6,'xtick',[]);
        set(handles.checkbox3,'Value',handles.select_or_not(3+handles.currentmax));
    else
        set(handles.uipanel3,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes5)
        plot(handles.axes6,handles.imnotrace);
        set(handles.axes6,'ytick',[]);
        set(handles.axes6,'xtick',[]);
        set(handles.checkbox3,'Value',0);
    end

    % box 4
    if  handles.totalcount>=4+handles.currentmax
        set(handles.uipanel4,'Title',['Cell ', num2str(4+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,4+handles.currentmax)),'Parent',handles.axes7)
        plot(handles.axes8,handles.cell_sig(4+handles.currentmax,:));
        set(handles.axes8,'ytick',[]);
        set(handles.axes8,'xtick',[]);
        set(handles.checkbox4,'Value',handles.select_or_not(4+handles.currentmax));
    else
        set(handles.uipanel4,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes7)
        plot(handles.axes8,handles.imnotrace);
        set(handles.axes8,'ytick',[]);
        set(handles.axes8,'xtick',[]);
        set(handles.checkbox4,'Value',0);
    end

    % box 5
    if  handles.totalcount>=5+handles.currentmax
        set(handles.uipanel5,'Title',['Cell ', num2str(5+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,5+handles.currentmax)),'Parent',handles.axes9)
        plot(handles.axes10,handles.cell_sig(5+handles.currentmax,:));
        set(handles.axes10,'ytick',[]);
        set(handles.axes10,'xtick',[]);
        set(handles.checkbox5,'Value',handles.select_or_not(5+handles.currentmax));
    else
        set(handles.uipanel5,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes9)
        plot(handles.axes10,handles.imnotrace);
        set(handles.axes10,'ytick',[]);
        set(handles.axes10,'xtick',[]);
        set(handles.checkbox5,'Value',0);
    end

    % box 6
    if  handles.totalcount>=6+handles.currentmax
        set(handles.uipanel6,'Title',['Cell ', num2str(6+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,6+handles.currentmax)),'Parent',handles.axes11)
        plot(handles.axes12,handles.cell_sig(6+handles.currentmax,:));
        set(handles.axes12,'ytick',[]);
        set(handles.axes12,'xtick',[]);
        set(handles.checkbox6,'Value',handles.select_or_not(6+handles.currentmax));
    else
        set(handles.uipanel6,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes11)
        plot(handles.axes12,handles.imnotrace);
        set(handles.axes12,'ytick',[]);
        set(handles.axes12,'xtick',[]);
        set(handles.checkbox6,'Value',0);
    end

    % box 7
    if  handles.totalcount>=7+handles.currentmax
        set(handles.uipanel7,'Title',['Cell ', num2str(7+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,7+handles.currentmax)),'Parent',handles.axes13)
        plot(handles.axes14,handles.cell_sig(7+handles.currentmax,:));
        set(handles.axes14,'ytick',[]);
        set(handles.axes14,'xtick',[]);
        set(handles.checkbox7,'Value',handles.select_or_not(7+handles.currentmax));
    else
        set(handles.uipanel7,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes13)
        plot(handles.axes14,handles.imnotrace);
        set(handles.axes14,'ytick',[]);
        set(handles.axes14,'xtick',[]);
        set(handles.checkbox7,'Value',0);
    end

    % box 8
    if  handles.totalcount>=8+handles.currentmax
        set(handles.uipanel8,'Title',['Cell ', num2str(8+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,8+handles.currentmax)),'Parent',handles.axes15)
        plot(handles.axes16,handles.cell_sig(8+handles.currentmax,:));
        set(handles.axes16,'ytick',[]);
        set(handles.axes16,'xtick',[]);
        set(handles.checkbox8,'Value',handles.select_or_not(8+handles.currentmax));
    else
        set(handles.uipanel8,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes15)
        plot(handles.axes16,handles.imnotrace);
        set(handles.axes16,'ytick',[]);
        set(handles.axes16,'xtick',[]);
        set(handles.checkbox8,'Value',0);
    end

    % box 9
    if  handles.totalcount>=9+handles.currentmax
        set(handles.uipanel9,'Title',['Cell ', num2str(9+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,9+handles.currentmax)),'Parent',handles.axes17)
        plot(handles.axes18,handles.cell_sig(9+handles.currentmax,:));
        set(handles.axes18,'ytick',[]);
        set(handles.axes18,'xtick',[]);
        set(handles.checkbox9,'Value',handles.select_or_not(9+handles.currentmax));
    else
        set(handles.uipanel9,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes17)
        plot(handles.axes18,handles.imnotrace);
        set(handles.axes18,'ytick',[]);
        set(handles.axes18,'xtick',[]);
        set(handles.checkbox9,'Value',0);
    end

    % box 10
    if  handles.totalcount>=10+handles.currentmax
        set(handles.uipanel10,'Title',['Cell ', num2str(10+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,10+handles.currentmax)),'Parent',handles.axes19)
        plot(handles.axes20,handles.cell_sig(10+handles.currentmax,:));
        set(handles.axes20,'ytick',[]);
        set(handles.axes20,'xtick',[]);
        set(handles.checkbox10,'Value',handles.select_or_not(10+handles.currentmax));
    else
        set(handles.uipanel10,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes19)
        plot(handles.axes20,handles.imnotrace);
        set(handles.axes20,'ytick',[]);
        set(handles.axes20,'xtick',[]);
        set(handles.checkbox10,'Value',0);
    end

    % box 11
    if  handles.totalcount>=11+handles.currentmax
        set(handles.uipanel11,'Title',['Cell ', num2str(11+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,11+handles.currentmax)),'Parent',handles.axes21)
        plot(handles.axes22,handles.cell_sig(11+handles.currentmax,:));
        set(handles.axes22,'ytick',[]);
        set(handles.axes22,'xtick',[]);
        set(handles.checkbox11,'Value',handles.select_or_not(11+handles.currentmax));
    else
        set(handles.uipanel11,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes21)
        plot(handles.axes22,handles.imnotrace);
        set(handles.axes22,'ytick',[]);
        set(handles.axes22,'xtick',[]);
        set(handles.checkbox11,'Value',0);
    end

    % box 12
    if  handles.totalcount>=12+handles.currentmax
        set(handles.uipanel12,'Title',['Cell ', num2str(12+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,12+handles.currentmax)),'Parent',handles.axes23)
        plot(handles.axes24,handles.cell_sig(12+handles.currentmax,:));
        set(handles.axes24,'ytick',[]);
        set(handles.axes24,'xtick',[]);
        set(handles.checkbox12,'Value',handles.select_or_not(12+handles.currentmax));
    else
        set(handles.uipanel12,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes23)
        plot(handles.axes24,handles.imnotrace);
        set(handles.axes24,'ytick',[]);
        set(handles.axes24,'xtick',[]);
        set(handles.checkbox12,'Value',0);
    end

end
guidata(hObject, handles);


% --- Executes on button press in pushbutton_Previous.
function pushbutton_Previous_Callback(hObject, ~, handles)
% hObject    handle to pushbutton_Previous (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.currentpage>1
    handles.currentpage=handles.currentpage-1;
    handles.currentmax=handles.currentmax-12;
    set(handles.text3,'String',[num2str(handles.currentpage),'/',num2str(handles.pages)])

    % box 1
    if  handles.totalcount>=1+handles.currentmax
        set(handles.uipanel1,'Title',['Cell ', num2str(1+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,1+handles.currentmax)),'Parent',handles.axes1)
        plot(handles.axes2,handles.cell_sig(1+handles.currentmax,:));
        set(handles.axes2,'ytick',[]);
        set(handles.axes2,'xtick',[]);
        set(handles.checkbox1,'Value',handles.select_or_not(1+handles.currentmax));
    else
        set(handles.uipanel1,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes1)
        plot(handles.axes2,handles.imnotrace);
        set(handles.axes2,'ytick',[]);
        set(handles.axes2,'xtick',[]);
        set(handles.checkbox1,'Value',0);
    end

    % box 2
    if  handles.totalcount>=2+handles.currentmax
        set(handles.uipanel2,'Title',['Cell ', num2str(2+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,2+handles.currentmax)),'Parent',handles.axes3)
        plot(handles.axes4,handles.cell_sig(2+handles.currentmax,:));
        set(handles.axes4,'ytick',[]);
        set(handles.axes4,'xtick',[]);
        set(handles.checkbox2,'Value',handles.select_or_not(2+handles.currentmax));
    else
        set(handles.uipanel2,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes3)
        plot(handles.axes4,handles.imnotrace);
        set(handles.axes4,'ytick',[]);
        set(handles.axes4,'xtick',[]);
        set(handles.checkbox2,'Value',0);
    end

    % box 3
    if  handles.totalcount>=3+handles.currentmax
        set(handles.uipanel3,'Title',['Cell ', num2str(3+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,3+handles.currentmax)),'Parent',handles.axes5)
        plot(handles.axes6,handles.cell_sig(3+handles.currentmax,:));
        set(handles.axes6,'ytick',[]);
        set(handles.axes6,'xtick',[]);
        set(handles.checkbox3,'Value',handles.select_or_not(3+handles.currentmax));
    else
        set(handles.uipanel3,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes5)
        plot(handles.axes6,handles.imnotrace);
        set(handles.axes6,'ytick',[]);
        set(handles.axes6,'xtick',[]);
        set(handles.checkbox3,'Value',0);
    end

    % box 4
    if  handles.totalcount>=4+handles.currentmax
        set(handles.uipanel4,'Title',['Cell ', num2str(4+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,4+handles.currentmax)),'Parent',handles.axes7)
        plot(handles.axes8,handles.cell_sig(4+handles.currentmax,:));
        set(handles.axes8,'ytick',[]);
        set(handles.axes8,'xtick',[]);
        set(handles.checkbox4,'Value',handles.select_or_not(4+handles.currentmax));
    else
        set(handles.uipanel4,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes7)
        plot(handles.axes8,handles.imnotrace);
        set(handles.axes8,'ytick',[]);
        set(handles.axes8,'xtick',[]);
        set(handles.checkbox4,'Value',0);
    end

    % box 5
    if  handles.totalcount>=5+handles.currentmax
        set(handles.uipanel5,'Title',['Cell ', num2str(5+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,5+handles.currentmax)),'Parent',handles.axes9)
        plot(handles.axes10,handles.cell_sig(5+handles.currentmax,:));
        set(handles.axes10,'ytick',[]);
        set(handles.axes10,'xtick',[]);
        set(handles.checkbox5,'Value',handles.select_or_not(5+handles.currentmax));
    else
        set(handles.uipanel5,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes9)
        plot(handles.axes10,handles.imnotrace);
        set(handles.axes10,'ytick',[]);
        set(handles.axes10,'xtick',[]);
        set(handles.checkbox5,'Value',0);
    end

    % box 6
    if  handles.totalcount>=6+handles.currentmax
        set(handles.uipanel6,'Title',['Cell ', num2str(6+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,6+handles.currentmax)),'Parent',handles.axes11)
        plot(handles.axes12,handles.cell_sig(6+handles.currentmax,:));
        set(handles.axes12,'ytick',[]);
        set(handles.axes12,'xtick',[]);
        set(handles.checkbox6,'Value',handles.select_or_not(6+handles.currentmax));
    else
        set(handles.uipanel6,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes11)
        plot(handles.axes12,handles.imnotrace);
        set(handles.axes12,'ytick',[]);
        set(handles.axes12,'xtick',[]);
        set(handles.checkbox6,'Value',0);
    end

    % box 7
    if  handles.totalcount>=7+handles.currentmax
        set(handles.uipanel7,'Title',['Cell ', num2str(7+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,7+handles.currentmax)),'Parent',handles.axes13)
        plot(handles.axes14,handles.cell_sig(7+handles.currentmax,:));
        set(handles.axes14,'ytick',[]);
        set(handles.axes14,'xtick',[]);
        set(handles.checkbox7,'Value',handles.select_or_not(7+handles.currentmax));
    else
        set(handles.uipanel7,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes13)
        plot(handles.axes14,handles.imnotrace);
        set(handles.axes14,'ytick',[]);
        set(handles.axes14,'xtick',[]);
        set(handles.checkbox7,'Value',0);
    end

    % box 8
    if  handles.totalcount>=8+handles.currentmax
        set(handles.uipanel8,'Title',['Cell ', num2str(8+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,8+handles.currentmax)),'Parent',handles.axes15)
        plot(handles.axes16,handles.cell_sig(8+handles.currentmax,:));
        set(handles.axes16,'ytick',[]);
        set(handles.axes16,'xtick',[]);
        set(handles.checkbox8,'Value',handles.select_or_not(8+handles.currentmax));
    else
        set(handles.uipanel8,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes15)
        plot(handles.axes16,handles.imnotrace);
        set(handles.axes16,'ytick',[]);
        set(handles.axes16,'xtick',[]);
        set(handles.checkbox8,'Value',0);
    end

    % box 9
    if  handles.totalcount>=9+handles.currentmax
        set(handles.uipanel9,'Title',['Cell ', num2str(9+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,9+handles.currentmax)),'Parent',handles.axes17)
        plot(handles.axes18,handles.cell_sig(9+handles.currentmax,:));
        set(handles.axes18,'ytick',[]);
        set(handles.axes18,'xtick',[]);
        set(handles.checkbox9,'Value',handles.select_or_not(9+handles.currentmax));
    else
        set(handles.uipanel9,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes17)
        plot(handles.axes18,handles.imnotrace);
        set(handles.axes18,'ytick',[]);
        set(handles.axes18,'xtick',[]);
        set(handles.checkbox9,'Value',0);
    end

    % box 10
    if  handles.totalcount>=10+handles.currentmax
        set(handles.uipanel10,'Title',['Cell ', num2str(10+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,10+handles.currentmax)),'Parent',handles.axes19)
        plot(handles.axes20,handles.cell_sig(10+handles.currentmax,:));
        set(handles.axes20,'ytick',[]);
        set(handles.axes20,'xtick',[]);
        set(handles.checkbox10,'Value',handles.select_or_not(10+handles.currentmax));
    else
        set(handles.uipanel10,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes19)
        plot(handles.axes20,handles.imnotrace);
        set(handles.axes20,'ytick',[]);
        set(handles.axes20,'xtick',[]);
        set(handles.checkbox10,'Value',0);
    end

    % box 11
    if  handles.totalcount>=11+handles.currentmax
        set(handles.uipanel11,'Title',['Cell ', num2str(11+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,11+handles.currentmax)),'Parent',handles.axes21)
        plot(handles.axes22,handles.cell_sig(11+handles.currentmax,:));
        set(handles.axes22,'ytick',[]);
        set(handles.axes22,'xtick',[]);
        set(handles.checkbox11,'Value',handles.select_or_not(11+handles.currentmax));
    else
        set(handles.uipanel11,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes21)
        plot(handles.axes22,handles.imnotrace);
        set(handles.axes22,'ytick',[]);
        set(handles.axes22,'xtick',[]);
        set(handles.checkbox11,'Value',0);
    end

    % box 12
    if  handles.totalcount>=12+handles.currentmax
        set(handles.uipanel12,'Title',['Cell ', num2str(12+handles.currentmax)]);
        imshow(255*squeeze(handles.real_ica_segments(:,:,12+handles.currentmax)),'Parent',handles.axes23)
        plot(handles.axes24,handles.cell_sig(12+handles.currentmax,:));
        set(handles.axes24,'ytick',[]);
        set(handles.axes24,'xtick',[]);
        set(handles.checkbox12,'Value',handles.select_or_not(12+handles.currentmax));
    else
        set(handles.uipanel12,'Title',['Blank']);
        imshow(255*handles.imblack,'Parent',handles.axes23)
        plot(handles.axes24,handles.imnotrace);
        set(handles.axes24,'ytick',[]);
        set(handles.axes24,'xtick',[]);
        set(handles.checkbox12,'Value',0);
    end

end
guidata(hObject, handles);


% --- Executes on button press in pushbutton_output.
function pushbutton_output_Callback(hObject, ~, handles)
% hObject    handle to pushbutton_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base', 'final_cell_segments', handles.real_ica_segments(:,:,logical(handles.select_or_not)));
assignin('base', 'final_cell_sig', handles.cell_sig(logical(handles.select_or_not),:));
assignin('base', 'traces_select_or_not', handles.select_or_not);
guidata(hObject, handles);


% --- Executes on button press in pushbutton_close.
function pushbutton_close_Callback(~, ~, ~)
% hObject    handle to pushbutton_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf)
