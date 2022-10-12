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
plot(Z);
[ma, I]=max(Z);%ma为数组的最大值，I为下标值
fprintf(1, '信号频率最强处的频率值=%f\n', I/nfft*44100);

for mIndex=2:numberOfArrayElements
    afterFFT=[afterFFT;fft(signals(mIndex,:),nfft);];
end

omega=(I/nfft*44100)*2*pi;
R=(afterFFT*afterFFT')/numberOfArrayElements;

R=signals*signals'/length(signals(1));


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

%R=0.5*squeeze(A(35,35,:))*squeeze(A(35,35,:))';

P=zeros(101,101);
a=A(15,15,:);
a=squeeze(a);
for rowIndex=1:101
    for colomnIndex=1:101
        P(rowIndex,colomnIndex)=1/(squeeze(A(rowIndex,colomnIndex,:))'*R^-1*squeeze(A(rowIndex,colomnIndex,:)));
    end
end
test=squeeze(A(30,35,:))'*R^-1*squeeze(A(30,35,:))
result=abs(P);
figure(1);
contourf(scan_range_X,scan_range_Y,result);

PdB=10*log10(abs(P));
figure(2);
contourf(scan_range_X,scan_range_Y,PdB);
contourf(PdB);
