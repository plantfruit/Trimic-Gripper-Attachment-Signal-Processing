% For the ML task

pulseNum = 10;
fileNum = 10;
gridSize = 25;

labels = zeros(gridSize * fileNum * pulseNum, 1);

for i = 1:gridSize
    for j = 1:fileNum * pulseNum
        labels((i - 1) * fileNum * pulseNum + j) = i;
    end
end


save("5by5_trimic1_re_labels.txt", "labels", "-ascii")
