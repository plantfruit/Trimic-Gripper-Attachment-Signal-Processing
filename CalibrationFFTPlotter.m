allFiles = readmatrix('Excel Sheets/calibration_middlepoint_5days.xlsx');
calibrationPulses = readmatrix('Excel Sheets/calibration_referencepulses.xlsx');

figDims = [2 3];
firstPulse = allFiles(1,:);

subplotTitles = {'Jan 14', 'Jan 19', 'Jan 20', 'Jan 20', 'Jan 21'};


figure
for i = 1:5
    calInd = (i - 1) * 10 + 1;
    calIndEnd = calInd + 10 - 1;
    
    
    measurementBlock = allFiles(calInd:calIndEnd,:);

    subplot(figDims(1), figDims(2), i)
    for j = 1:height(measurementBlock)
        calibratedPulse = measurementBlock(j,:) ./ calibrationPulses(i,:); 
        hold on
        plot(calibratedPulse)
    end

    % hold on; plot(calibrationPulses(i,:), '*-r')
    title(subplotTitles{i})
end