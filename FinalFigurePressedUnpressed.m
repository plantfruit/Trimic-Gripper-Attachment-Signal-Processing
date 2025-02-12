close all 
clear

tube1D_unpressed = 'MAT Files/1Dtube_unpressedFFT.mat';
grid5x5FFT = 'MAT Files/2D_5x5controlFFT.mat';
grid5x5Time = 'MAT Files/2D_5x5controlTime.mat';

load('MAT Files/1Dtube_unpressedTime.mat');
tube_unpressedTime = allAvgTimes;
load('MAT Files/1Dtube_pressedTime.mat');
tube_pressedTime = chirpSegment;
load(tube1D_unpressed);
tube1D_unpressedFFT = avgFFT;

load('MAT Files/1D_6objTime.mat');
tubeObjTime = chirpSegment;
load('MAT Files/1D_6objFFT.mat');
tubeObjFFT = objFFT;

load(grid5x5FFT);
grid_unpressedFFT = allAvgFFTs;
load(grid5x5Time);
grid_unpressedTime = allAvgTimes;
load('MAT Files/2D_mic1FFT.mat');
grid_press1 = avgMic1FFT;
load('MAT Files/2D_mic2FFT.mat');
grid_press2 = avgMic2FFT;
load('MAT Files/2D_mic3FFT.mat');
grid_press3 = avgMic3FFT;
load('MAT Files/2D_mic1Time.mat');
grid_time1 = chirpSegment;
load('MAT Files/2D_mic2Time.mat');
grid_time2 = chirpSegment;
load('MAT Files/2D_mic3Time.mat');
grid_time3 = chirpSegment;

% Plot pressed and unpressed time domain for 1D tube
figure; plot((1/48e3:1/48e3:length(grid_unpressedTime(1,:))/48e3) * 1e3, tube_pressedTime)
hold on; plot((1/48e3:1/48e3:length(grid_unpressedTime(1,:))/48e3) * 1e3, tube_unpressedTime)
xlabel("Time (ms)"); ylabel("Magnitude"); legend("Pressed", "Unpressed"); 

% Plot pressed and unpressed FFT as well as time domain for 6 objects on 1D
% tube
figure; plot(linspace(2.5, 20, length(tubeObjFFT)), tubeObjFFT)
hold on; plot(linspace(2.5, 20, length(tubeObjFFT)), tube1D_unpressedFFT)
xlabel("Frequency (kHz)"); ylabel("Magnitude (dB)"); legend("Pressed", "Unpressed"); 
figure; plot((1/48e3:1/48e3:length(grid_unpressedTime(1,:))/48e3) * 1e3, tubeObjTime)
hold on; plot((1/48e3:1/48e3:length(grid_unpressedTime(1,:))/48e3) * 1e3, tube_unpressedTime)
xlabel("Time (ms)"); ylabel("Magnitude"); legend("Pressed", "Unpressed"); 

% Plot pressed and unpressed FFT for the 3 mics of 2D surface
figure; plot(linspace(5, 21, length(grid_press1)), grid_press1)
hold on; plot(linspace(5, 21, length(grid_press1)), grid_unpressedFFT(1,:))
xlabel("Frequency (kHz)"); ylabel("Magnitude (dB)"); legend("Pressed", "Unpressed"); ylim([50 100])

figure; plot(linspace(5, 21, length(grid_press2)), grid_press2)
hold on; plot(linspace(5, 21, length(grid_press2)), grid_unpressedFFT(2,:))
xlabel("Frequency (kHz)"); ylabel("Magnitude (dB)"); legend("Pressed", "Unpressed"); ylim([50 100])

figure; plot(linspace(5, 21, length(grid_press3)), grid_press3)
hold on; plot(linspace(5, 21, length(grid_press3)), grid_unpressedFFT(3,:))
xlabel("Frequency (kHz)"); ylabel("Magnitude (dB)"); legend("Pressed", "Unpressed"); ylim([50 100])

% Plot pressed and unpressed time domain for the 3 mics of 2D surface
figure; plot((1/48e3:1/48e3:length(grid_unpressedTime(1,:))/48e3) * 1e3, grid_time1)
hold on; plot((1/48e3:1/48e3:length(grid_unpressedTime(1,:))/48e3) * 1e3, grid_unpressedTime(1,:)); ylim([-12e3 8e3])
xlabel("Time (ms)"); ylabel("Magnitude"); legend("Pressed", "Unpressed"); 

figure; plot((1/48e3:1/48e3:length(grid_unpressedTime(1,:))/48e3) * 1e3, grid_time2)
hold on; plot((1/48e3:1/48e3:length(grid_unpressedTime(1,:))/48e3) * 1e3, grid_unpressedTime(2,:)); ylim([-12e3 8e3])
xlabel("Time (ms)"); ylabel("Magnitude"); legend("Pressed", "Unpressed");

figure; plot((1/48e3:1/48e3:length(grid_unpressedTime(1,:))/48e3) * 1e3, grid_time3)
hold on; plot((1/48e3:1/48e3:length(grid_unpressedTime(1,:))/48e3) * 1e3, grid_unpressedTime(3,:)); ylim([-12e3 8e3])
xlabel("Time (ms)"); ylabel("Magnitude"); legend("Pressed", "Unpressed");