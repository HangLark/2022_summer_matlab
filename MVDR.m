clc;clear;close all;
[xx,fs]=audioread('./audioGeneration/1.wav');
x=xx(:,1);
N=length(x);
time=(0:N-1)/fs;
plot(x);
M=2048;
nfft=8192;
win=hanning(M);
freq=(0:nfft/2)*fs/nfft;
y=x(9001:9000+M);
y=y-mean(y);
Y=fft(y.*win,nfft);
figure(2)
subplot 211;plot(y);xlim([0 M]);
title('一帧信号波形');xlabel('样点');ylabel('幅值');
subplot 212;plot(freq,20*log10(abs(Y(1:nfft/2+1))));
grid;axis([0 max(freq) -60 55]);
title('频谱');xlabel('频率(Hz)');ylabel('幅值');
