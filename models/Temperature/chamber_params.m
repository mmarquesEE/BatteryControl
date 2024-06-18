 clear all
%% Room conditions
room.env_temp = 27; % ºC

%% Step Amplitude
step_amp = -1;
Ts = 2;

%% Peltier TEC1-12706
actuator.peltier.seebeck = 0.02;% constante seebeck
actuator.peltier.tc = 0.5;% condutividade térmica
actuator.peltier.r = 0.85;% resitência interna
actuator.peltier.area = 40e-3*40e-3; % área

%% Heat Sink
actuator.extHeatSink.fh = 20e-3;    % Altura da aleta
actuator.extHeatSink.ft = 1.6e-3;   % Espessura da aleta
actuator.extHeatSink.fd = 104e-3;   % Lado do dissipador
actuator.extHeatSink.fg = 8e-3;     % Espaçamento entre aletas
actuator.extHeatSink.fn = 13;       % Número de aletas
actuator.extHeatSink.ftc = 237;     % Condutividade térmica do dissipador
actuator.extHeatSink.base_h = 5e-3; % Altura da base do dissipador
actuator.extHeatSink.basemass = 2600*actuator.extHeatSink.fd^2*actuator.extHeatSink.base_h; % Massa da base do dissipador
actuator.extHeatSink.specific_heat = 900; % Calor específico do dissipador

% Flow:
actuator.extHeatSink.pl = actuator.extHeatSink.fd;
actuator.extHeatSink.pca = ...
    (actuator.extHeatSink.fd - actuator.extHeatSink.fn*actuator.extHeatSink.ft)*...
    actuator.extHeatSink.fh; % Área do corte transversal do dissipador

actuator.extHeatSink.phd = ...
    2*actuator.extHeatSink.fg*actuator.extHeatSink.fh/...
    (actuator.extHeatSink.fg + actuator.extHeatSink.fh); % diâmetro hidráulico do dissipador

actuator.intHeatSink.fh = 30e-3;        % Altura da aleta
actuator.intHeatSink.ft = 1.6e-3;       % Espessura da aleta
actuator.intHeatSink.fd = 50e-3;        % Lado do dissipador
actuator.intHeatSink.fg = 3.8e-3;       % Espaçamento entre aletas
actuator.intHeatSink.fn = 13;           % Número de aletas
actuator.intHeatSink.ftc = 237;         % Condutividade térmica do dissipador
actuator.intHeatSink.base_h = 5e-3;     % Altura da base do dissipador
actuator.intHeatSink.basemass = 2600*actuator.intHeatSink.fd^2*actuator.intHeatSink.base_h;% Massa da base do dissipador
actuator.intHeatSink.specific_heat = 900;% Calor específico do dissipador
actuator.intHeatSink.volume = ...
    actuator.intHeatSink.base_h*actuator.intHeatSink.fd^2 + ...
    actuator.intHeatSink.fn*actuator.intHeatSink.fd*...
    actuator.intHeatSink.ft*actuator.intHeatSink.fh;

% Flow:
actuator.intHeatSink.pl = actuator.intHeatSink.fd;
actuator.intHeatSink.pca = ...
    (actuator.intHeatSink.fd - actuator.intHeatSink.fn*actuator.intHeatSink.ft)*...
    actuator.intHeatSink.fh;% Área do corte transversal do dissipador

actuator.intHeatSink.phd = ...
    2*actuator.intHeatSink.fg*actuator.intHeatSink.fh/...
    (actuator.intHeatSink.fg + actuator.intHeatSink.fh);% diâmetro hidráulico do dissipador


%% Cooler
close all

int_cfm_spg_table = readtable("models\Temperature\curvaH.csv");
% figure
% plot(int_cfm_spg_table.Var1,int_cfm_spg_table.Var2);

int_eff_poly = polyfit(1:6,[.257, .394, .453, .47, .459, .415],4);
int_eff_vec = polyval(int_eff_poly,linspace(1,6,length(int_cfm_spg_table.Var1)));

actuator.intCooler.nominal_vfr_vec = int_cfm_spg_table.Var1'*0.00047194745;% taxa de fluxo volumétrico
actuator.intCooler.nominal_spg_vec = int_cfm_spg_table.Var2'*249.08;% ganho de pressão estática
actuator.intCooler.nominal_eff_vec = int_eff_vec;% eficiência
actuator.intCooler.ref_cspeed = 8000; % velocidade da ventoinha em RPM
actuator.intCooler.area = 40e-3*40e-3;% Área da ventoinha

ext_cfm_spg_table = readtable("models\Temperature\curvaHH.csv");
% figure
% plot(ext_cfm_spg_table.Var1,ext_cfm_spg_table.Var2)

ext_eff_poly = polyfit(1:6,[.257, .394, .453, .47, .459, .415],4);
ext_eff_vec = polyval(ext_eff_poly,linspace(1,6,length(ext_cfm_spg_table.Var1)));

actuator.extCooler.nominal_vfr_vec = ext_cfm_spg_table.Var1'*0.00047194745;% diâmetro hidráulico do dissipador
actuator.extCooler.nominal_spg_vec = ext_cfm_spg_table.Var2'*249.08;% ganho de pressão estática
actuator.extCooler.nominal_eff_vec = ext_eff_vec;% eficiência
actuator.extCooler.ref_cspeed = 3575;% velocidade da ventoinha em RPM
actuator.extCooler.area = 92e-3*92e-3;% Área da ventoinha

%% DC Motor
actuator.intDC.ra = 1; % resistência de armadura do motor DC da ventoinha
actuator.intDC.la = 12e-6; % indutância de armadura do motor DC da ventoinha
actuator.intDC.kemf = (12-actuator.intDC.ra*0.06)/actuator.intCooler.ref_cspeed;

actuator.extDC.ra = 1;% resistência de armadura do motor DC da ventoinha
actuator.extDC.la = 12e-6;% indutância de armadura do motor DC da ventoinha
actuator.extDC.kemf = (12-actuator.extDC.ra*0.29)/actuator.extCooler.ref_cspeed;

%% Battery
battery.height = 7e-2;
battery.width = 3.5e-2;
battery.depth = 2.5e-2;
battery.volume = battery.height*battery.width*battery.depth;
battery.in_plane_tc = 28;
battery.cross_plane_tc = 3.4;
battery.specific_heat = 1.8e3;
battery.mass = 122e-3;
