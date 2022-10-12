clf;
 
fs=100;
N=2560;%Sampling point
n=0:N-1;
t=n/fs;
x=sin(2*pi*10*t)+sin(2*pi*10*t+pi); 
 
y1=fft(x,N);
y2=fftshift(y1);
 
mag1=abs(y1);     
mag2=abs(y2);   
 
f1=n*fs/N;    
f2=n*fs/N-fs/2;
 
plot(f1,mag1,'r');
xlabel('频率/Hz');
ylabel('振幅');title('FFT','color','r');grid on;

