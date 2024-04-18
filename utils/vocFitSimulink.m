function voc = vocFitSimulink(soc)

persistent aux;

if isempty(aux)
    DB = load("vocFitSimulink.mat","vocFit");
    SOC = (0:100)';%[5;10;20;50;100];
    voc = feval(DB.vocFit,SOC);

    aux = fit(SOC,voc/voc(end),"linearinterp");
end

voc = feval(aux,soc);

end