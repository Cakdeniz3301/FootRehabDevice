function varargout = RehabilitationToolbox(varargin)
% REHABILITATIONTOOLBOX MATLAB code for RehabilitationToolbox.fig
%      REHABILITATIONTOOLBOX, by itself, creates a new REHABILITATIONTOOLBOX or raises the existing
%      singleton*.
%
%      H = REHABILITATIONTOOLBOX returns the handle to a new REHABILITATIONTOOLBOX or the handle to
%      the existing singleton*.
%
%      REHABILITATIONTOOLBOX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REHABILITATIONTOOLBOX.M with the given input arguments.
%
%      REHABILITATIONTOOLBOX('Property','Value',...) creates a new REHABILITATIONTOOLBOX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RehabilitationToolbox_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RehabilitationToolbox_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RehabilitationToolbox

% Last Modified by GUIDE v2.5 05-Dec-2023 16:26:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RehabilitationToolbox_OpeningFcn, ...
                   'gui_OutputFcn',  @RehabilitationToolbox_OutputFcn, ...
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


% --- Executes just before RehabilitationToolbox is made visible.
function RehabilitationToolbox_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RehabilitationToolbox (see VARARGIN)

handles.output = hObject;
cla(handles.axes1,'reset');
cla(handles.axes2,'reset');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RehabilitationToolbox wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RehabilitationToolbox_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
cla(handles.axes1,'reset');
cla(handles.axes2,'reset');

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data; global fs; global PDFD_angle; global ivev_angle; global arka; global sag; 
global sol; global ontaraf; 

[RehabParameters,path] = uigetfile('*.*','.mat');
RehabFile=load('-mat',RehabParameters);

data=RehabFile.data; 
fs=15;
PDFD_angle=data(:,2);
ivev_angle=data(:,3);
arka=data(:,4);
sag=data(:,5);
sol=data(:,6);
ontaraf=data(:,7);
f = msgbox("Kayýt baþarýyla yüklendi.","Baþarýlý");

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data; global fs; global PDFD_angle; global ivev_angle; global arka; global sag; 
global sol; global ontaraf; global PDFD_angle_meanfiltered; global block_duration_datacorrected_last; global dorsal_fleksiyon;

PDFD_angle_meanfiltered=PDFD_angle-mean(PDFD_angle);

Band    = (2 / fs) * 1;
[B, A]  = butter(3, Band, 'low');   
block_duration_datacorrected_last = filtfilt(B, A, double(PDFD_angle_meanfiltered));

dorsal_fleksiyon= block_duration_datacorrected_last(block_duration_datacorrected_last>0);
threshold_angle=10;
x=20;
for k=x:(length(dorsal_fleksiyon)-x)
    
    gecici=dorsal_fleksiyon(k-x+1:k+x);
    if(gecici(ceil(length(gecici)/2))==max(gecici) & gecici(ceil(length(gecici)/2))>threshold_angle)
        dorsalTepeler(k) = dorsal_fleksiyon(k);
    end    
end

dorsalTepeler_=find(dorsalTepeler>0);
axes(handles.axes1); cla;
plot(dorsal_fleksiyon)
hold on
plot(dorsalTepeler_,dorsal_fleksiyon(dorsalTepeler_),'r+','MarkerFaceColor','r')
set(gca,'XTick',0:length(dorsal_fleksiyon)/10:length(dorsal_fleksiyon));
set(gca,'XTickLabel',0:length(dorsal_fleksiyon)/100:length(dorsal_fleksiyon)/10);
% axis([0 588 -150 0])
title("Açýsal Deðiþim (Y Ekseni)")
xlabel("Saniye")
ylabel("Açý")
xlim([0 length(dorsal_fleksiyon)])


hv=ones(1,length(dorsal_fleksiyon));
dorsal_bitis=sqrt(-1)*hv;
dorsal_baslangic=dorsal_bitis;

for m=1:length(dorsalTepeler_)
    mt5=dorsal_fleksiyon(dorsalTepeler_(m)-23:dorsalTepeler_(m));
    mn5=min(mt5);
    dorsal_baslangic(dorsalTepeler_(m)-23-1+find(mt5==mn5))= mn5;
