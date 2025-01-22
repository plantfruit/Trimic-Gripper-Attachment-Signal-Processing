close all
clear

% FOLDER PATH NAMES
grid5x5_1_1 = 'Excel Sheets/5x5_trimic_1re.xlsx';
grid5x5_1_2 = 'Excel Sheets/5x5_trimic_2re.xlsx';
grid5x5_1_3 = 'Excel Sheets/5x5_trimic_3re.xlsx';

force_1 = 'Excel Sheets/trimic1_force_1.xlsx'; 
force_2 = 'Excel Sheets/trimic1_force_2.xlsx';
force_3 = 'Excel Sheets/trimic1_force_3.xlsx';

% CONSTANTS
pulseNum = 10; % Number of pulses extracted from each file
fileNum = 10; % Number of files for each label
labelNum = 3; % Number of data points from the grid in experiment
figDims = [3 3];
percentOfLens = [10 50 90];
micNum = 3;

% SWITCHES
fileNames = {grid5x5_1_1, force_1, grid5x5_1_2, force_2, grid5x5_1_3, force_3};
    %{varobj2_1, varobj2_2, varobj2_3}; 
    % {grid5x5_1_1; grid5x5_1_2; grid5x5_1_3};

% PROCESSING BEGINS
locationInds = [1 13 25];
softPressInds = [1 3 5];
hardPressInds = [2 4 6];

allMedianRows = zeros(labelNum * length(percentOfLens), 100); medCounter = 1;
for k = 1:micNum
    figure
    subplotCounter = 1;

    micInd = (k - 1) * 2 + 1;
    gridName = fileNames{micInd};
    forceName = fileNames{micInd + 1};
    
    gridData = readmatrix(gridName);
    forceData = readmatrix(forceName);

    dataBlockLen = 100;

    for j = 1:labelNum
        subplot(figDims(1), figDims(2), subplotCounter) 
        gridIndBeg = (locationInds(j) - 1) * 100 + 1;
        gridIndEnd = gridIndBeg + dataBlockLen - 1;

        gridBlock = gridData(gridIndBeg:gridIndEnd, :);
        gridBlockAvg = mean(gridBlock, 1);
        plot(gridBlockAvg)
        subplotCounter = subplotCounter + 1;   
        ylim([50 110])
        title("Train Data")
    end

    dataBlockLen = 50; 

    for i = 1:labelNum
        dataBlockIndBeg = (softPressInds(i)-1) * dataBlockLen  + 1;
        dataBlockIndEnd = dataBlockIndBeg + dataBlockLen - 1;
        dataBlock = forceData(dataBlockIndBeg:dataBlockIndEnd,:);

        subplot(figDims(1), figDims(2), subplotCounter) 
        meanRow = mean(dataBlock, 1);
        plot(meanRow)
        subplotCounter = subplotCounter + 1;
        ylim([50 110])
        title("Soft Press")
    end

    for i = 1:labelNum
        dataBlockIndBeg = (hardPressInds(i)-1) * dataBlockLen  + 1;
        dataBlockIndEnd = dataBlockIndBeg + dataBlockLen - 1;
        dataBlock = forceData(dataBlockIndBeg:dataBlockIndEnd,:);

        subplot(figDims(1), figDims(2), subplotCounter) 
        meanRow = mean(dataBlock, 1);
        plot(meanRow)
        ylim([50 110])
        subplotCounter = subplotCounter + 1;
        title("Hard Press")
    end
end