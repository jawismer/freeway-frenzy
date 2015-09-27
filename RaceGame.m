function varargout = RaceGame(varargin)
% RACEGAME MATLAB code for RaceGame.fig
%      RACEGAME, by itself, creates a new RACEGAME or raises the existing
%      singleton*.
%
%      H = RACEGAME returns the handle to a new RACEGAME or the handle to
%      the existing singleton*.
%
%      RACEGAME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RACEGAME.M with the given input arguments.
%
%      RACEGAME('Property','Value',...) creates a new RACEGAME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RaceGame_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RaceGame_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RaceGame

% Last Modified by GUIDE v2.5 15-Mar-2015 17:49:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RaceGame_OpeningFcn, ...
                   'gui_OutputFcn',  @RaceGame_OutputFcn, ...
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

% ######################################################################################

% --- Executes just before RaceGame is made visible.
function RaceGame_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RaceGame (see VARARGIN)

% Choose default command line output for RaceGame
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.sensitivitySlider, 'Value', 0.5);
set(handles.gearSensSlider, 'Value', 0.5);

axes(handles.axes2);
bG = imread('GameBackground2.jpg');
image(bG);

% UIWAIT makes RaceGame wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% ######################################################################################

% --- Outputs from this function are returned to the command line.
function varargout = RaceGame_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% ######################################################################################

function comPortTextfield_Callback(hObject, eventdata, handles)
% hObject    handle to comPortTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comPortTextfield as text
%        str2double(get(hObject,'String')) returns contents of comPortTextfield as a double

% ######################################################################################

% --- Executes during object creation, after setting all properties.
function comPortTextfield_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comPortTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ######################################################################################

% --- Executes on button press in setupButton.
function setupButton_Callback(hObject, eventdata, handles)
% hObject    handle to setupButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('setup pressed');
%% 1. Specifies the COM port that the Arduino board is connected to
comPort = get(handles.comPortTextfield, 'String');
%comPort = 'COM10';%This can be found out using the device manager (Windows)
                  %On a mac type ls /dev/tty* in Terminal and 
                  %  identify the device that is listed as usbmodem
                  %  Example for a MAC comPort = '/dev/tty.usbmodemfa131';

%comPort = '/dev/tty.usbmodem1411';



%% 2. Initialize the Serial Port - setupSerial() (not to be altered)

%connect MATLAB to the accelerometer
if (~exist('serialFlag','var'))
 [accelerometer.s,serialFlag] = setupSerial(comPort);
end

%% 3. Run a calibration routine if needed - calibrate() (not to be altered)
 
%if the accelerometer is not calibrated, calibrate now
if(~exist('calCo', 'var'))
    calCo = calibrate(accelerometer.s);
end

handles.accelerometer = accelerometer;
handles.calCo = calCo;
guidata(hObject, handles);

% ######################################################################################

% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
accelerometer = handles.accelerometer;
calCo = handles.calCo;
axes(handles.axes1);

set(handles.startButton, 'String', 'Restart');
set(handles.gearLabel, 'String', 'Gear: LOW');

sensitivity = get(handles.sensitivitySlider, 'Value');
gearSens = get(handles.gearSensSlider, 'Value');

% Create grass
grassX = [0 10 10 0];
grassY = [0 0 10 10];
fill(grassX, grassY, 'g');
hold on;

stage = imread('GameStage.png');
image([0 10], [0 10], stage);

% Create lines
lineX = [0 0.2 0.2 0];
lineY = [0 0 1 1];
fill(lineX+4, lineY+1, 'w');
fill(lineX+4, lineY+4.5, 'w');
fill(lineX+4, lineY+8, 'w');
fill(lineX+5.8, lineY+1, 'w');
fill(lineX+5.8, lineY+4.5, 'w');
fill(lineX+5.8, lineY+8, 'w');

% Create car
carX = [4.5 5.5 5.5 4.5];
carY = [0.5 0.5 2.5 2.5];

% Import images
carImg = imread('CarTop.png');
busImg = imread('BusTop.png');
blueCarImg = imread('BlueCarTop.png');
greenCarImg = imread('GreenCarTop.png');

axis([0 10 0 10]);

% Initialize positions
carPosX = 0;
linePosY = 0;

foe1PosY = 7;
foe1PosX = 2.75;

foe2PosY = 3.5;
foe2PosX = 6.25;

foe3PosY = -5;
foe3PosX = 4.5;

% Initialize counters
done = 0;
t = 0;
dist = 0;
gear = 1;
speedFactor = 1;

foe1Lane = randi(3);
foe2Lane = foe1Lane;
while foe2Lane==foe1Lane
    foe2Lane = randi(3);
end
foe3Lane = foe2Lane;
while foe3Lane==foe2Lane || foe3Lane==foe1Lane
    foe3Lane = randi(3);
end

foe1PosY = 10+randi(8);
foe2PosY = 10+randi(8);
foe3PosY = 10+randi(8);

foe1PosX = (foe1Lane-1)*1.75 + 2.75;
foe2PosX = (foe2Lane-1)*1.75 + 2.75;
foe3PosX = (foe3Lane-1)*1.75 + 2.75;

baseVel = 0.03;
foe1Vel = foe1Lane*baseVel;
foe2Vel = foe2Lane*baseVel;
foe3Vel = foe3Lane*baseVel;

alpha = 0.1;
filteredGy = 0;

