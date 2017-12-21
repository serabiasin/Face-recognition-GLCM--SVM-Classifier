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

% Last Modified by GUIDE v2.5 21-Dec-2017 09:40:29

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
function Crop_Callback(~, ~, handles)
% hObject    handle to Crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set global variable (friend function)
global get_file;
% sebelum di crop
pre_crop=get_file;

global croped;
croped=imcrop(pre_crop);

% reserved
 axes(handles.croped)
 imshow(croped);



% --- Executes on button press in Identify.
function Identify_Callback(hObject, eventdata, handles)
% hObject    handle to Identify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% prototype dynamic text
% set(handles.Nama,'String',sprintf('Kampret'));
