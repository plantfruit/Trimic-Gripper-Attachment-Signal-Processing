% For the ML task

pulseNum = 1; % Number of pulses extracted from each file
fileNum = 10; % Number of trials conducted for each label
gridSize = 25; % Number of labels, or points in the grid. E.g. If it's a 5x5 grid, we have 25 points

labels = zeros(gridSize * fileNum * pulseNum, 1);

for i = 1:gridSize
    for j = 1:fileNum * pulseNum
        labels((i - 1) * fileNum * pulseNum + j) = i;
    end
end


save("5by5_trimic1_1pulse_labels.txt", "labels", "-ascii")
