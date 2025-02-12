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

varobj3_1 = 'Various Objects 3 Mic 1';
varobj3_2 = 'Various Objects 3 Mic 2';
varobj3_3 = 'Various Objects 3 Mic 3';

force5x5_1 = 'Force 3 Points Mic 1';
force5x5_2 = 'Force 3 Points Mic 2';
force5x5_3 = 'Force 3 Points Mic 3';

grid3x3_mic1 = '3x3 Grid Mic 1';
grid3x3_mic2 = '3x3 Grid Mic 2';
grid3x3_mic3 = '3x3 Grid Mic 3';

regX_1_part1 = 'Regression X Mic 1 1st Half';
regX_1_part2 = 'Regression X Mic 1 2nd Half';
regX_2 = 'Regression X Mic 2';
regX_3_part1 = 'Regression X Mic 3 1st Half';
regX_3_part2 = 'Regression X Mic 3 2nd Half';
regY_1 = 'Regression Y Mic 1';
regY_2 = 'Regression Y Mic 2';
regY_3 = 'Regression Y Mic 3';

regX_2_1 = 'Regression 2 X Mic 1';
regX_2_2 = 'Regression 2 X Mic 2';
regX_2_3 = 'Regression 2 X Mic 3';
regY_2_1 = 'Regression 2 Y Mic 1';
regY_2_2 = 'Regression 2 Y Mic 2';
regY_2_3 = 'Regression 2 Y Mic 3';

noiseTest = 'Noise Test Jan 29';

noBG_1 = 'BG Silent Mic 1';
noBG_2 = 'BG Silent Mic 2';
noBG_3 = 'BG Silent Mic 3';
white_vol1_1 = 'BG White Vol 1 Mic 1';
white_vol1_2 = 'BG White Vol 1 Mic 2';
white_vol1_3 = 'BG White Vol 1 Mic 3';
white_vol2_1 = 'BG White Vol 2 Mic 1';
white_vol2_2 = 'BG White Vol 2 Mic 2';
white_vol2_3 = 'BG White Vol 2 Mic 3';
white_vol3_1 = 'BG White Vol 3 Mic 1';
white_vol3_2 = 'BG White Vol 3 Mic 2';
white_vol3_3 = 'BG White Vol 3 Mic 3';

rubberTube_res05 = 'Rubber Tube 0.5 Res';
rubberTube_6obj = 'Rubber Tube 6 Objects';

%=========================================================================
% Beginning of Analysis Portion of Script
%=========================================================================

% Select the dataset to analyze
folderPath = rubberTube_6obj;

% Parameters
numFilesSelected = 1;
pulseNum = 10; % Number of pulses to extract from each file
pulseInd = 6; % Where we start collecting the number of pulses, from cross-correlation indices
filesPerLabel = 10;
noiseThreshold = 10;
noiseThreshold2 = 3; %2;
magnitudeThreshold = 70; %30; %70; %80;
magnitudeThreshold2 = 70; % 30; %70;
filterOn = true;
tubeFilter = 17e3; %17e3; % Set to -1 if you want to turn it off. For rubber tube data only.
%[5000 21000]; <- 2D surface
fftWindow = [2500 20e3]; %;[5000 21e3]; %[2500 20000];

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

dirStartInd = filesPerLabel  * (pulseInd - 1) + 1;

pressFFTCounter = 1;
filterCounts = zeros(1, 5);

% Select a group of files from the folder
for k = dirStartInd:dirStartInd + numFilesSelected - 1
    fileName = [folderPath '/' originalFiles(k).name];

    micData = readmatrix(fileName);

    % Excise trailing zeros
    micData = micData(1:find(micData, 1, 'last'));

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
        % chirpIndex = indexCounter;
        if (tubeFilter ~= -1)
            chirpIndex = length(peakTimes) - round(0.35 * length(peakTimes)) - 1 - indexCounter;            
        else
            chirpIndex = length(peakTimes) - 1 - indexCounter;
        end
        indexCounter = indexCounter + 1;

        if (filterOn == true)
            % if (tubeFilter ~= -1 && peaks(chirpIndex) > tubeFilter)
            %     filterCounts(1) = filterCounts(1) + 1;
            %     continue
            % end
        end

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
        if (filterOn == true)
            if (std(smoothMicF) < noiseThreshold)
                filterCounts(2) = filterCounts(2) + 1;
                continue
            end

            if (std(smoothMicF(120:150)) < noiseThreshold2) % 130:150
                filterCounts(3) = filterCounts(3) + 1;
                continue
            end
        end

        % if (range(smoothMicF) < 30)
        %     continue
        % end

        % Window the FFT graph so only the first 8 (or possibly 9)
        % resonances are displayed
        [~, resWindow(1)] = min(abs(f - fftWindow(1))); % - windF1
        [~, resWindow(2)] = min(abs(f - fftWindow(2)));
        windowedSmooth = smoothMicF(resWindow(1):resWindow(2));

        if (filterOn == true)
            if (max(windowedSmooth(100:150)) < magnitudeThreshold2)
                filterCounts(4) = filterCounts(4) + 1;
                continue
            end

            if (windowedSmooth(1) < magnitudeThreshold)
                filterCounts(5) = filterCounts(5) + 1;
                continue
            end
        end

        pulseCounter = pulseCounter + 1;

        % Find the resonance frequencies
        [peakVals, peakLocs] = findpeaks(windowedSmooth, "MinPeakProminence", minPeakProminence, 'MinPeakDistance', 8);

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
        hold on; g = plot(f(1:resWindow(2)-resWindow(1) + 1), windowedF); %hold on; scatter(resonanceFrequencies, peakVals)
        ylim([0 140])
        % subplotCounter = subplotCounter + 1;

        xlabel("Frequency (Hz)"); ylabel("Magnitude");
        title("Microphone Data, Frequency-Domain, " + fileName)

        subplot(figDims(1), figDims(2), 1)
        hold on; plot(peakLocations(chirpIndex), peaks(chirpIndex), 'r.', 'LineWidth', 2, 'MarkerSize', 25);
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