clc;clear;close all;
array=zeros(16,2);

xStart=-0.09;
yStart=0.09;
for ii=1:4
	xStart=-0.09;
	for jj=1:4
		array((ii-1)*4+jj,1)=xStart;
		array((ii-1)*4+jj,2)=yStart;
		xStart=xStart+0.06;
	end
	yStart=yStart-0.06;
end

xT=array(:,1);
yT=array(:,2);
figure(2);
plot(xT,yT,'ro');
grid on
%save('4x4-0.06m.mat','array')
