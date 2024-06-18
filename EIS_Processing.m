close all
% 
% a = readtable("EIS.csv")
% figure
% plot3(a.Real_m__,a.Imaginary,a.Frequency_Hz_)

% b = readtable("EIS.csv")
% R = b.Real(b.Imaginary>0 & b.Imaginary<5);
% I = b.Imaginary(b.Imaginary>0&b.Imaginary<5);
% idx = b.Frequency(b.Imaginary>0 & b.Imaginary<5) > 10;
% R = R(idx);
% I = I(idx);
% plot(R,I,mean(R),mean(I),'o')
% [mean(R),mean(I)]
% 
c = readtable("DCL.csv")
figure
time = (0:(length(c.Voltage)-1))*1e-2;
yyaxis("left");
plot(time,c.Voltage); grid on;
ylabel("Voltage (V)",Interpreter="latex");
yyaxis("right");
plot(time,c.Current); grid on;
ylabel("Current (I)",Interpreter="latex");

xlabel("t(s)", Interpreter="latex");
title("DC Load data",Interpreter="latex");


