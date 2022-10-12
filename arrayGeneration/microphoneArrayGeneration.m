% 
% Input: Number of microphones; Distance between adjacent microphone
% d<=lamda/2
clc;clear;close all;
printSuitableDistance(2000);
printFarField(1,2000);
%coordinates=generateCrossArray(65,0.0625);
%coordinates=generateCircleArray(65,0.049);
%coordinates=generateRectangleArray(25,0.05);
%coordinates=generateArchimedeanSpiralArray(65,11*pi/2,0.5,0.1);
%coordinates=generateDoughertyLogSpiralArray(65,15*pi/32,0.5,0.1);
%coordinates=generateUnderbrinkArray(65,5*pi/16,0.5,0.1,8,8);%30 5,6
%coordinates=generateArcondoulisSpiralArray(65,11*pi/2,0.9,0.9,0.5,0.1);
coordinates=generateAnnularArray(65,0.5,0.1);

showArray(coordinates);



function [coordinates]=generateCrossArray(m,d)
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
    %Down Arm
	x2=zeros(n,1);
	y2=linspace(-d,-d*n,n)';
	c2=[x2,y2];
    %Left Arm
	x3=linspace(-d,-d*n,n)';
	y3=zeros(n,1);
	c3=[x3,y3];
	coordinates=[0,0];
	coordinates=[coordinates;c0;c1;c2;c3];
	filename=strcat('./arrays/',num2str(d),'_',num2str(m+1),'_','Cross.mat');
    arrayElementSpacing=d;
    numberOfArrayElements=m+1;
	save(filename,'coordinates','arrayElementSpacing','numberOfArrayElements');
end


function [coordinates]=generateCircleArray(m,d)
    % m: the number of microphones
	% d: the distance between adjacent microphone
    theta=2*pi/(m-1);
    r=d/(2*sin(theta/2));
    coordinates=[r,0];
    for pointIndex=2:m-1
        x=r*cos((pointIndex-1)*theta);
        y=r*sin((pointIndex-1)*theta);
        coordinates=[coordinates;x,y];
    end
    coordinates=[coordinates;0,0];
    
    filename=strcat('./arrays/',num2str(d),'_',num2str(m),'_','Circle.mat');
    arrayElementSpacing=d;
    numberOfArrayElements=m;
	save(filename,'coordinates','arrayElementSpacing','numberOfArrayElements');
end


function [coordinates]=generateCircleArrayByDiameter(m,diameter)
    % m: the number of microphones
	% diameter: the diameter of the array

    theta=2*pi/m;
    r=d/(2*sin(theta/2));
    coordinates=[r,0];
    for pointIndex=2:m
        x=r*cos((pointIndex-1)*theta);
        y=r*sin((pointIndex-1)*theta);
        coordinates=[coordinates;x,y];
    end

    
    filename=strcat('./arrays/',num2str(diameter),'_',num2str(m),'_','Circle.mat');
    arrayElementSpacing=diameter;
    numberOfArrayElements=m;
	save(filename,'coordinates','arrayElementSpacing','numberOfArrayElements');
end

function [coordinates]=generateRectangleArray(m,d)
    % m: the number of microphones
	% d: the distance between adjacent microphone
	coordinates=[0,0];
    mPerRow=sqrt(m);
    for rowIndex=1:mPerRow
        y=(mPerRow-1)/2*d-(rowIndex-1)*d;
        for columnIndex=1:mPerRow
        	x=-(mPerRow-1)/2*d+(columnIndex-1)*d;
        	coordinates=[coordinates;x,y];
        end
    end
    coordinates(1,:)=[];
    
    filename=strcat('./arrays/',num2str(d),'_',num2str(m),'_','Rectangle.mat');
    arrayElementSpacing=d;
    numberOfArrayElements=m;
	save(filename,'coordinates','arrayElementSpacing','numberOfArrayElements');
end


function [coordinates]=generateArchimedeanSpiralArray(m,phi,rMax,rMin)
    % m: the number of microphones
	% phi: the number of turns the spiral should turn through, φ in radians
	% rMax-rMin: radius
	coordinates=[0,0];
    for mIndex=1:m
    	theta=((mIndex-1)*phi)/(m-1);
    	r=rMin+((rMax-rMin)/phi)*theta;
    	x=r*cos(theta);
    	y=r*sin(theta);
    	coordinates=[coordinates;x,y];
    end
    coordinates(1,:)=[];
    filename=strcat('./arrays/',num2str(rMax),'_',num2str(rMin),'_',num2str(phi),'_',num2str(m),'_','Archimedean.mat');
    arrayElementSpacing=-1;
    numberOfArrayElements=m;
	save(filename,'coordinates','arrayElementSpacing','numberOfArrayElements');
end


