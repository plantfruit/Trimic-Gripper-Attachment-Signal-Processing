close all
clear

Fs = 48e3;

%=========================================================================
% List of Filenames
%=========================================================================
grid5x5_mic1 = '5x5 Grid Mic 1';
grid5x5_mic2 = '5x5 Grid Mic 2';
grid5x5_mic3 = '5x5 Grid Mic 3';

%=========================================================================
% Beginning of Analysis Portion of Script
%=========================================================================

% Select the dataset to analyze
folderPath = grid5x5_mic1;

% Select the distance trial to analyze
i = 4;

% "Switches" to control the script operation
findResonances = true;
windowModifier = 0;
transmitSignal = [0 0 0 0 0 1 0 0 0 0 0];
minpeakHeight = 10;
gapTime = 0.05;
pulseLength = 300;
smoothingFactor = 5; % 5 - tube. 10 - balloon
t = length(transmitSignal);
% For 26 cm tube -> make this 0
% For 10 cm tube -> make this 2
minPeakProminence = 2;
numFilesSelected = 10;
pulseNum = 20; % Number of pulses to extract from each file
pulseInd = 1; % Where we start collecting the number of pulses, from cross-correlation indices
figDims = [2 2]; %[3 9]; %[3 2];
%increments = [0.24 0.43];

% List of intermediate level time points which are used to find and
% determine the frequencies before the press and during the press.
% Expressed in units of percentage
timeIncrements = [0.22 0.7 0.77];

