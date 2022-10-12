clc;clear;close all;
load('./arrays/0.05_9_Cross.mat');
load('./arrays/0.05_8_Circle.mat');
%load('./arrays/0.05_9_Rectangle.mat');

f=2000;
omega=2*pi*f;

N = 101;
z0 = 2;
scan_range_X = linspace(-2,2,N);
scan_range_Y = linspace(2,-2,N); 
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
        BdB(rowIndex,colomnIndex)=20*log10(w'*squeeze(A(rowIndex,colomnIndex,:)));
    end
end

contourf(real(BdB));