function [coordinates]=generateDoughertyLogSpiralArray(m,v,rMax,rMin)
    % m: the number of microphones
	% v: the constant angle at which radii from the origin of the spiral are cut by the spiral curve
	% rMax-rMin: radius
	coordinates=[0,0];
	lMax=rMin*sqrt(1+cot(v)^2)/cot(v)*(rMax/rMin-1);
    for mIndex=1:m
    	l=lMax*(mIndex-1)/(m-1);
    	theta=log(1+cot(v)*l/(rMin*sqrt(1+cot(v)^2)))/cot(v);
    	r=rMin*exp(cot(v)*theta);
    	x=r*cos(theta);
    	y=r*sin(theta);
    	coordinates=[coordinates;x,y];
    end
    coordinates(1,:)=[];
    filename=strcat('./arrays/',num2str(rMax),'_',num2str(rMin),'_',num2str(v),'_',num2str(m),'_','Dougherty.mat');
    arrayElementSpacing=-1;
    numberOfArrayElements=m;
	save(filename,'coordinates','arrayElementSpacing','numberOfArrayElements');
end


function [coordinates]=generateArcondoulisSpiralArray(m,phi,epsilonX,epsilonY,rMax,rMin)
    % m: the number of microphones
	% 
	% rMax-rMin: radius
	coordinates=[0,0];
	a=rMin*(m/(m*epsilonX+1));
	b=1/phi*log(rMax/(a*sqrt((1+epsilonX)^2*cos(phi)^2+(1+epsilonY)^2*sin(phi)^2)));

    for mIndex=1:m
    	theta=(mIndex-1)*phi/(m-1);
    	x=(mIndex+epsilonX*m)/m*a*cos(theta)*exp(b*theta);
    	y=(mIndex+epsilonY*m)/m*a*sin(theta)*exp(b*theta);
    	coordinates=[coordinates;x,y];
    end
    coordinates(1,:)=[];
    filename=strcat('./arrays/',num2str(rMax),'_',num2str(rMin),'_',num2str(phi),'_',num2str(m),'_','Arcondoulis.mat');
    arrayElementSpacing=-1;
    numberOfArrayElements=m;
	save(filename,'coordinates','arrayElementSpacing','numberOfArrayElements');
end


function [coordinates]=generateUnderbrinkArray(m,v,rMax,rMin,numberOfSpiralArms,mPerSpiralArms)
    % m: the number of microphones = numberOfSpiralArms * mPerSpiralArms
	% v: the spiral angle
	% rMax-rMin: radius
	coordinates=[0,0];
	lMax=rMin*sqrt(1+cot(v)^2)/cot(v)*(rMax/rMin-1);
	for armIndex=1:numberOfSpiralArms
		for mIndex=1:mPerSpiralArms
			if mIndex==1
				r=rMin;
			else
				r=rMax*sqrt((2*mIndex-3)/(2*numberOfSpiralArms-3));
			end
			theta=2*pi*(armIndex-1)/numberOfSpiralArms+log(r/rMin)/cot(v);
			x=r*cos(theta);
    		y=r*sin(theta);
    		coordinates=[coordinates;x,y];
		end
	end
	%coordinates(1,:)=[];

    filename=strcat('./arrays/',num2str(rMax),'_',num2str(rMin),'_',num2str(v),'_',num2str(m),'_','Underbrink.mat');
    arrayElementSpacing=-1;
    numberOfArrayElements=m;
	save(filename,'coordinates','arrayElementSpacing','numberOfArrayElements');
end


function [coordinates]=generateAnnularArray(m,rMax,rMin)
    % m: the number of microphones = numberOfSpiralArms * mPerSpiralArms
	% v: the spiral angle
	% rMax-rMin: radius
	rMax=rMax*2;
	rMin=rMin*2;
	N=8;
	Q=[6,6,6,6,6,6,14,14];
	m=sum(Q);
	sMic=pi*(rMax^2-rMin^2)/(m-Q(1))/4;
	S=pi*rMin^2/4;
	r=rMin/2;

	coordinates=[0,0];
	for mIndex=1:Q(1)
		theta=(mIndex-1)*(2*pi/Q(1));
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

    filename=strcat('./arrays/',num2str(m),'_','Annular.mat');
    arrayElementSpacing=-1;
    numberOfArrayElements=m;
	save(filename,'coordinates','arrayElementSpacing','numberOfArrayElements');
end


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


function []=printSuitableDistance(frequency)
	lamda=340/frequency;
	result=strcat("d should less than ",num2str(lamda/2),"m");
	disp(result);
end


function []=printFarField(diameter,frequency)
	lamda=340/frequency;
	Distance=2*diameter*diameter/lamda;
	result=strcat("Z should bigger than ",num2str(Distance),"m");
	disp(result);
end