end
dorsal_baslangic_=find(dorsal_baslangic~=sqrt(-1));

hold on
plot(dorsal_baslangic_,dorsal_fleksiyon(dorsal_baslangic_),'r*','MarkerFaceColor','r')

for k=1:length(dorsalTepeler_)
    mt4=dorsal_fleksiyon(dorsalTepeler_(k):dorsalTepeler_(k)+15);
    mn4=min(mt4);
    dorsal_bitis(find(mt4==mn4)+dorsalTepeler_(k)-1)=mn4;
end
dorsal_bitis_=find(dorsal_bitis~=sqrt(-1));

hold on
plot(dorsal_bitis_,dorsal_fleksiyon(dorsal_bitis_),'r*','MarkerFaceColor','r')

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data; global fs; global PDFD_angle; global ivev_angle; global arka; global sag; 
global sol; global ontaraf; global PDFD_angle_meanfiltered; global block_duration_datacorrected_last; global dorsal_fleksiyon;
global plantar_fleksiyon;

plantar_fleksiyon= block_duration_datacorrected_last(block_duration_datacorrected_last<0);
plantar_fleksiyon=abs(plantar_fleksiyon);
axes(handles.axes1); cla;
plot(plantar_fleksiyon(1:end),'k')
set(gca,'XTick',0:length(plantar_fleksiyon)/10:length(plantar_fleksiyon));
set(gca,'XTickLabel',0:length(plantar_fleksiyon)/100:length(plantar_fleksiyon)/10);
xlim([0 length(plantar_fleksiyon)])
title("Plantar Fleksiyonda Açýsal Deðiþim (Y Ekseni)")
xlabel("Saniye")
ylabel("Açý")

threshold_angle=6;

x=20;
for k=x:(length(plantar_fleksiyon)-x)
    
    gecici=plantar_fleksiyon(k-x+1:k+x);
    if(gecici(ceil(length(gecici)/2))==max(gecici) & gecici(ceil(length(gecici)/2))>threshold_angle)
        plantarTepeler(k) = plantar_fleksiyon(k);
    end
    
    
end

plantarTepeler_=find(plantarTepeler>0);

hold on
plot(plantarTepeler_,plantar_fleksiyon(plantarTepeler_),'r+','MarkerFaceColor','r')

hv=ones(1,length(plantar_fleksiyon));
plantar_bitis=sqrt(-1)*hv;
plantar_baslangic=plantar_bitis;

for m=1:length(plantarTepeler_)
    mt5=plantar_fleksiyon(plantarTepeler_(m)-17:plantarTepeler_(m));
    mn5=min(mt5);
    plantar_baslangic(plantarTepeler_(m)-17-1+find(mt5==mn5))= mn5;
end
plantar_baslangic_=find(plantar_baslangic~=sqrt(-1));

hold on
plot(plantar_baslangic_,plantar_fleksiyon(plantar_baslangic_),'r+','MarkerFaceColor','r')


for k=1:length(plantarTepeler_)
    mt4=plantar_fleksiyon(plantarTepeler_(k):plantarTepeler_(k)+15);
    mn4=min(mt4);
    plantar_bitis(find(mt4==mn4)+plantarTepeler_(k)-1)=mn4;
end
plantar_bitis_=find(plantar_bitis~=sqrt(-1));

hold on
plot(plantar_bitis_,plantar_fleksiyon(plantar_bitis_),'r+','MarkerFaceColor','r')


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data; global fs; global PDFD_angle; global ivev_angle; global arka; global sag; 
global sol; global ontaraf; 

onkuvvet=ontaraf-mean(ontaraf);
Band    = (2 / fs) * 1.5;
[B, A]  = butter(3, Band, 'low');   
on_kuvvet = filtfilt(B, A, double(onkuvvet));
axes(handles.axes2); cla;

on_force=on_kuvvet-on_kuvvet(1);
threshold_force=5;

