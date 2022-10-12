clc;clear;close all;

load('./arrays/0.05_9_Cross.mat');

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
R=(afterFFT*afterFFT')/numberOfArrayElements;


N = 101;
z0 = 2;
scan_range_X = linspace(-4,4,N);
scan_range_Y = linspace(4,-4,N); 
[X,Y] = meshgrid(scan_range_X,scan_range_Y);

dN = sqrt(X.^2 + Y.^2 + z0^2);

for n = 1 : numberOfArrayElements
    dNM(:,:,n) = sqrt((X-coordinates(n,1)).^2+(Y-coordinates(n,2)).^2 + z0^2);
end

A=zeros(101,101,numberOfArrayElements);
for rowIndex=1:101
    for colomnIndex=1:101
        for mIndex=1:numberOfArrayElements
            A(rowIndex,colomnIndex,mIndex)=exp(omega*-1i*(dNM(rowIndex,colomnIndex,mIndex)-dN(rowIndex,colomnIndex))/340);
        end
    end
end

w=(R^-1*squeeze(A(51,51,:)))/(squeeze(A(51,51,:))'*R^-1*squeeze(A(51,51,:)));


BdB=zeros(101,101);
for rowIndex=1:101
    for colomnIndex=1:101
        BdB(rowIndex,colomnIndex)=20*log10(abs(w'*squeeze(A(rowIndex,colomnIndex,:))));
    end
end


figure(2);
hold on;
surfc(scan_range_X,scan_range_Y,BdB);
xlabel('X(m)');
ylabel('Y(m)');
zlabel('Beam Response (dB)');
hold off;