while done==0
    [gx gy gz] = readAcc(accelerometer, calCo);
    
    % Filtering gy
    filteredGy = (1-alpha)*filteredGy + alpha*gy;
    
    % Gear shift threshold detection
    threshold = (gearSens/2)+0.5;
    if gx < -threshold && gear == 1
        gear = 2;
        speedFactor = 1.75;
        set(handles.gearLabel, 'String', 'Gear: HIGH');
    elseif gx > threshold && gear == 2
        gear = 1;
        speedFactor = 1;
        set(handles.gearLabel, 'String', 'Gear: LOW');
    end
    
    % Adjust car X and road lines
    axis([0 10 0 10]);
    carPosX = carPosX - (sensitivity+0.01)*gy/5;
    linePosY = speedFactor*(t/4);
    
    % Update foe positions
    foe1PosY = foe1PosY - (speedFactor*foe1Vel);
    foe2PosY = foe2PosY - (speedFactor*foe2Vel);
    foe3PosY = foe3PosY - (speedFactor*foe3Vel);
    
    % Draw stage
    cla;
    image([0 10], [0 10], stage);
    
    % Draw road lines
    fill(lineX+4, lineY+10-mod(linePosY+1.167, 10), 'w');
    fill(lineX+4, lineY+10-mod(linePosY+4.5, 10), 'w');
    fill(lineX+4, lineY+10-mod(linePosY+7.833, 10), 'w');
    fill(lineX+5.8, lineY+10-mod(linePosY+1.167, 10), 'w');
    fill(lineX+5.8, lineY+10-mod(linePosY+4.5, 10), 'w');
    fill(lineX+5.8, lineY+10-mod(linePosY+7.833, 10), 'w');
    
    % Draw car
    image([carX(1)+carPosX carX(1)+1+carPosX], [0.5 2.5], carImg);
    
    % Draw foes
    image([foe1PosX 1+foe1PosX], [foe1PosY 2+foe1PosY], blueCarImg);
    image([foe2PosX 1+foe2PosX], [foe2PosY 3.5+foe2PosY], busImg);
    image([foe3PosX 1+foe3PosX], [foe3PosY 2+foe3PosY], greenCarImg);
    axis([0 10 0 10]);
    
    % Time increment
    t = t + 1;
    
    % Random foe spawning
    if foe1PosY <= -2
        currentLane = foe1Lane;
        while foe1Lane == currentLane
            foe1Lane = randi(3);
        end
        foe1PosX = (foe1Lane-1)*1.75 + 2.75;
        foe1Vel = foe1Lane*baseVel;
        foe1PosY = 10+randi(8);
        if foe1Lane == foe2Lane && foe1PosY<=foe2PosY+3.5
            foe1PosY = foe1PosY + 4;
        end
        if foe1Lane == foe3Lane && foe1PosY<=foe3PosY+3.5
            foe1PosY = foe1PosY + 4;
        end
    end
    if foe2PosY <= -3.5
        currentLane = foe2Lane;
        while foe2Lane == currentLane
            foe2Lane = randi(3);
        end
        foe2PosX = (foe2Lane-1)*1.75 + 2.75;
        foe2Vel = foe2Lane*baseVel;
        foe2PosY = 10+randi(8);
        if foe2Lane == foe1Lane && foe2PosY<=foe1PosY+3.5
            foe2PosY = foe2PosY + 4;
        end
        if foe2Lane == foe3Lane && foe2PosY<=foe3PosY+3.5
            foe2PosY = foe2PosY + 4;
        end
    end
    if foe3PosY <= -2
        currentLane = foe3Lane;
        while foe3Lane == currentLane
            foe3Lane = randi(3);
        end
        foe3PosX = (foe3Lane-1)*1.75 + 2.75;
        foe3Vel = foe3Lane*baseVel;
        foe3PosY = 10+randi(8);
        if foe3Lane == foe2Lane && foe3PosY<=foe2PosY+3.5
            foe3PosY = foe3PosY + 4;
        end
        if foe3Lane == foe1Lane && foe3PosY<=foe1PosY+3.5
            foe3PosY = foe3PosY + 4;
        end
    end
    
    % Collision detection
    if (foe1PosY <= 2.5 && foe1PosY+2 >= 0.5) && (carX(1)+carPosX <= foe1PosX+1 && carX(1)+carPosX+1 >= foe1PosX)
        done = 1;
    end
    if (foe2PosY <= 2.5 && foe2PosY+3.5 >= 0.5) && (carX(1)+carPosX+1 >= foe2PosX && carX(1)+carPosX <= foe2PosX+1)
        done = 1;
    end
    if (foe3PosY <= 2.5 && foe3PosY+2 >= 0.5) && (carX(1)+carPosX <= foe3PosX+1 && carX(1)+carPosX+1 >= foe3PosX)
        done = 1;
    end
    if (carX(1)+carPosX+1 >= 8 || carX(1)+carPosX <= 2)
        done = 1;
    end
    
    % Update distance counter
    if mod(t, 60) == 0
        dist = dist + 0.1;
        set(handles.distanceLabel, 'String', ['Distance Driven: ' num2str(dist) ' mi.']);
    end
    
    pause(0.0001);
end


% ######################################################################################

% --- Executes on button press in closeButton.
function closeButton_Callback(hObject, eventdata, handles)
% hObject    handle to closeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closeSerial();

% ######################################################################################

% --- Executes on slider movement.
function sensitivitySlider_Callback(hObject, eventdata, handles)
% hObject    handle to sensitivitySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

set(handles.sensitivityLabel, 'String', ['Steering Sensitivity: ' num2str(get(hObject, 'Value'))]);

% ######################################################################################

% --- Executes during object creation, after setting all properties.
function sensitivitySlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sensitivitySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function gearSensSlider_Callback(hObject, eventdata, handles)
% hObject    handle to gearSensSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

set(handles.gearSensLabel, 'String', ['Gear Shift Sensitivity: ' num2str(get(hObject, 'Value'))]);


% --- Executes during object creation, after setting all properties.
function gearSensSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gearSensSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