x=20;
for k=x:(length(on_force)-x)
    
    gecici=on_force(k-x+1:k+x);
    if(gecici(ceil(length(gecici)/2))==max(gecici) & gecici(ceil(length(gecici)/2))>threshold_force)
        on_force_tepeler(k) = on_force(k);
    end
    
    
end

on_force_tepeler_=find(on_force_tepeler>0);

plot(on_force)
hold on
plot(on_force_tepeler_,on_force(on_force_tepeler_),'r+','MarkerFaceColor','r')
set(gca,'XTick',0:length(on_force)/10:length(on_force));
set(gca,'XTickLabel',0:length(on_force)/100:length(on_force)/10);
% axis([0 588 -150 0])
title("Egzersiz esnasýnda uygulanan kuvvet grafiði")
xlabel("Saniye")
ylabel("Açý")
xlim([0 length(on_force)])
hv=ones(1,length(on_force));
on_force_bitis=sqrt(-1)*hv;
on_force_baslangic=on_force_bitis;

for m=1:length(on_force_tepeler_)
    mt5=on_force(on_force_tepeler_(m)-20:on_force_tepeler_(m));
    mn5=min(mt5);
    on_force_baslangic(on_force_tepeler_(m)-20-1+find(mt5==mn5))= mn5;
end
on_force_baslangic_=find(on_force_baslangic~=sqrt(-1));


hold on
plot(on_force_baslangic_,on_force(on_force_baslangic_),'r*','MarkerFaceColor','r')
for k=1:length(on_force_tepeler_)
    mt4=on_force(on_force_tepeler_(k):on_force_tepeler_(k)+20);
    mn4=min(mt4);
    on_force_bitis(find(mt4==mn4)+on_force_tepeler_(k)-1)=mn4;
end
on_force_bitis_=find(on_force_bitis~=sqrt(-1));

% figure;
% plot(on_force)
hold on
plot(on_force_bitis_,on_force(on_force_bitis_),'ro','MarkerFaceColor','r')


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data; global fs; global PDFD_angle; global ivev_angle; global arka; global sag; 
global sol; global ontaraf; 

arkakuvvet=arka-mean(arka);
Band    = (2 / fs) * 1.5;
[B, A]  = butter(3, Band, 'low');   
arka_kuvvet = filtfilt(B, A, double(arkakuvvet));
arka_force=arka_kuvvet-arka_kuvvet(1);
axes(handles.axes2); cla;
threshold_force=5;

x=20;
for k=x:(length(arka_force)-x)
    
    gecici=arka_force(k-x+1:k+x);
    if(gecici(ceil(length(gecici)/2))==max(gecici) & gecici(ceil(length(gecici)/2))>threshold_force)
        arka_force_tepeler(k) = arka_force(k);
    end
    
    
end

arka_force_tepeler_=find(arka_force_tepeler>0);

plot(arka_force)
hold on
plot(arka_force_tepeler_,arka_force(arka_force_tepeler_),'r+','MarkerFaceColor','r')
set(gca,'XTick',0:length(arka_force)/10:length(arka_force));
set(gca,'XTickLabel',0:length(arka_force)/100:length(arka_force)/10);
% axis([0 588 -150 0])
title("Egzersiz esnasýnda uygulanan kuvvet grafiði")
xlabel("Saniye")
ylabel("Açý")
xlim([0 length(arka_force)])


hv=ones(1,length(arka_force));
arka_force_bitis=sqrt(-1)*hv;
arka_force_baslangic=arka_force_bitis;

for m=1:length(arka_force_tepeler_)
    mt5=arka_force(arka_force_tepeler_(m)-20:arka_force_tepeler_(m));
    mn5=min(mt5);
    arka_force_baslangic(arka_force_tepeler_(m)-20-1+find(mt5==mn5))= mn5;
end
arka_force_baslangic_=find(arka_force_baslangic~=sqrt(-1));


hold on
plot(arka_force_baslangic_,arka_force(arka_force_baslangic_),'r*','MarkerFaceColor','r')


