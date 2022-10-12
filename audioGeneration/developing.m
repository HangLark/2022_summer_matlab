clc;clear;close all;
load('./arrays/0.05_9_Cross.mat');
%Set sound parameter
fs = 1000;			%The frequency of the signal
Fs = 44100;         %sampling frequency
%N = 24;			%Quantitative bits
Duration = 1;		%Length of the wav
L = Fs*Duration;  	%Points / Length
soundSpeed=340;


%Calculate distance
N = 51;
z0 = 2;
scan_range_X = linspace(-z0,z0,N);
scan_range_Y = linspace(z0,-z0,N);
[X,Y] = meshgrid(scan_range_X,scan_range_Y);
d0 = sqrt(X.^2 + Y.^2 + z0^2);  %Distance of every point to the center
for n = 1 : numberOfArrayElements
    d(:,:,n) = sqrt((X-coordinates(n,1)).^2+(Y-coordinates(n,2)).^2 + z0^2);%Distance of every point to every microphone
end

%Sound loaction
soundColumn=26;
soundRow=1;


%Calculate time delay
deltaT=(d(soundRow,soundColumn,:)-d0(soundRow,soundColumn))/soundSpeed;
deltaT=squeeze(deltaT);

%Generating an input signal
t = 0:1/Fs:(1/Fs)*(L-1);        %Generating the time series of sampling frequencies
sc = sin(2*pi*fs*t);

snr=0
s_awgn=awgn(sc,snr);
noise=randn(size(sc));              % 用randn函数产生高斯白噪声
% 求出信号x长 L
signal_power = 1/L*sum(sc.*sc);     % 求出信号的平均能量
noise_power=1/L*sum(noise.*noise);% 求出噪声的能量
noise_variance = signal_power / ( 10^(snr/10) );    % 计算出噪声设定的方差值
noise=sqrt(noise_variance/noise_power)*noise;       % 按噪声的平均能量构成相应的白噪声
sc=sc+noise;

% sc =round(sc*(2^(N-1)-1));    %Quantification 
audiowrite('./audioGeneration/sine_awgn.wav',s_awgn,Fs);
audiowrite('./audioGeneration/sine_o.wav',sc,Fs);

%Verification
figure(1);
stem(sc(1:128));
hold on;
t = t+deltaT(7);
scc = sin(2*pi*fs*t);
stem(scc(1:128));


for mIndex = 1:numberOfArrayElements
	t = 0:1/Fs:(1/Fs)*(L-1);
    t=t+deltaT(mIndex);        %Generating the time series of sampling frequencies
	signal = sin(2*pi*fs*t);
	% signal =round(sc*(2^(N-1)-1));    %Quantification
	filename=strcat('./audioGeneration/',num2str(mIndex),'.wav');
	audiowrite(filename,signal,Fs);
end

