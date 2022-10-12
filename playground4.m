clc;clear;close all;
rMax=1;
rMin=0.2;
N=8;
Q=[6,6,6,6,6,6,14,14];
m=sum(Q);
sMic=pi*(rMax^2-rMin^2)/(m-Q(1))/4;
S=pi*rMin^2/4;
r=rMin/2;

coordinates=[0,0];
for mIndex=1:Q(1)
	theta=(mIndex-1)*(2*pi/Q(1))+(1-1)*2*pi/length(Q);
	x=r*cos(theta);
   	y=r*sin(theta);
   	coordinates=[coordinates;x,y];
end

for nIndex=2:length(Q)
	S=sMic*Q(nIndex);
	r=sqrt(r^2+S/pi);
	for mIndex=1:Q(nIndex)
		theta=(mIndex-1)*(2*pi/Q(nIndex))+(nIndex-1)*2*pi/length(Q);
		x=r*cos(theta);
   		y=r*sin(theta);
   		coordinates=[coordinates;x,y];
	end
end
coordinates(1,:)=[];
showArray(coordinates);

function []=showArray(coordinates)
	% coordinates: the coordinates of the microphones
	xT=coordinates(:,1);
	yT=coordinates(:,2);
	figure(1);
	plot(xT,yT,'ro');
    xlabel('X(m)');
    ylabel('Y(m)');
	grid on
end