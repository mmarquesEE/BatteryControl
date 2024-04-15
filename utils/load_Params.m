
load("input_modelo_bateria.mat");
% load("MainConfig.mat");

% open_system("main\CyclingProcess_v2.slx");

Temperature = 20; % ºC
SOC_MAX = 70;
SOC_MIN = 30;
rest_time = 3000; % seg

SOC = 0:100;
Voc = vocFitSimulink(SOC);

% plot(SOC,Voc,LineWidth=1.3);
% grid on
% xlabel("$SOC(\%)$",Interpreter="latex");
% ylabel("$V_{oc}(V)$",Interpreter="latex");

%% Cycling control
% Cycling mode (CYCLING_MODE)
% 0 - Constant current discharge
% 1 - Constant Power discharge

CYCLING_MODE = 1; %
ConstantCurrent = Simulink.Variant('CYCLING_MODE == 0');
ConstantPower = Simulink.Variant('CYCLING_MODE == 1');

%% Timing parameters
MCU_Ts = 10;            % Sample Time of Constant Power Circuit MCU.
P2CSwitchDelay = 10;    % Discharge to Charge switch delay (in Power mode).

SOC_VoC_Ts = 10;        % SOC-VoC refresh rate

%% EIS parameters

f_start = 100;
f_stop = 2000;
points = 50;

f_list = round(logspace(log10(f_start),log10(f_stop),points),1);
dt_list = 10*f_list.^(-1);
t_list = [0,cumsum(dt_list,2)];
f_list = [f_list,f_list(end)];

% plot(t_list,f_list)
