close all
%% Sample interval
Ts = 1;

%% Room conditions
room.env_temp = 25; % ºC

%% Heating

step_amp = 0.1;
out_heating = sim("models\Temperature\temp_test.slx");

%% Cooling

step_amp = -0.1;
out_cooling = sim("models\Temperature\temp_test.slx");

%%

Htime = out_heating.yout{1}.Values.Time;
Htemp = out_heating.yout{1}.Values.Data;

Ctime = out_cooling.yout{1}.Values.Time;
Ctemp = out_cooling.yout{1}.Values.Data;

%% System identification
[Kh,Th,Lh] = parametrosFOPTD( 0.1, Htemp-room.env_temp,Ts);
[Kc,Tc,Lc] = parametrosFOPTD(-0.1, Ctemp-room.env_temp,Ts);

if Lc < 0
    Lc = 0;
end
if Lh < 0
    Lh = 0;
end

s = tf('s');
G_h = exp(-Lh*s)*Kh/(Th*s + 1)
G_c = exp(-Lc*s)*Kc/(Tc*s + 1)

y_h =  0.1*step(G_h,Htime) + room.env_temp;
y_c = -0.1*step(G_c,Ctime) + room.env_temp;

subplot(211);
plot(Htime,Htemp,Htime,y_h);
subplot(212);
plot(Ctime,Ctemp,Ctime,y_c);

K = (Kh + Kc)/2;
T = (Th + Tc)/2;
L = (Lh + Lc)/2;

Gtotal = exp(-L*s)*K/(T*s + 1)

%%
function [Go, T1, L] = parametrosFOPTD(h, y, DeltaT)

    size_theta = 3;
    
    R = zeros(size_theta);
    f = zeros(size_theta, 1);
    
    N = length(y);
    for k = 1:N
        tau = (k-1)*DeltaT;
        phi = [h*tau; -h; -y(k)];
        R = R + phi*(phi');
        A = sum(y(1:k))*DeltaT;
        f = f + phi*A;
    end

    theta = R\f;
    Go = theta(1);
    T1 = theta(3);
    L = theta(2)/theta(1);
end