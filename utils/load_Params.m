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

%% Warburg distributed parameters and block creation
Rd = 1e-3;
Cd = 10e5;
N = 100;

createZw = 0;

if(createZw)
    open_system(new_system("Zw","Subsystem"));
    modelname = gcs;
    
    pr0 = 0;
    for i=1:N
        add_block("fl_lib/Electrical/Electrical Elements/Resistor",...
            [modelname,'/R',num2str(i)]);
        add_block("fl_lib/Electrical/Electrical Elements/Capacitor",...
            [modelname,'/C',num2str(i)]);
        set_param([modelname,'/C',num2str(i)],"Orientation","down");
        if(i==1)
            pr0 = get_param([modelname,'/R',num2str(i)],"Position");
        end
        set_param([modelname,'/R',num2str(i)],"Position",pr0 + (i-1)*[100 0 100 0]);
        set_param([modelname,'/C',num2str(i)],"Position",...
            [(pr0(1)+(2*i-1)*50) pr0(2)+30 (pr0(1)+(2*i-1)*50) pr0(2)+30]+[0 0 40 40]);
        add_line(modelname,['R',num2str(i),'/Rconn 1'],['C',num2str(i),'/Lconn 1']);
        if(i>1)
            add_line(modelname,['R',num2str(i),'/Lconn 1'],['R',num2str(i-1),'/Rconn 1']);
            add_line(modelname,['C',num2str(i),'/Rconn 1'],['C',num2str(i-1),'/Rconn 1']);
        end

        set_param([modelname,'/R',num2str(i)],"r","Rd/N");
        set_param([modelname,'/C',num2str(i)],"r","0");
        set_param([modelname,'/C',num2str(i)],"c","Cd/N");
    end

    pcf = get_param([modelname,'/C',num2str(N)],"Position");
    add_block("nesl_utility/Connection Port",[modelname,'/+']);
    cp = get_param([modelname,'/+'],"Position");
    cpw = cp(3) - cp(1); cph = cp(4) - cp(2);
    set_param([modelname,'/+'],"Position",[pr0(1)-50, pr0(2)+cph/2,pr0(1)-50+cpw,pr0(2)+cph/2+cph]);
    
    add_block("nesl_utility/Connection Port",[modelname,'/-']);
    set_param([modelname,'/-'],"Orientation","left");
    set_param([modelname,'/-'],"Position",[pcf(3)+50,pcf(4)+cph/2,pcf(3)+50+cpw,pcf(4)+cph/2+cph]);
    
    add_line(modelname,'+/Rconn 1','R1/Lconn 1');
    add_line(modelname,'-/Rconn 1',['C',num2str(N),'/Rconn 1']);
end


