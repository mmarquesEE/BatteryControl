 clear all
%% Room conditions
room.env_temp = 27; % ºC

%% Step Amplitude
step_amp = -1;
Ts = 2;

%% Peltier TEC1-12706
actuator.peltier.seebeck = 0.02;
actuator.peltier.tc = 0.5;
actuator.peltier.r = 0.85;
actuator.peltier.area = 40e-3*40e-3;

%% Heat Sink
actuator.extHeatSink.fh = 20e-3;
actuator.extHeatSink.ft = 1.6e-3;
actuator.extHeatSink.fd = 104e-3;
actuator.extHeatSink.fg = 8e-3;
actuator.extHeatSink.fn = 13;
actuator.extHeatSink.ftc = 237;
actuator.extHeatSink.base_h = 5e-3;
actuator.extHeatSink.basemass = 2600*actuator.extHeatSink.fd^2*actuator.extHeatSink.base_h;
actuator.extHeatSink.specific_heat = 900;

% Flow:
actuator.extHeatSink.pl = actuator.extHeatSink.fd;
actuator.extHeatSink.pca = ...
    (actuator.extHeatSink.fd - actuator.extHeatSink.fn*actuator.extHeatSink.ft)*...
    actuator.extHeatSink.fh;

actuator.extHeatSink.phd = ...
    2*actuator.extHeatSink.fg*actuator.extHeatSink.fh/...
    (actuator.extHeatSink.fg + actuator.extHeatSink.fh);

actuator.intHeatSink.fh = 30e-3;
actuator.intHeatSink.ft = 1.6e-3;
actuator.intHeatSink.fd = 50e-3;
actuator.intHeatSink.fg = 3.8e-3;
actuator.intHeatSink.fn = 13;
actuator.intHeatSink.ftc = 237;
actuator.intHeatSink.base_h = 5e-3;
actuator.intHeatSink.basemass = 2600*actuator.intHeatSink.fd^2*actuator.intHeatSink.base_h;
actuator.intHeatSink.specific_heat = 900;
actuator.intHeatSink.volume = ...
    actuator.intHeatSink.base_h*actuator.intHeatSink.fd^2 + ...
    actuator.intHeatSink.fn*actuator.intHeatSink.fd*...
    actuator.intHeatSink.ft*actuator.intHeatSink.fh;

% Flow:
actuator.intHeatSink.pl = actuator.intHeatSink.fd;
actuator.intHeatSink.pca = ...
    (actuator.intHeatSink.fd - actuator.intHeatSink.fn*actuator.intHeatSink.ft)*...
    actuator.intHeatSink.fh;

actuator.intHeatSink.phd = ...
    2*actuator.intHeatSink.fg*actuator.intHeatSink.fh/...
    (actuator.intHeatSink.fg + actuator.intHeatSink.fh);


%% Cooler
close all

int_cfm_spg_table = readtable("models\Temperature\curvaH.csv");
% figure
% plot(int_cfm_spg_table.Var1,int_cfm_spg_table.Var2);

int_eff_poly = polyfit(1:6,[.257, .394, .453, .47, .459, .415],4);
int_eff_vec = polyval(int_eff_poly,linspace(1,6,length(int_cfm_spg_table.Var1)));

actuator.intCooler.nominal_vfr_vec = int_cfm_spg_table.Var1'*0.00047194745;
actuator.intCooler.nominal_spg_vec = int_cfm_spg_table.Var2'*249.08;
actuator.intCooler.nominal_eff_vec = int_eff_vec;
actuator.intCooler.ref_cspeed = 8000;
actuator.intCooler.area = 40e-3*40e-3;

ext_cfm_spg_table = readtable("models\Temperature\curvaHH.csv");
% figure
% plot(ext_cfm_spg_table.Var1,ext_cfm_spg_table.Var2)

ext_eff_poly = polyfit(1:6,[.257, .394, .453, .47, .459, .415],4);
ext_eff_vec = polyval(ext_eff_poly,linspace(1,6,length(ext_cfm_spg_table.Var1)));

actuator.extCooler.nominal_vfr_vec = ext_cfm_spg_table.Var1'*0.00047194745;
actuator.extCooler.nominal_spg_vec = ext_cfm_spg_table.Var2'*249.08;
actuator.extCooler.nominal_eff_vec = ext_eff_vec;
actuator.extCooler.ref_cspeed = 3575;
actuator.extCooler.area = 92e-3*92e-3;

%% DC Motor
actuator.intDC.ra = 1;
actuator.intDC.la = 12e-6;
actuator.intDC.kemf = (12-actuator.intDC.ra*0.06)/actuator.intCooler.ref_cspeed;

actuator.extDC.ra = 1;
actuator.extDC.la = 12e-6;
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
