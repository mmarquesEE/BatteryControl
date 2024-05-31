
f_min = 0.01; f_max = 2e3; N = 50;

f_list = logspace(log10(f_min),log10(f_max),N);

f = f_min;
DCBias = 50e-3;
ACAmp = 10e-3;

out = cell(N,1);
%%
V = {}; I = {};
for i=1:N
    f = f_list(i);
    disp(['sim ',num2str(i),' f=',num2str(f)]);
    out = sim("testElectrical");

    V{i} = reshape(out.yout{1}.Values.Data,[],1);
    t{i} = reshape(out.yout{1}.Values.Time,[],1);
    I{i} = reshape(out.yout{2}.Values.Data,[],1);
end

%%
for i=1:N
    Fs = 1/mean(diff(t{i}));
    signals = [V{i},I{i}];
    for j=1:2
        x = signals(:,j);

        n = length(x);
        Y = fft(x);
        
        f = (1:n/2-1)*(Fs/n);
        magnitude = abs(Y(2:n/2)/n);
        fase = angle(Y(2:n/2));
        
        [~, idx] = max(magnitude);
        frequenciaPico = f(idx);
        magnitudePico = magnitude(idx);
        fasePico = fase(idx);
        
        S(j) = magnitudePico*exp(1j*fasePico);
        F(j) = frequenciaPico;
    end
    Z(i) = -S(1)/S(2);
end

%%
save("models\Battery\ACSweepRes.mat","Z","F");

%%
load("models\Battery\ACSweepRes.mat");
plot(real(Z),-imag(Z));


