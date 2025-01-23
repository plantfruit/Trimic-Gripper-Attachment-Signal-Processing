close all
clear

numRowsPerFile = 10;
numFilesPerLabel = 15;
numForces = 3;
numFilesPerForce = 5;
numLabels = 9;
figDims = [3 3];
plotColors = {'Red', 'Green', 'Blue'};

% Constants
g3x3_fileNames = {'Excel Sheets/3x3_trimic_1.xlsx', 'Excel Sheets/3x3_trimic_2.xlsx', 'Excel Sheets/3x3_trimic_3.xlsx'};

numMics = 3;


fileNames = g3x3_fileNames;

for k = 1:numMics
    figure

    fileName = fileNames{k};
    micData = readmatrix(fileName);

    for i = 1:numLabels
        subplot(figDims(1), figDims(2), i)

        for m = 1:3
            startInd = (i-1) * numFilesPerLabel * numRowsPerFile + (m-1) * numFilesPerForce * numRowsPerFile + 1;
            endInd = startInd + numFilesPerForce * numRowsPerFile - 1;
       
            dataBlock = micData(startInd:endInd,:);

            hold on
            g = plot(dataBlock.');
            for p = 1:length(g)
                g(p).Color = plotColors{m};
            end
        end

    title("Point " + i)
    end
end