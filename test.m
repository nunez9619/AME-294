[y,Fs] = audioread('Test_Guitar.wav');

output = wahwah(y,16000,Fs,2);
figure 
stem (y);
hold on
stem (output);
title('Orginal Audio Compared to Output From Code')
xlabel('t') % x-axis label
ylabel('y(t)') % y-axis label
legend('Original Audio','Output from Code')