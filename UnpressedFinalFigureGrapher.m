% Plot the time domain, FFT, and spectrogram of plots

close all
clear

%=========================================================================
% Beginning of Analysis Portion of Script
%=========================================================================
grid5x5_1 = '5x5 Grid Mic 1';
grid5x5_2 = '5x5 Grid Mic 2';
grid5x5_3 = '5x5 Grid Mic 3';
grid5x5 = {grid5x5_1, grid5x5_2, grid5x5_3};
controlJan24 = 'Control/Jan 24';
control5x5 = 'Control/5x5 Sample';
tube1D = 'Rubber Tube 0.5 Res';

folderPath = tube1D;

% Parameters
Fs = 48e3;
pulseNum = 10;
fileNum = 1; % Files per label
micNum = 1; %3; 1;
labelNum = 1; %3;
figDims = [3 3]; %[ 3 3 ]; [1 3]; 

numFilesSelected = 3;
pulseInd = 1; % Where we start collecting the number of pulses, from cross-correlation indices
filesPerLabel = fileNum;
noiseThreshold = 10;
noiseThreshold2 = 3;
magnitudeThreshold = 70; %80;
magnitudeThreshold2 = 70;
filterOn = true;

% "Switches" to control the script operation
freqWindow = [2500 20e3]; %[2500 20000]; %[5e3 21e3];
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
% Large arrays that have been pre-allocated to store results calculated
% during the primary loop
allStartFFT = zeros(numFilesSelected * pulseNum, 150);
allPressFFT = zeros(micNum * numFilesSelected * pulseNum, 150);
allChirpSegments = zeros(micNum * labelNum * filesPerLabel * pulseNum, 450);

originalFiles = dir([folderPath '/*.txt']);

pressFFTCounter = 1;
segmentCounter = 1;

for m = 1:micNum
    dirStartInd = filesPerLabel  * (pulseInd - 1) + 1;

    fileName = [folderPath '/' originalFiles(m).name];

    micData = readmatrix(fileName);

    [r, lags] = xcorr(transmitSignal, micData);
    [peaks, peakLocations] = findpeaks(r, 'MinPeakHeight', minpeakHeight, 'MinPeakDistance', gapTime * Fs * 0.5); % length(t) / 2);
    % MinPeakDistance: .wav - 300, .mp3 - 10

    peakTimes = -lags(peakLocations);
    peakTimes = abs(sort(peakTimes));
    chirpIndex = 1; % Maybe change later?

    pulseCounter = 1;
    indexCounter = 1;
    % Iterate through all delta pulses detected by the cross-correlation
    while pulseCounter < pulseNum + 1
        chirpIndex = indexCounter; %length(peakTimes) - 1 - indexCounter;
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

        % Perform FFT of the chirp segment
        micDataF = mag2db(abs(fft(chirpSegment)));
        f = linspace(0,Fs, length(micDataF));

        % Plot frequency response

        % Smooth out noise and "false peaks" using an average filter
        smoothMicF = smooth(micDataF, smoothingFactor);

        % Filter out noisy pulse samples
        if (filterOn == true)
            if (std(smoothMicF) < noiseThreshold)
                continue
            end

            if (std(smoothMicF(120:150)) < noiseThreshold2) % 130:150
                continue
            end
        end

        % Window the FFT graph so only the first 8 (or possibly 9)
        % resonances are displayed
        [~, resWindow(1)] = min(abs(f - freqWindow(1))); % - windF1
        [~, resWindow(2)] = min(abs(f - freqWindow(2)));
        windowedF = smoothMicF(resWindow(1):resWindow(2));

        if (filterOn == true)
            if (max(windowedF(100:150)) < magnitudeThreshold2)
                continue
            end

            if (windowedF(1) < magnitudeThreshold)
                continue
            end
        end

        allChirpSegments(segmentCounter,:) = chirpSegment;
        segmentCounter = segmentCounter + 1;

        pulseCounter = pulseCounter + 1;

        allPressFFT(pressFFTCounter, 1:length(windowedF)) = windowedF.';
        pressFFTCounter = pressFFTCounter + 1;
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



figure
m = 1;
subplotCounter = 1;
allAvgFFTs = zeros(labelNum, width(allPressFFT));
for i = 1:labelNum
    dataBlockLen = pulseNum * fileNum;
    dataBlockIndBeg = (m-1) * dataBlockLen * labelNum + (i-1) * dataBlockLen  + 1;
    dataBlockIndEnd = dataBlockIndBeg + dataBlockLen - 1;

    dataBlock = allPressFFT(dataBlockIndBeg:dataBlockIndEnd,:);

    avgFFT = mean(dataBlock, 1);

    subplot(figDims(1), figDims(2), subplotCounter); hold on; plot(avgFFT);
    title(i)
    ylim([30 110])

    subplotCounter = subplotCounter + 1;
    allAvgFFTs(i,:) = avgFFT;
end

allAvgTimes = zeros(labelNum, width(allChirpSegments));
for i = 1:labelNum
    dataBlockLen = pulseNum * fileNum;
    dataBlockIndBeg = (m-1) * dataBlockLen * labelNum + (i-1) * dataBlockLen  + 1;
    dataBlockIndEnd = dataBlockIndBeg + dataBlockLen - 1;

    dataBlock = allChirpSegments(dataBlockIndBeg:dataBlockIndEnd,:);

    avgChirpSegment = mean(dataBlock, 1);

    subplot(figDims(1), figDims(2), subplotCounter); hold on; plot(avgChirpSegment);
    title(i)
    ylim([-6.2e3 6.2e3])

    subplotCounter = subplotCounter + 1;
    allAvgTimes(i,:) = avgChirpSegment; 
end

pulseCounter = 1;

for i = 1:labelNum
    dataBlockLen = pulseNum * fileNum;
    dataBlockIndBeg = (i-1) * dataBlockLen  + 1;
    dataBlockIndEnd = dataBlockIndBeg + dataBlockLen - 1;

    dataBlock = allChirpSegments(dataBlockIndBeg:dataBlockIndEnd,:);

    avgChirpSegment = mean(dataBlock, 1);

    subplot(figDims(1), figDims(2), subplotCounter); hold on; pspectrum(avgChirpSegment, 'spectrogram');
    title(i)

    subplotCounter = subplotCounter + 1;
end


