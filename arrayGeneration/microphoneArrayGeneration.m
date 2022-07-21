% 
% Input: Number of microphones; Distance between adjacent microphone
% d<=lamda/2
clc;clear;close all;
printSuitableDistance(2000);
cordinates=generateCrossArray(9,0.05);
showArray(cordinates);



function [cordinates]=generateCrossArray(m,d)
	% m: the number of microphones
	% d: the distance between adjacent microphone
	m=m-1;
	n=m/4;
	%Up Arm
	x0=zeros(n,1);
	y0=linspace(d,d*n,n)';
	c0=[x0,y0];
	%Right Arm
	x1=linspace(d,d*n,n)';
	y1=zeros(n,1);
	c1=[x1,y1];
	x2=zeros(n,1);
	y2=linspace(-d,-d*n,n)';
	c2=[x2,y2];
	x3=linspace(-d,-d*n,n)';
	y3=zeros(n,1);
	c3=[x3,y3];
	cordinates=[0,0];
	cordinates=[cordinates;c0;c1;c2;c3];
	filename=strcat('./arrays/',num2str(d),'_',num2str(m+1),'_','Cross.mat');
    arrayElementSpacing=d;
    numberOfArrayElements=m+1;
	save(filename,'cordinates','arrayElementSpacing','numberOfArrayElements');
end


function []=showArray(cordinates)
	% cordinates: the cordinates of the microphones
	xT=cordinates(:,1);
	yT=cordinates(:,2);
	figure(1);
	plot(xT,yT,'ro');
	grid on
end


function []=printSuitableDistance(frequency)
	lamda=340/frequency;
	result=strcat("d <= ",num2str(lamda/2),"m");
	disp(result);
end