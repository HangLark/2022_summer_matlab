clc;clear;close all;


arrayMatFilename='./arrays/0.05_25_Cross.mat';
fs=2000;
Fs=44100;
Duration=2;
soundRow=51;
soundColumn=101;
SNR=30;


L = Fs*Duration;  	%Points / Length
soundSpeed=340;
load(arrayMatFilename);

coordinates=[-4,0;-2,0;0,0;2,0;4,0];
numberOfArrayElements=5;


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

%Calculate time delay
deltaT=(d(soundRow,soundColumn,:)-d0(soundRow,soundColumn))/soundSpeed;
deltaT=squeeze(deltaT);

%Generating an input signal
for mIndex = 1:numberOfArrayElements
	t = 0:1/Fs:(1/Fs)*(L-1);
    t=t-deltaT(mIndex);        %Generating the time series of sampling frequencies
	signal = sin(2*pi*fs*t);
	% signal =round(sc*(2^(N-1)-1));    %Quantification
	filename=strcat('./audios/',num2str(mIndex),'.wav');
	audiowrite(filename,signal,Fs);
	signalWithNoise=awgn(signal,SNR); % Add white G noise
	filename=strcat('./audios/',num2str(mIndex),'_withNoise','.wav');
	audiowrite(filename,signalWithNoise,Fs);
end
