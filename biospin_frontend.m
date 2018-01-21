function varargout = biospin_frontend(varargin)
% BIOSPIN_FRONTEND MATLAB code for biospin_frontend.fig
%      BIOSPIN_FRONTEND, by itself, creates a new BIOSPIN_FRONTEND or raises the existing
%      singleton*.
%
%      H = BIOSPIN_FRONTEND returns the handle to a new BIOSPIN_FRONTEND or the handle to
%      the existing singleton*.
%
%      BIOSPIN_FRONTEND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIOSPIN_FRONTEND.M with the given input arguments.
%
%      BIOSPIN_FRONTEND('Property','Value',...) creates a new BIOSPIN_FRONTEND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before biospin_frontend_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to biospin_frontend_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help biospin_frontend

% Last Modified by GUIDE v2.5 18-Jan-2018 06:21:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @biospin_frontend_OpeningFcn, ...
                   'gui_OutputFcn',  @biospin_frontend_OutputFcn, ...
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


% --- Executes just before biospin_frontend is made visible.
function biospin_frontend_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to biospin_frontend (see VARARGIN)

% Choose default command line output for biospin_frontend
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes biospin_frontend wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = biospin_frontend_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Browse_picture.
function Browse_picture_Callback(~, ~, handles)
% hObject    handle to Browse_picture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Filename,Pathname]=uigetfile({'*.jpg';'*.png'},sprintf('Pilih sampel untuk scan'));
% avoid error
if Filename==0 
    return
end
global get_file;
get_file=fullfile(Pathname,Filename);
axes(handles.foto_mentah);
% convert to gray
get_file=imresize(imread(get_file), [256 256]);
get_file=rgb2gray(get_file);
imshow(get_file);


% --- Executes on button press in Crop.
function Crop_Callback(hObject, eventdata, handles)
% hObject    handle to Crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set global variable (friend function)
global get_file;
% sebelum di crop
pre_crop=get_file;

global croped_var;
croped_var=imcrop(pre_crop);
% reserved
 imshow(croped_var,'parent',handles.croped);


% --- Executes on button press in Identify.
function Identify_Callback(hObject, eventdata, handles)
% hObject    handle to Identify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% prototype dynamic text

% checking if object is null or not
global croped_var;
testing=isempty(croped_var);
if (~testing)
% put algorithm to identified picture
croped_var=imresize(croped_var,[64 64]);
croped_var=imsharpen(croped_var,'Radius',1,'Amount',0.5);
%(Wacana)tambahkan offset agar ke akuratan per pixel bertambah
glcm=graycomatrix(croped_var);

stats=graycoprops(glcm,'all');
data_glcm=struct2array(stats);

rata2=mean2(croped_var);
std_deviation=std2(croped_var);
glcm_entropy=entropy(croped_var);
rata2_variance= mean2(var(double(croped_var)));
glcm_kurtosis=kurtosis(double(croped_var(:)));
glcm_skewness=skewness(double(croped_var(:)));
glcm_contrast=data_glcm(1);
glcm_correlation=data_glcm(2);
glcm_energy=data_glcm(3);
glcm_homogen=data_glcm(4);

imshow(croped_var,'parent',handles.after_process);
set(handles.contrast_text,'String',data_glcm(1));
set(handles.correlation_text,'String',data_glcm(2));
set(handles.energy_text,'String',data_glcm(3));
set(handles.homogen_text,'String',data_glcm(4));

buat_train=[glcm_contrast,glcm_correlation,glcm_energy,glcm_homogen,rata2,std_deviation,glcm_entropy,rata2_variance,glcm_kurtosis,glcm_skewness];
test_data=buat_train;

% mengambil data ekstraksi ciri
load data_ekstraksi.mat

%% WARNING THIS CODE IS NOT WORKING YET!

%  paramater :multisvm( T,C,test ) 
%  T=Training Matrix, C=Group, test=Testing matrix
 hasil=multisvm(data_glcm,data_label,test_data);
 
 switch hasil
     case 1 
        set(handles.Nama,'String',sprintf('Ahmad Alfi'));
     case 2
         set(handles.Nama,'String',sprintf('Dandi'));
     case 3
         set(handles.Nama,'String',sprintf('Farid'));
     case 4
         set(handles.Nama,'String',sprintf('Ika'));
     case 5
         set(handles.Nama,'String',sprintf('Rakha'));
         
 end

%%STOP HERE
elseif(testing)
    uiwait(msgbox('Silahkan Lakukan Proses Crop Terlebih Dahulu!', 'Error','error'));    
    return ;

end




% set(handles.Nama,'String',sprintf('Kampret'));


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% clear all memory 
clearvars -global
cla(handles.after_process);
cla(handles.croped);
cla(handles.foto_mentah);

set(handles.contrast_text,'String',0);
set(handles.correlation_text,'String',0);
set(handles.energy_text,'String',0);
set(handles.homogen_text,'String',0);
set(handles.Nama,'String',sprintf(''));



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to contrast_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of contrast_text as text
%        str2double(get(hObject,'String')) returns contents of contrast_text as a double


% --- Executes during object creation, after setting all properties.
function contrast_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contrast_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to correlation_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of correlation_text as text
%        str2double(get(hObject,'String')) returns contents of correlation_text as a double


% --- Executes during object creation, after setting all properties.
function correlation_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to correlation_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to energy_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of energy_text as text
%        str2double(get(hObject,'String')) returns contents of energy_text as a double


% --- Executes during object creation, after setting all properties.
function energy_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to energy_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to homogen_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of homogen_text as text
%        str2double(get(hObject,'String')) returns contents of homogen_text as a double


% --- Executes during object creation, after setting all properties.
function homogen_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to homogen_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in r_noise.
function r_noise_Callback(hObject, eventdata, handles)
% hObject    handle to r_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global get_file;
get_file=medfilt2(get_file);
get_file=imsharpen(get_file,'Radius',1,'Amount',0.5);
imshow(get_file);


% --- Executes on button press in contrast_o.
function contrast_o_Callback(hObject, eventdata, handles)
% hObject    handle to contrast_o (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global get_file;
get_file=imadjust(get_file,stretchlim(get_file));
imshow(get_file);
