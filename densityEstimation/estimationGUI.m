function varargout = estimationGUI(varargin)
% ESTIMATIONGUI MATLAB code for estimationGUI.fig
%      ESTIMATIONGUI, by itself, creates a new ESTIMATIONGUI or raises the existing
%      singleton*.
%
%      H = ESTIMATIONGUI returns the handle to a new ESTIMATIONGUI or the handle to
%      the existing singleton*.
%
%      ESTIMATIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ESTIMATIONGUI.M with the given input arguments.
%
%      ESTIMATIONGUI('Property','Value',...) creates a new ESTIMATIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before estimationGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to estimationGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help estimationGUI

% Last Modified by GUIDE v2.5 19-Jun-2014 10:48:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @estimationGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @estimationGUI_OutputFcn, ...
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

% --- Executes just before estimationGUI is made visible.
function estimationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to estimationGUI (see VARARGIN)

% Choose default command line output for estimationGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using estimationGUI.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes estimationGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = estimationGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        plot(rand(5));
    case 2
        plot(sin(1:0.01:25.99));
    case 3
        bar(1:.5:10);
    case 4
        plot(membrane);
    case 5
        surf(peaks);
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.sliderValue,'String',num2str(10^(get(hObject,'Value'))));
updateButton_Callback(handles.updateButton, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in kernelTypeMenu.
function kernelTypeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to kernelTypeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns kernelTypeMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from kernelTypeMenu
if get(handles.kernelTypeMenu,'Value')>1
    set(handles.slider2,'Enable','on');
    set(handles.sliderValue2,'Enable','on');
else
    set(handles.slider2,'Enable','off');
    set(handles.sliderValue2,'Enable','off');
end

% --- Executes during object creation, after setting all properties.
function kernelTypeMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kernelTypeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updateButton.
function updateButton_Callback(hObject, eventdata, handles)
% hObject    handle to updateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Estimate pdf
sample=handles.sample;
[N,D]=size(sample);

%Get the kernel type & size
ktype=get(handles.kernelTypeMenu,'Value');
BWsize=10^get(handles.slider1,'Value');
k=round(get(handles.slider2,'Value'));
if k<=D
    k=D+1; %Condition for non-singularity of kernel.
    set(handles.sliderValue2,'String',num2str(k));
    set(handles.slider2,'Value',k);
end


if D>3
    set(hObject,'String','Dim cannot be >3')
else
for i=1:D
    minX=min(sample(:,i));
    maxX=max(sample(:,i));
    meanX=.5*(minX+maxX);
    rangeX=.5*(-minX+maxX);
    gridSize=min([2^ceil(log2(2*N)),64]);
    binsC{i}=linspace(meanX-1.1*rangeX,meanX+1.1*rangeX,gridSize);
end
switch ktype
    case 1
        method='conv';
    case 2
        method='varconv';
    case 3
        method='varshapeconv';
end
 p=ksdensityn(sample,binsC,method,BWsize,[],k);

 if get(handles.dim1Check,'Value')
     p=p./repmat(sum(sum(p,3),2),1,size(p,2),size(p,3));
 end
  if get(handles.dim2Check,'Value')
     p=p./repmat(sum(sum(p,3),1),size(p,1),1,size(p,3));
  end
  if get(handles.dim3Check,'Value')
     p=p./repmat(sum(sum(p,1),2),size(p,1),size(p,2),1);
  end
  p=p/sum(p(:));

%Plot
switch D
    case 1
        axes(handles.axes7)
        [h,c]=hist(sample,binsC{1}(1:4:end));
        bar(c,h/sum(h),1);
        hold on
        plot(binsC{1},p,'r','LineWidth',2);
        plot(sample,.05*max(p)*ones(N,1),'w.');
        hold off
        axis tight
    case 2
        
    case 3
        axes(handles.axes7)
        title('Marginal distribution for dimensions 2 and 3')
        p23=squeeze(sum(p,1));
        surf(binsC{3},binsC{2},p23,'EdgeColor','none');
        %caxis([0 median(diff(binsC{1}))/N])
        %contour(binsC{3},binsC{2},p23,max(p23(:))*logspace(-3,0,10))
        hold on
        plot3(sample(:,3),sample(:,2),1.1*max(max(squeeze(sum(p,1))))*ones(N,1),'xw','LineWidth',2);
        hold off
        view(2)
        axis tight
        axes(handles.axes8)
        title('Marginal distribution for dimensions 2 and 1')
        p12=squeeze(sum(p,3))';
        surf(binsC{1},binsC{2},p12,'EdgeColor','none');
        hold on
        plot3(sample(:,1),sample(:,2),1.1*max(max(sum(p,3)))*ones(N,1),'wx','LineWidth',2);
        hold off
        view(2)
        axis tight
        axes(handles.axes2)
        title('Marginal distribution for dimensions 1 and 3')
        p13=permute(sum(p,2),[1,3,2]);
        surf(binsC{3},binsC{1},p13,'EdgeColor','none');
        hold on
        plot3(sample(:,3),sample(:,1),1.1*max(max(sum(p,2),[],3))*ones(N,1),'wx','LineWidth',2);
        hold off
        view(2)
        axis tight
        
        axes(handles.axes9)
        [h,c]=hist(sample(:,3),binsC{3}(1:4:end));
        bar(c,h/(4*sum(h)),1);
        hold on
        aux=squeeze(sum(sum(p,2),1));
        p3=aux/sum(aux);
        H3=-p3(:)'*log(p3(:)+eps);
        plot(binsC{3},p3,'r','LineWidth',2);
        plot(sample(:,3),.05*max(p(:))*ones(N,1),'w.');
        text(binsC{3}(end/2),2.5*mean(p3),['H3=' num2str(H3)])
        hold off
        axis tight
        axes(handles.axes10)
        [h,c]=hist(sample(:,1),binsC{1}(1:4:end));
        bar(c,h/(4*sum(h)),1);
        hold on
        aux=squeeze(sum(sum(p,3),2));
        p1=aux/sum(aux);
        H1=-p1(:)'*log(p1(:)+eps);
        plot(binsC{1},p1,'r','LineWidth',2);
        plot(sample(:,1),.05*max(p(:))*ones(N,1),'w.');
        text(binsC{1}(end/2),2.5*mean(p1),['H1=' num2str(H1)])
        hold off
        axis tight
        axes(handles.axes11)
        [h,c]=hist(sample(:,2),binsC{2}(1:4:end));
        bar(c,h/(4*sum(h)),1);
        hold on
        aux=squeeze(sum(sum(p,3),1));
        p2=aux/sum(aux);
        H2=-p2(:)'*log(p2(:)+eps);
        plot(binsC{2},p2,'r','LineWidth',2);
        plot(sample(:,2),.05*max(p(:))*ones(N,1),'w.');
        text(binsC{2}(end-2),4*mean(p2),['H2=' num2str(H2)])
        hold off
        axis tight
        view(-90,90)
end
end
%Update entropy and likelihood estimations
H=-p(:)'*log(p(:)+eps);
H12=-p12(:)'*log(p12(:)+eps);
H13=-p13(:)'*log(p13(:)+eps);
H23=-p23(:)'*log(p23(:)+eps);
L=1;
for i=1:N
   [~,i1]=min(abs(sample(i,1)-binsC{1})); 
   [~,i2]=min(abs(sample(i,2)-binsC{2})); 
   [~,i3]=min(abs(sample(i,3)-binsC{3})); 
   L=L*p(i1,i2,i3);
end
set(handles.entropyText,'String',['H=' num2str(H)]);
set(handles.h12,'String',['H12=' num2str(H12)]);
set(handles.h13,'String',['H13=' num2str(H13)]);
set(handles.h23,'String',['H23=' num2str(H23)]);
set(handles.i12,'String',['I12=' num2str(H1+H2-H12)]);
set(handles.i13,'String',['I13=' num2str(H1+H3-H13)]);
set(handles.i23,'String',['I23=' num2str(H2+H3-H23)]);
set(handles.likeText,'String',['L=' num2str(log(L)/N)]);



function sampleName_Callback(hObject, eventdata, handles)
% hObject    handle to sampleName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampleName as text
%        str2double(get(hObject,'String')) returns contents of sampleName as a double
try
    load(get(hObject,'String'));
    handles.sample=data;
    [N,D]=size(data);
    set(handles.updateButton,'Enable','on');
    set(handles.dim1Check,'Enable','on');
    if D>1
        set(handles.dim2Check,'Enable','on');
    else
        set(handles.dim2Check,'Enable','off');
    end
    if D>2
        set(handles.dim3Check,'Enable','on');
    else
        set(handles.dim3Check,'Enable','off');
    end
    guidata(hObject, handles);
catch
    set(hObject,'String','Try again:');
end



% --- Executes during object creation, after setting all properties.
function sampleName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampleName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sliderValue_Callback(hObject, eventdata, handles)
% hObject    handle to sliderValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sliderValue as text
%        str2double(get(hObject,'String')) returns contents of sliderValue as a double
try
    aux=str2num(get(hObject,'String'));
    set(handles.slider1,'Value',log10(aux));
    slider1_Callback(handles.slider1, eventdata, handles);
catch
    set(hObject,'String','1');
end



% --- Executes during object creation, after setting all properties.
function sliderValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dim1Check.
function dim1Check_Callback(hObject, eventdata, handles)
% hObject    handle to dim1Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dim1Check


% --- Executes on button press in dim2Check.
function dim2Check_Callback(hObject, eventdata, handles)
% hObject    handle to dim2Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dim2Check


% --- Executes on button press in dim3Check.
function dim3Check_Callback(hObject, eventdata, handles)
% hObject    handle to dim3Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dim3Check


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.sliderValue2,'String',num2str(round(get(hObject,'Value'))));
updateButton_Callback(handles.updateButton, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function sliderValue2_Callback(hObject, eventdata, handles)
% hObject    handle to sliderValue2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sliderValue2 as text
%        str2double(get(hObject,'String')) returns contents of sliderValue2 as a double
try
    aux=round(str2num(get(hObject,'String')));
    set(handles.slider2,'Value',aux);
    slider2_Callback(handles.slider2, eventdata, handles);
catch
    set(hObject,'String','1');
end


% --- Executes during object creation, after setting all properties.
function sliderValue2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderValue2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
