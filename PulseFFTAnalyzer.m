close all
clear

Fs = 48e3;

%=========================================================================
% List of Filenames
%=========================================================================
grid5x5_mic1 = '5x5 Grid Mic 1';
grid5x5_mic2 = '5x5 Grid Mic 2';
grid5x5_mic3 = '5x5 Grid Mic 3';
grid5x5_mic3old = '5x5 Grid Mic 3 Old';

varobj2_1 = 'Various Objects 2 Mic 1';
varobj2_2 = 'Various Objects 2 Mic 2';
varobj2_3 = 'Various Objects 2 Mic 3';

force5x5_1 = 'Force 3 Points Mic 1';
force5x5_2 = 'Force 3 Points Mic 2';
force5x5_3 = 'Force 3 Points Mic 3';

%=========================================================================
% Beginning of Analysis Portion of Script
%=========================================================================

% Select the dataset to analyze
folderPath = force5x5_2;

% Parameters
numFilesSelected = 30;
pulseNum = 10; % Number of pulses to extract from each file
pulseInd = 1; % Where we start collecting the number of pulses, from cross-correlation indices
noiseThreshold = 12;

% "Switches" to control the script operation
findResonances = true;
trialDuplication = false; % Duplicate the FFTs of each trial, in series after the set, row-wise
windowModifier = 0;
transmitSignal = [0 0 0 0 0 1 0 0 0 0 0];
minpeakHeight = 1000; % 300, previously % 10, previously
gapTime = 0.05;
pulseLength = 300;
smoothingFactor = 5; % 5 - tube. 10 - balloon
t = length(transmitSignal);
% For 26 cm tube -> make this 0
% For 10 cm tube -> make this 2
minPeakProminence = 2;
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

dirStartInd = 10 * (pulseInd - 1) + 1;

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
    title(length(peakTimes) + " " + fileName)

    % selPeaks = peaks(length(peakTimes) - 2 - pulseNum + 1: length(peakTimes) - 2 - pulseNum + 1 + 20);
    % selLocs = peakLocations(length(peakLocations) - 2 - pulseNum + 1: length(peakLocations) - 2 - pulseNum + 1 + 20);
    % hold on; scatter(selLocs, selPeaks)

    startFreqs = zeros(1,8);
    pressFreqs = zeros(1,8);

    % subplotCounter = 1;

    pulseCounter = 1;
    indexCounter = 1;
    % Iterate through all delta pulses detected by the cross-correlation
    while pulseCounter < pulseNum + 1
        % chirpIndex = length(peakTimes) - 2 - pulseNum + i;
        chirpIndex = length(peakTimes) - 1 - indexCounter;
        indexCounter = indexCounter + 1;

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

        % Plot frequency response

        % Plot FFT before smoothing
        % subplot(figDims(1), figDims(2), 3); hold on; plot(f, micDataF); xlim([0 22000]); ylim([0 140])

        % subplotCounter = subplotCounter + 1;

        % Smooth out noise and "false peaks" using an average filter
        smoothMicF = smooth(micDataF, smoothingFactor);

        % Filter out noisy pulse samples
        if (std(smoothMicF) < noiseThreshold)
            continue
        end


        % Window the FFT graph so only the first 8 (or possibly 9)
        % resonances are displayed
        [~, resWindow(1)] = min(abs(f - 5000)); % - windF1
        [~, resWindow(2)] = min(abs(f - 21000));
        windowedSmooth = smoothMicF(resWindow(1):resWindow(2));

        if (windowedSmooth(1) < 80)
            continue
        end

        pulseCounter = pulseCounter + 1;



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


        xlabel("Frequency (Hz)"); ylabel("Magnitude");
        title("Microphone Data, Frequency-Domain, " + fileName)
    end

    % Only do this for the new mic, when we're duplicating the
    % remainder trials
    if (trialDuplication == true)
        for l = 1:pulseNum
            allPressFFT(pressFFTCounter, 1:length(windowedF)) = allPressFFT(pressFFTCounter - pulseNum,:);
            pressFFTCounter = pressFFTCounter + 1;
        end
    end
end

% cd ..