clc;clear;close all;
f=1000;
c=340;
ula=[0,0.2,0.4,0.6];
d=0.2;
numberOfMics=4;

output=zeros(1,181);
for theta=1:181
	for mIndex=1:numberOfMics+1
		output(theta)=output(theta)+exp(1j*2*pi*f*mIndex*d*sind(theta-91)/c);
	end
	output(theta)=output(theta)/numberOfMics;
end
y=20*log10(output);
x=linspace(-90,90,181);
plot(x,y);