for k=1:length(arka_force_tepeler_)
    mt4=arka_force(arka_force_tepeler_(k):arka_force_tepeler_(k)+20);
    mn4=min(mt4);
    arka_force_bitis(find(mt4==mn4)+arka_force_tepeler_(k)-1)=mn4;
end
arka_force_bitis_=find(arka_force_bitis~=sqrt(-1));

% figure;
% plot(arka_force)
hold on
plot(arka_force_bitis_,arka_force(arka_force_bitis_),'ro','MarkerFaceColor','r')


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data; global fs; global PDFD_angle; global ivev_angle; global arka; global sag; 
global sol; global ontaraf; global sag_force; 

sag=data(:,5);
sagkuvvet=sag-mean(sag);
Band    = (2 / fs) * 1;
[B, A]  = butter(3, Band, 'low');   
sag_kuvvet = filtfilt(B, A, double(sagkuvvet));
axes(handles.axes2); cla;

sag_force=sag_kuvvet-sag_kuvvet(1);
threshold_force=5;

x=20;
for k=x:(length(sag_force)-x)
    
    gecici=sag_force(k-x+1:k+x);
    if(gecici(ceil(length(gecici)/2))==max(gecici) & gecici(ceil(length(gecici)/2))>threshold_force)
        sag_force_tepeler(k) = sag_force(k);
    end
    
    
end

sag_force_tepeler_=find(sag_force_tepeler>0);

plot(sag_force)
hold on
plot(sag_force_tepeler_,sag_force(sag_force_tepeler_),'r+','MarkerFaceColor','r')
set(gca,'XTick',0:length(sag_force)/10:length(sag_force));
set(gca,'XTickLabel',0:length(sag_force)/100:length(sag_force)/10);
% axis([0 588 -150 0])
title("Egzersiz esnasýnda uygulanan kuvvet grafiði")
xlabel("Saniye")
ylabel("Açý")
xlim([0 length(sag_force)])


hv=ones(1,length(sag_force));
sag_force_bitis=sqrt(-1)*hv;
sag_force_baslangic=sag_force_bitis;

for m=1:length(sag_force_tepeler_)
    mt5=sag_force(sag_force_tepeler_(m)-20:sag_force_tepeler_(m));
    mn5=min(mt5);
    sag_force_baslangic(sag_force_tepeler_(m)-20-1+find(mt5==mn5))= mn5;
end
sag_force_baslangic_=find(sag_force_baslangic~=sqrt(-1));


hold on
plot(sag_force_baslangic_,sag_force(sag_force_baslangic_),'r*','MarkerFaceColor','r')


for k=1:length(sag_force_tepeler_)
    mt4=sag_force(sag_force_tepeler_(k):sag_force_tepeler_(k)+20);
    mn4=min(mt4);
    sag_force_bitis(find(mt4==mn4)+sag_force_tepeler_(k)-1)=mn4;
end
sag_force_bitis_=find(sag_force_bitis~=sqrt(-1));

% figure;
% plot(arka_force)
hold on
plot(sag_force_bitis_,sag_force(sag_force_bitis_),'ro','MarkerFaceColor','r')


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data; global fs; global PDFD_angle; global ivev_angle; global arka; global sag; 
global sol; global ontaraf; global sol_force; 

sol=data(:,6);
solkuvvet=sol-mean(sol);
solkuvvet_=solkuvvet/3;

Band    = (2 / fs) * 1;
[B, A]  = butter(3, Band, 'low');   
sol_kuvvet = filtfilt(B, A, double(solkuvvet_));
axes(handles.axes2); cla;

sol_force=sol_kuvvet-sol_kuvvet(1);
threshold_force=5;

x=20;
for k=x:(length(sol_force)-x)
    
    gecici=sol_force(k-x+1:k+x);
    if(gecici(ceil(length(gecici)/2))==max(gecici) & gecici(ceil(length(gecici)/2))>threshold_force)
        sol_force_tepeler(k) = sol_force(k);
    end
    
    
end

sol_force_tepeler_=find(sol_force_tepeler>0);

