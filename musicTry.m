clc;clear;close all;


load('./arrays/0.05_25_Cross.mat');
signals=audioread('./audios/1_withNoise.wav')';
for mIndex=2:numberOfArrayElements
    filename=strcat('./audios/',num2str(mIndex),'_withNoise.wav');
    signals=[signals;audioread(filename)'];
end

Rxx=signals*signals'/88200;


%get main f
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

M=1;
[EV,D]=eig(Rxx);    % 特征向量 特征值
EVA=diag(D)';
%disp(fliplr(EVA));
[EVA,I]=sort(EVA);  % 从小到大排列 返回索引
%EVA=fliplr(EVA);   % 反转元素
EV=fliplr(EV(:,I)); % 按列翻转特征向量,最大的到最左
En=EV(:,M+1:numberOfArrayElements);

P=zeros(101,101);
for rowIndex=1:101
    for colomnIndex=1:101
        P(rowIndex,colomnIndex)=1/(squeeze(A(rowIndex,colomnIndex,:))'*En*En'*squeeze(A(rowIndex,colomnIndex,:)));
    end
end
P = abs(P);
contourf(P);
