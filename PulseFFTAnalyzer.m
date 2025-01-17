close all
clear

Fs = 48e3;

%=========================================================================
% List of Filenames
%=========================================================================
grid5x5_mic1 = "5x5 Grid Mic 1";
grid5x5_mic2 = "5x5 Grid Mic 2"; 
grid5x5_mic3 = "5x5 Grid Mic 3";

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
pulseNum = 20; % Number of pulses to extract from each file
pulseInd = 1; % Where we start collecting the number of pulses, from cross-correlation indices
figDims = [5 4]; %[3 2];
%increments = [0.24 0.43];

% List of intermediate level time points which are used to find and
% determine the frequencies before the press and during the press.
% Expressed in units of percentage
timeIncrements = [0.22 0.7 0.77];

% Go to the directory containing data files (other directories are
% commented out
cd(folderPath);

% Excise trailing zeros
%micData = micData(1:find(micData, 1, 'last'));

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
allPressFFT = zeros(length(fileNames), 100);
allpwelchStarts = zeros(length(fileNames), 100);
allpwelchPresses = zeros(length(fileNames), 100);
allDiffStarts = zeros(length(fileNames), 100);
allDiffPresses = zeros(length(fileNames), 100);

% Source: https://www.mathworks.com/matlabcentral/answers/411500-how-do-i-read-all-the-files-in-a-folder
% Please save all files name in symmetrically before doing the operation
% names for example f1,f2,f3...
% Save the folder of files in the current directory
% Pls note the format of files,change it as required
original_files = dir([folderName '/*.txt']);

dirStartInd = pulseNum * (pulseInd - 1) + 1;

for k = dirStartInd:dirStartInd + pulseNum - 1
    fileName = [folderName '/' original_files(k).name];

    micData = readmatrix(fileName);

    [r, lags] = xcorr(transmitSignal, micData);
    [peaks, peakLocations] = findpeaks(r, 'MinPeakHeight', minpeakHeight, 'MinPeakDistance', gapTime * Fs); % length(t) / 2);
    % MinPeakDistance: .wav - 300, .mp3 - 10

    figure
    plot(r)
    hold on
    scatter(peakLocations, peaks)

    peakTimes = -lags(peakLocations);
    peakTimes = abs(sort(peakTimes));
    chirpIndex = 1; % Maybe change later?

    startFreqs = zeros(1,8);

    pressFreqs = zeros(1,8);

    subplotCounter = 1;
    figure
    % Iterate through all delta pulses detected by the cross-correlation
    for i = 1:pulseNum
        chirpIndex = pulseIndex + i - 1;

        % Extract the pulse and its reflections
        % Do this only at the specified time increments: roughly quarter of
        % the way through (resting state) or halfway through (pressdown
        % state)

        % Extract delta pulse by taking a small amount of time before and
        % after it
        chirpSegment = micData(peakTimes(chirpIndex) - pulseLength*1 + windowModifier : peakTimes(chirpIndex) + pulseLength*1.5 + windowModifier  - 1);
        subplot(figDims(1), figDims(2), 1); hold on; graph = plot(chirpSegment); %hold on; xline((peakTimes(chirpIndex) + windowModifier) / Fs, 'b-'); xline((peakTimes(chirpIndex) /Fs + (length(t) + windowModifier  - 1) /Fs), 'r-');
        subplotCounter = subplotCounter + 1;

        % Perform FFT of the chirp segment
        micDataF = mag2db(abs(fft(chirpSegment)));
        f = linspace(0,Fs, length(micDataF));

        % Plot frequency response
        if (findResonances == true)
            % Plot FFT before smoothing
            subplot(figDims(1), figDims(2), 2); plot(f, micDataF); xlim([0 22000]); ylim([0 140])

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

            % Plot FFT from initial stage
            if (i == round(timeIncrements(1) * length(peakTimes)))
                subplot(figDims(1), figDims(2), 3)
                hold on
                graph = plot(f, micDataF);
                xlim([0 22000]); ylim([0 140])

                startFreqs(1:length(resonanceFrequencies)) = realResonanceFrequencies;
                allStartFreqs(k, 1:length(startFreqs)) = startFreqs;
                allAmpStartLevels(k,1:length(peakVals)) = peakVals;
                allStartFFT(k, 1:length(windowedF)) = windowedF.';
                allpwelchStarts(k, 1:length(powerEstimate)) = powerEstimate.';
                allDiffStarts(k, 1:length(fftDerivative)) = fftDerivative.';
                %allAmpAreas(k, 1) = trapz(windowedSmooth(round(length(windowedSmooth)* 0.6):end));
            end

            % Plot FFT in pressdown stage
            if (i == round(timeIncrements(2) * length(peakTimes)))
                subplot(figDims(1), figDims(2), 4)
                hold on
                graph = plot(f, micDataF);
                xlim([0 22000]); ylim([0 140])


                pressFreqs(1:length(resonanceFrequencies)) = realResonanceFrequencies;
                allPressFreqs(k, 1:length(pressFreqs)) = pressFreqs;

                allFreqShifts(k, 1:max([length(pressFreqs) length(startFreqs)])) = [pressFreqs zeros(1, length(startFreqs) - length(pressFreqs))] ...
                    - [startFreqs zeros(1, length(pressFreqs) - length(startFreqs))];
                % Store the amplitude levels from press down stage
                allAmpPressLevels(k,1:length(peakVals)) = peakVals;
                allPressFFT(k, 1:length(windowedF)) = windowedF.';
                allpwelchPresses(k, 1:length(powerEstimate)) = powerEstimate.';
                allDiffPresses(k, 1:length(fftDerivative)) = fftDerivative.';
                %allAmpAreas(k, 2) = trapz(windowedSmooth(round(length(windowedSmooth)* 0.6):end));
            end

            % figure
            subplot(figDims(1), figDims(2),5)
            plot(f, micDataF); hold on; scatter(resonanceFrequencies + f(resWindow(1)), peakVals); xlim([0 20e3]); ylim([0 140])
            subplot(figDims(1), figDims(2), 6)
            plot(f(1:resWindow(2)-resWindow(1) + 1), windowedSmooth); hold on; scatter(resonanceFrequencies, peakVals)
            ylim([0 140])

            % Print the resonance frequencies that we found

            %format short g
            %realResonanceFrequencies'
        end

        xlabel("Frequency (Hz)"); ylabel("Magnitude");
        title("Microphone Data, Frequency-Domain, " + fileName)

    end
end

cd ..