plot(sol_force)
hold on
plot(sol_force_tepeler_,sol_force(sol_force_tepeler_),'r+','MarkerFaceColor','r')
set(gca,'XTick',0:length(sol_force)/10:length(sol_force));
set(gca,'XTickLabel',0:length(sol_force)/100:length(sol_force)/10);
% axis([0 588 -150 0])
title("Egzersiz esnasýnda uygulanan kuvvet grafiði")
xlabel("Saniye")
ylabel("Açý")
xlim([0 length(sol_force)])


hv=ones(1,length(sol_force));
sol_force_bitis=sqrt(-1)*hv;
sol_force_baslangic=sol_force_bitis;

for m=1:length(sol_force_tepeler_)
    mt5=sol_force(sol_force_tepeler_(m)-20:sol_force_tepeler_(m));
    mn5=min(mt5);
    sol_force_baslangic(sol_force_tepeler_(m)-20-1+find(mt5==mn5))= mn5;
end
sol_force_baslangic_=find(sol_force_baslangic~=sqrt(-1));


hold on
plot(sol_force_baslangic_,sol_force(sol_force_baslangic_),'r*','MarkerFaceColor','r')


for k=1:length(sol_force_tepeler_)
    mt4=sol_force(sol_force_tepeler_(k):sol_force_tepeler_(k)+20);
    mn4=min(mt4);
    sol_force_bitis(find(mt4==mn4)+sol_force_tepeler_(k)-1)=mn4;
end
sol_force_bitis_=find(sol_force_bitis~=sqrt(-1));

% figure;
% plot(arka_force)
hold on
plot(sol_force_bitis_,sol_force(sol_force_bitis_),'ro','MarkerFaceColor','r')

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data; global fs; global PDFD_angle; global ivev_angle; global arka; global sag; 
global sol; global ontaraf; global PDFD_angle_meanfiltered; global block_duration_datacorrected_last; global dorsal_fleksiyon;
global plantar_fleksiyon; global iversiyon; global iversiyon_bitis_; global iversiyonTepeler_; global iversiyon_baslangic_;


ivev_angle2=ivev_angle;
for i=1:length(ivev_angle)-1
    if (ivev_angle(i)<320)
        ivev_angle2(i)=ivev_angle2(i)+359;
    end
end
axes(handles.axes1); cla;

ivev_angle_meanfiltered=ivev_angle2-mean(ivev_angle2);
Band    = (2 / fs) * 1.2;
[B, A]  = butter(3, Band, 'low');   
block_duration_datacorrected_last = filtfilt(B, A, double(ivev_angle_meanfiltered));
iversiyon= block_duration_datacorrected_last(block_duration_datacorrected_last>0);
plot(iversiyon,'k')
set(gca,'XTick',0:length(iversiyon)/10:length(iversiyon));
set(gca,'XTickLabel',0:length(iversiyon)/100:length(iversiyon)/10);
% axis([0 588 -150 0])
title("Açýsal Deðiþim(iversiyon) ")
xlabel("Saniye")
ylabel("Açý")
xlim([0 length(iversiyon)])

threshold_angle=6;

x=20;
for k=x:(length(iversiyon)-x)
    
    gecici=iversiyon(k-x+1:k+x);
    if(gecici(ceil(length(gecici)/2))==max(gecici) & gecici(ceil(length(gecici)/2))>threshold_angle)
        iversiyonTepeler(k) = iversiyon(k);
    end
    
    
end

iversiyonTepeler_=find(iversiyonTepeler>0);

hold on
plot(iversiyonTepeler_,iversiyon(iversiyonTepeler_),'r+','MarkerFaceColor','r')

hv=ones(1,length(iversiyon));
iversiyon_bitis=sqrt(-1)*hv;
iversiyon_baslangic=iversiyon_bitis;

for m=1:length(iversiyonTepeler_)
    mt5=iversiyon(iversiyonTepeler_(m)-24:iversiyonTepeler_(m));
    mn5=min(mt5);
    iversiyon_baslangic(iversiyonTepeler_(m)-24-1+find(mt5==mn5))= mn5;
