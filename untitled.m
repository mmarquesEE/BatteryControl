
N = 16384;Fs = 10000;

t = (0:(N-1))/Fs;
x = 1 + sin(2*pi*17*t-0.01);

X = fft(x - mean(x));

X = X(1:ceil((N+1)/2));

mag = abs(X) / N;
mag(2:end-1) = 2*mag(2:end-1);

phase = angle(X);

f = (0:ceil((N-1)/2)) * Fs / N;

subplot(211);
plot(f,mag);
subplot(212);
plot(f,phase);

temp = find(mag==max(mag));
idx = temp(1);

m = mag(idx)
p = phase(idx)