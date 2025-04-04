close all
clear

% FOLDER PATH NAMES
grid5x5_1_1 = 'Excel Sheets/5by5_trimic_1.xlsx';
grid5x5_1_2 = 'Excel Sheets/5by5_trimic_2.xlsx';
grid5x5_1_3 = 'Excel Sheets/5by5_trimic_3.xlsx';

varobj2_1 = 'Excel Sheets/miscobj2_1.xlsx';
varobj2_2 = 'Excel Sheets/miscobj2_2.xlsx';
varobj2_3 = 'Excel Sheets/miscobj2_3.xlsx';

force_1 = 'Excel Sheets/trimic1_force_1.xlsx'; 
force_2 = 'Excel Sheets/trimic1_force_2.xlsx';
force_3 = 'Excel Sheets/trimic1_force_3.xlsx';

% CONSTANTS
pulseNum = 10; % Number of pulses extracted from each file
fileNum = 10; % Number of files for each label
labelNum = 3; % Number of data points from the grid in experiment
figDims = [2 3];
percentOfLens = [10 50 90];
micNum = 3;

% SWITCHES
fileName = grid5x5_1_1;
fileNames = {force_1, force_2, force_3};
    %{varobj2_1, varobj2_2, varobj2_3}; 
    % {grid5x5_1_1; grid5x5_1_2; grid5x5_1_3};

% PROCESSING BEGINS
% Prepare colormap for the graphs
% cmap = colormap('jet'); % 'parula', 'hsv',
% colorIndices = linspace(1, size(cmap, 1), labelNum);

allMedianRows = zeros(labelNum * length(percentOfLens), 100); medCounter = 1;
for k = 1:micNum
    fileName = fileNames{k};
    figure
    micData = readmatrix(fileName);

    for i = 1:labelNum
        subplot(figDims(1), figDims(2), i)

        % Extract all pulses for a certain label
        dataBlockLen = pulseNum * fileNum;
        dataBlockIndBeg = (i-1) * dataBlockLen  + 1;
        dataBlockIndEnd = dataBlockIndBeg + dataBlockLen - 1;

        dataBlock = micData(dataBlockIndBeg:dataBlockIndEnd,:);

        % Calculate median of the pulses at certain percentile lengths
        for j = 1:length(percentOfLens)
            partOfDataBlock = dataBlock(1:round((0.01 * percentOfLens(j) * height(dataBlock))),:);
            medianRow = median(partOfDataBlock, 1);

            hold on
            plot(medianRow) %, 'Color', cmap(round(colorIndices(i)), :))
            allMedianRows(medCounter, 1:length(medianRow)) = medianRow;
            medCounter = medCounter + 1;
        end

        % Avoid redundant legends since all subplots use the same colors
        if (i == 1)
            legend('10', '50', '90')
        end

        title(i) 
        ylim([50 110])
    end
end


