close all 
clear

% FOLDER PATH NAMES
grid5x5_1_1 = 'Excel Sheets/5by5_trimic_1.xlsx';
grid5x5_1_2 = 'Excel Sheets/5by5_trimic_2.xlsx';
grid5x5_1_3 = 'Excel Sheets/5by5_trimic_3.xlsx';

% CONSTANTS
pulseNum = 10; % Number of pulses extracted from each file
fileNum = 10; % Number of files for each label
labelNum = 25; % Number of data points from the grid in experiment
percentOfLens = [10 50 90];

% SWITCHES
fileName = grid5x5_1_1;

% PROCESSING BEGINS
micData = readmatrix(fileName);

figure
for i = 1:labelNum
    % Extract all pulses for a certain label
    dataBlockLen = pulseNum * fileNum; 
    dataBlockIndBeg = (i-1) * dataBlockLen  + 1;
    dataBlockIndEnd = dataBlockIndBeg + dataBlockLen - 1;

    dataBlock = micData(dataBlockIndBeg:dataBlockIndEnd,:);

    % Calculate median of the pulses at certain percentile lengths 
    for j = 1:length(percentOfLens)
        partOfDataBlock = dataBlock(:, 1:round(0.01 * percentOfLens(j)));
        medianRow = median(dataBlock, 1);

        hold on
        g = plot(medianRow);
        %g.Color = 
    end
end

