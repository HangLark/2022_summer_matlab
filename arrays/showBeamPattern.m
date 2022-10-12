clc;clear;close all;
load('./arrays/0.05_25_Cross.mat');
%load('./arrays/0.05_8_Circle.mat');
%load('./arrays/0.05_9_Rectangle.mat');
%load('0.5_0.1_0.98175_64_Underbrink.mat');
%load('0.5_0.1_17.2788_65_Archimedean.mat');
%load('./arrays/0.049_65_Circle.mat');
%load('0.5_0.1_1.4726_65_Dougherty.mat');
%load('./arrays/0.05_25_Rectangle.mat');

f=2000;
omega=2*pi*f;

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

w=squeeze(A(51,51,:))/numberOfArrayElements;

BdB=zeros(101,101);
for rowIndex=1:101
    for colomnIndex=1:101
        BdB(rowIndex,colomnIndex)=20*log10(abs(w'*squeeze(A(rowIndex,colomnIndex,:))));
    end
end

sectionOfBdB=BdB(51,:);


figure(1);
hold on;
title('Beam Pattern');
xlabel('X(m)');
ylabel('Y(m)');
contourf(scan_range_X,scan_range_Y,BdB);
hold off;

figure(2);
hold on;
surfc(scan_range_X,scan_range_Y,BdB);
xlabel('X(m)');
ylabel('Y(m)');
zlabel('Beam Response (dB)');
hold off;

tempBdB=BdB;
for rowIndex=1:101
    for colomnIndex=1:101
        if tempBdB(rowIndex,colomnIndex)<-3
            tempBdB(rowIndex,colomnIndex)=-50;
        end
    end
end

figure(3);
hold on;
title('Beam Pattern');
xlabel('X(m)');
ylabel('Y(m)');
contourf(scan_range_X,scan_range_Y,tempBdB);
hold off;


figure(4);
hold on;
title('Section of Beam Pattern');
xlabel('X(m)');
ylabel('Beam Response (dB)');
plot(scan_range_X,sectionOfBdB,'LineWidth',2);
xlim=get(gca,'Xlim');
plot(xlim,[-3,-3],'r:','LineWidth',2)
hold off;