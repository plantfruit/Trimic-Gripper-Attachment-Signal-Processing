clear

% Length of tone in seconds
duration = 300; 
% Sampling frequency
Fs = 44e3;

% Combined to form the multi-tone signal
%frequencies = [1e3, 2e3, 3e3, 4e3, 5e3];
%frequencies = [1e3, 5e3, 10e3, 15e3, 19e3];
lowtone = [1e3, 2e3, 3e3];
midtone = [10e3, 11e3, 12e3];
hightone = [20e3, 21e3, 22e3];
evenhighertone = [22e3];
twentyonetone = [21e3];
% inaudible = [25e3, 26e3, 27e3];
inaudible = [30e3, 31e3, 32e3];
inaudible2 = [20e3 21e3 22e3 23e3 24e3]; %[22e3, 23e3, 24e3, 25e3, 26e3, 27e3, 28e3, 29e3, 30e3, 31e3];
chatgptTone = [659.6];
stackTone = [13192];
articleTone = [4200]; articleNonRes = 200; articleNonRes2 = 1200; articleNonRes3 = 3200; articleNonRes4 = 5200; articleNonRes5 = 6200;
foamTone15 = [2858.3];
pvx1 = 691.532; pvx2 = 2074.6; pvx3 = 3457.7;
% frequencies = [20e3,, 19e3, 20e3];

% CONTROL PARAMETERS
fadeoutAtEnd = true;
frequencies = inaudible2;

t = 1/Fs:1/Fs:duration;
tones = zeros(length(frequencies), length(t));
% Define a tone for each specified frequency
for i = 1:length(frequencies)
    tones(i,:) = 1 * sin(2 * pi * frequencies(i) * t);
end
combinedTones = zeros(1,length(t));
% Add up the tones
for i = 1:length(frequencies)
    combinedTones = combinedTones + tones(i,:)* 32767;
end

if (fadeoutAtEnd == true)

end

combinedF = fft(combinedTones);
f = linspace(0, Fs, length(combinedF));
figure
plot(f, abs((combinedF)));

audiowrite("multitone.wav", int16(combinedTones), Fs);                                              