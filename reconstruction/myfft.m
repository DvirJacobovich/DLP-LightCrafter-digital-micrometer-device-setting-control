clear
addpath 'C:\Users\Dvir\Desktop\DMD Settings and Control\DMD Full Control\measures\2021_9_29'
projection = csvread('29.09.1217.csv', 2);
data = load('C:\Users\Dvir\Desktop\DMD Settings and Control\DMD Full Control\measures\2021_9_29\Variables_29.09.1217.mat');
projection = projection(:,1);
timeScop = linspace(0,5*12,120000);
Tmax = 5*12;
dt = mean(diff(timeScop));
df = 1/Tmax;
Fmax = 1./dt;
freuq = -Fmax/2:df:Fmax/2;

fourier = (fft(projection));
fourierShift = (fftshift(fourier))';

H = zeros(1,length(projection)); %creat zeros vector
f0 = 10; %  cutoff frequency
lowf = find(abs(fourierShift) > f0);  %find place in the frequency vector that smaller than 10
H(lowf) = 1; %

Y=H.*fourierShift;
y=ifft(ifftshift(Y));

% plot(freuq,fourierShift)

figure, plot(timeScop, (y)), hold on
title('Output Time-Domain'), xlabel('Time (t)') ,ylabel('y(t)')
