clc;clear;close all;

load('./arrays/0.05_25_Cross.mat');

signals=audioread('./audios/1_withNoise.wav')';
for mIndex=2:numberOfArrayElements
    filename=strcat('./audios/',num2str(mIndex),'_withNoise.wav');
    signals=[signals;audioread(filename)'];
end

nfft=4096;
afterFFT=fft(signals(1,:),nfft);
Z=abs(afterFFT);
[ma, I]=max(Z);%ma为数组的最大值，I为下标值
fprintf(1, '信号频率最强处的频率值=%f\n', I/nfft*44100);

for mIndex=2:numberOfArrayElements
    afterFFT=[afterFFT;fft(signals(mIndex,:),nfft);];
end

omega=(I/nfft*44100)*2*pi;
R=afterFFT*afterFFT';

%R=signals*signals';

%Calculate distance
N = 101;
z0 = 2;
scan_range_X = linspace(-4,4,N);
scan_range_Y = linspace(4,-4,N);
[X,Y] = meshgrid(scan_range_X,scan_range_Y);
d0 = sqrt(X.^2 + Y.^2 + z0^2);  %Distance of every point to the center
for n = 1 : numberOfArrayElements
    d(:,:,n) = sqrt((X-coordinates(n,1)).^2+(Y-coordinates(n,2)).^2 + z0^2);%Distance of every point to every microphone
end

A=zeros(101,101,numberOfArrayElements);
for rowIndex=1:101
    for colomnIndex=1:101
        for mIndex=1:numberOfArrayElements
            A(rowIndex,colomnIndex,mIndex)=exp(omega*-1i*(d(rowIndex,colomnIndex,mIndex)-d0(rowIndex,colomnIndex))/340);
        end
    end
end

Fs=44100;
fs=2000;
L=Fs*2;
t = 0:1/Fs:(1/Fs)*(L-1);
signal = sin(2*pi*fs*t);
x=squeeze(A(35,35,:))*signal;
R=0.5*squeeze(A(35,35,:))*squeeze(A(35,35,:))';

PdB=zeros(101,101);
for soundRow=1:101
    for soundColumn=1:101
        PdB(soundRow,soundColumn)=10*log10(abs(squeeze(A(soundRow,soundColumn,:))'*R*squeeze(A(soundRow,soundColumn,:))/numberOfArrayElements^2));
    end
end


figure(1);
hold on;
title('Beam Pattern');
xlabel('X(m)');
ylabel('Y(m)');
contourf(scan_range_X,scan_range_Y,PdB);
hold off;