end
iversiyon_baslangic_=find(iversiyon_baslangic~=sqrt(-1));

hold on
plot(iversiyon_baslangic_,iversiyon(iversiyon_baslangic_),'r+','MarkerFaceColor','r')


for k=1:length(iversiyonTepeler_)
    mt4=iversiyon(iversiyonTepeler_(k):iversiyonTepeler_(k)+15);
    mn4=min(mt4);
    iversiyon_bitis(find(mt4==mn4)+iversiyonTepeler_(k)-1)=mn4;
end
iversiyon_bitis_=find(iversiyon_bitis~=sqrt(-1));

hold on
plot(iversiyon_bitis_,iversiyon(iversiyon_bitis_),'r+','MarkerFaceColor','r')
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data; global fs; global PDFD_angle; global ivev_angle; global arka; global sag; 
global sol; global ontaraf; global PDFD_angle_meanfiltered; global block_duration_datacorrected_last; global dorsal_fleksiyon;
global plantar_fleksiyon; global iversiyon; global iversiyon_bitis_; global iversiyonTepeler_; global iversiyon_baslangic_;
global eversiyon; global eversiyon_bitis_; global eversiyonTepeler_; global eversiyon_baslangic_;

ivev_angle2=ivev_angle;
for i=1:length(ivev_angle)-1
    if (ivev_angle(i)<320)
        ivev_angle2(i)=ivev_angle2(i)+359;
    end
end
axes(handles.axes1); cla;

ivev_angle_meanfiltered=ivev_angle2-mean(ivev_angle2);
Band    = (2 / fs) * 1.2;
[B, A]  = butter(3, Band, 'low');   
block_duration_datacorrected_last = filtfilt(B, A, double(ivev_angle_meanfiltered));
eversiyon= block_duration_datacorrected_last(block_duration_datacorrected_last<0);
eversiyon=abs(eversiyon);
plot(eversiyon,'k')
set(gca,'XTick',0:length(eversiyon)/10:length(eversiyon));
set(gca,'XTickLabel',0:length(eversiyon)/100:length(eversiyon)/10);
% axis([0 588 -150 0])
title("Açýsal Deðiþim(eversiyon) ")
xlabel("Saniye")
ylabel("Açý")
xlim([0 length(eversiyon)])

threshold_angle=6;

x=20;
for k=x:(length(eversiyon)-x)
    
    gecici=eversiyon(k-x+1:k+x);
    if(gecici(ceil(length(gecici)/2))==max(gecici) & gecici(ceil(length(gecici)/2))>threshold_angle)
        eversiyonTepeler(k) = eversiyon(k);
    end
    
    
end

eversiyonTepeler_=find(eversiyonTepeler>0);

hold on
plot(eversiyonTepeler_,eversiyon(eversiyonTepeler_),'r+','MarkerFaceColor','r')

hv=ones(1,length(eversiyon));
eversiyon_bitis=sqrt(-1)*hv;
eversiyon_baslangic=eversiyon_bitis;

for m=1:length(eversiyonTepeler_)
    mt5=eversiyon(eversiyonTepeler_(m)-24:eversiyonTepeler_(m));
    mn5=min(mt5);
    eversiyon_baslangic(eversiyonTepeler_(m)-24-1+find(mt5==mn5))= mn5;
end
eversiyon_baslangic_=find(eversiyon_baslangic~=sqrt(-1));

hold on
plot(eversiyon_baslangic_,eversiyon(eversiyon_baslangic_),'r+','MarkerFaceColor','r')


for k=1:length(eversiyonTepeler_)
    mt4=eversiyon(eversiyonTepeler_(k):eversiyonTepeler_(k)+15);
    mn4=min(mt4);
    eversiyon_bitis(find(mt4==mn4)+eversiyonTepeler_(k)-1)=mn4;
end
eversiyon_bitis_=find(eversiyon_bitis~=sqrt(-1));

hold on
plot(eversiyon_bitis_,eversiyon(eversiyon_bitis_),'r+','MarkerFaceColor','r')
