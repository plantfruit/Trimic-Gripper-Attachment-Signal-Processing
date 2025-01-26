% For the ML task

pulseNum = 10; % Number of pulses extracted from each file
fileNum = 10; % Number of trials conducted for each label
gridSize = 10; % Number of labels, or points in the grid. E.g. If it's a 5x5 grid, we have 25 points

labels = zeros(gridSize * fileNum * pulseNum, 1);

for i = 1:gridSize
    for j = 1:fileNum * pulseNum
        labels((i - 1) * fileNum * pulseNum + j) = i;
    end
end


save("5x5_1_regX_1_cols1to94_labels.txt", "labels", "-ascii")
