clear all;
clc, close all

L       = 1e-6;
R0      = 50e-3;

RSEI = 1e-3;
CSEI = 10;

RCT     = 2e-3;
CDL     = 1000;

RD = 5e-3;
CD = 120e3;

Zrc = @(R,C,w) R./(1 + 1j*w.*R*C);
Zw = @(RD,CD,w)sqrt(RD./(1j*w*CD)).*coth(sqrt(1j*w*RD*CD));

Zbat = @(L,R0,RSEI,CSEI,RCT,CDL,RD,CD,w) ...
    1j*w*L + R0 + Zrc(RSEI,CSEI,w) + Zrc(RCT,CDL,w) + Zw(RD,CD,w);

f = 0.001:0.0001:2000;
w = 2*pi*f;
Z = Zbat(L,R0,RSEI,CSEI,RCT,CDL,RD,CD,w);

idx = imag(Z) < 2e-3;
plot(real(Z(idx)),-imag(Z(idx)));
xticks(0.05:0.001:0.056);
yticks(-2e-3:5e-4:2e-3);
xlabel("$Z_{Re}(\Omega)$","Interpreter","latex");
ylabel("$Z_{Im}(\Omega)$","Interpreter","latex");
grid on

title("Nyquist Plot")

figure
subplot(211);
plot(f(idx),abs(Z(idx)));
subplot(212);
plot(f(idx),angle(Z(idx)));

% %%
% fun = @(x) Zbat(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),w) - Z;
% 
% x0 = [1e-5,10e-3,2e-3,5,4e-3,600,2e-3,1e5];
% options = optimoptions('lsqnonlin','Display','iter');
% [x,resnorm,residual,exitflag,output] = lsqnonlin(fun,x0,[],[],options);
