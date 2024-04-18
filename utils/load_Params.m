clear all
%%
load("input_modelo_bateria.mat");
load("PlantBus.mat");
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

