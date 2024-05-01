close all

o = out.logsout{1}.Values;
freq = o.frequency.Data;
re = o.FFT.Data(:,1);
im = o.FFT.Data(:,2);
[~,idx] = unique(freq);

freq = freq(idx);
re = re(idx);
im = im(idx);

freq = freq(2:end);
re = re(2:end);
im = im(2:end);

figure;subplot(211);plot(freq,re);subplot(212);plot(freq,im);
figure;
plot(re,im,'o')