% Go to the directory containing data files (other directories are
% commented out
% cd(folderPath);

% Excise trailing zeros
%micData = micData(1:find(micData, 1, 'last'));

% Source: https://www.mathworks.com/matlabcentral/answers/411500-how-do-i-read-all-the-files-in-a-folder
% Please save all files name in symmetrically before doing the operation
% names for example f1,f2,f3...
% Save the folder of files in the current directory
% Pls note the format of files,change it as required
originalFiles = dir([folderPath '/*.txt']);
fileNames = originalFiles;

% Large arrays that have been pre-allocated to store results calculated
% during the primary loop
maxFreqs = zeros(length(fileNames), 192);

allFreqShifts = zeros(length(fileNames), 8);
allStartFreqs = zeros(length(fileNames), 8);
allPressFreqs = zeros(length(fileNames), 8);
allAmpStartLevels = zeros(length(fileNames), 8);
allAmpPressLevels = zeros(length(fileNames), 8);
allAmpAreas = zeros(length(fileNames), 2);

allStartFFT = zeros(length(fileNames), 100);
%allPressFFT = zeros(length(fileNames), 100);
allpwelchStarts = zeros(length(fileNames), 100);
allpwelchPresses = zeros(length(fileNames), 100);
allDiffStarts = zeros(length(fileNames), 100);
allDiffPresses = zeros(length(fileNames), 100);

allPressFFT = zeros(numFilesSelected * pulseNum, 100);

dirStartInd = numFilesSelected * (pulseInd - 1) + 1;

pressFFTCounter = 1;
% Select a group of files from the folder
for k = dirStartInd:dirStartInd + numFilesSelected - 1
    fileName = [folderPath '/' originalFiles(k).name];

    micData = readmatrix(fileName);

    [r, lags] = xcorr(transmitSignal, micData);
    [peaks, peakLocations] = findpeaks(r, 'MinPeakHeight', minpeakHeight, 'MinPeakDistance', gapTime * Fs * 0.5); % length(t) / 2);
    % MinPeakDistance: .wav - 300, .mp3 - 10

    figure
    subplot(figDims(1), figDims(2), 1)
    plot(r)
    hold on
    scatter(peakLocations, peaks)
   
    peakTimes = -lags(peakLocations);
    peakTimes = abs(sort(peakTimes));
    chirpIndex = 1; % Maybe change later?
    title(length(peakTimes))

     selPeaks = peaks(length(peakTimes) - 2 - pulseNum + 1: length(peakTimes) - 2 - pulseNum + 1 + 20);
    selLocs = peakLocations(length(peakLocations) - 2 - pulseNum + 1: length(peakLocations) - 2 - pulseNum + 1 + 20);
    hold on; scatter(selLocs, selPeaks)


    startFreqs = zeros(1,8);
    pressFreqs = zeros(1,8);

    % subplotCounter = 1;
    
    pulseCounter = 1;
    % Iterate through all delta pulses detected by the cross-correlation
    while pulseCounter < pulseNum
        % chirpIndex = length(peakTimes) - 2 - pulseNum + i;
        chirpIndex = length(peakTimes) - 1 - pulseCounter;
        pulseCounter = pulseCounter + 1;

        % Extract the pulse and its reflections
        % Do this only at the specified time increments: roughly quarter of
        % the way through (resting state) or halfway through (pressdown
        % state) 

        % Extract delta pulse by taking a small amount of time before and
        % after it
        try
            chirpSegment = micData(peakTimes(chirpIndex) - pulseLength * 0.25 + windowModifier : peakTimes(chirpIndex) + pulseLength * 1.25 + windowModifier  - 1);
        catch ME % Out of bounds index error
            chirpSegment = micData(peakTimes(chirpIndex) - pulseLength * 0.25 + windowModifier : end);
        end
        subplot(figDims(1), figDims(2), 2); hold on; graph = plot(chirpSegment); %hold on; xline((peakTimes(chirpIndex) + windowModifier) / Fs, 'b-'); xline((peakTimes(chirpIndex) /Fs + (length(t) + windowModifier  - 1) /Fs), 'r-');
        % subplotCounter = subplotCounter + 1;

        % Perform FFT of the chirp segment
        micDataF = mag2db(abs(fft(chirpSegment)));
        f = linspace(0,Fs, length(micDataF));

        % Filter out noisy pulse samples
        if (mean(micDataF) < 66)
            continue
        end

        % Plot frequency response
        if (findResonances == true)
            % Plot FFT before smoothing
            subplot(figDims(1), figDims(2), 3); hold on; plot(f, micDataF); xlim([0 22000]); ylim([0 140])
            % subplotCounter = subplotCounter + 1;

            % Smooth out noise and "false peaks" using an average filter
            smoothMicF = smooth(micDataF, smoothingFactor);

            % Window the FFT graph so only the first 8 (or possibly 9)
            % resonances are displayed
            [~, resWindow(1)] = min(abs(f - 5000)); % - windF1
            [~, resWindow(2)] = min(abs(f - 21000));
            windowedSmooth = smoothMicF(resWindow(1):resWindow(2));

            % Find the resonance frequencies
            [peakVals, peakLocs] = findpeaks(windowedSmooth, "MinPeakProminence", minPeakProminence, 'MinPeakDistance', 8);

            % Plot comparison of unsmoothed and the smoothed FFT
            % figure
            % subplot(2,1,1)
            % plot(f, micDataF); xlim([0 20e3]); ylim([0 140])
            % subplot(2,1,2)
            % plot(f, smoothMicF); xlim([0 20e3]); ylim([0 140])

            resonanceFrequencies = f(peakLocs);
            realResonanceFrequencies = resonanceFrequencies + f(resWindow(1));

            % For reducing number of FFT values/features (?)
            windowedF = smoothMicF(resWindow(1):resWindow(2)); %micDataF(resWindow(1):resWindow(2));
            powerEstimate = pwelch(chirpSegment, 64);
            fftDerivative = diff(windowedSmooth); %diff(windowedF);

            %allPressFFT(k, 1:length(windowedF)) = windowedF.';
            allPressFFT(pressFFTCounter, 1:length(windowedF)) = windowedF.';
            pressFFTCounter = pressFFTCounter + 1;
            

            subplot(figDims(1), figDims(2), 4)
            hold on; plot(f(1:resWindow(2)-resWindow(1) + 1), windowedF); %hold on; scatter(resonanceFrequencies, peakVals)
            ylim([0 140])
            % subplotCounter = subplotCounter + 1;
        end

        xlabel("Frequency (Hz)"); ylabel("Magnitude");
        title("Microphone Data, Frequency-Domain, " + fileName)

    end
end

% cd ..