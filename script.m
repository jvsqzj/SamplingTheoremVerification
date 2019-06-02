
%%%%%%%% Se lee el archivo de audio y se convierte en arreglos %%%%%%%
Fp = 20000;
[y,Fs] = audioread('organ.wav');
Kl=exp(5.9*10^-5*(Fp-800));
Kr=0.5*exp(5.9*10^-5*(Fp-800));
largo=length(y);
for i = 1:length(y)
    channel0(i,1) = i/Fs;
    channel0(i,2) = y(i,1);
    channel1(i,1) = i/Fs;
    channel1(i,2) = y(i,2);
end 

t = channel0(:,[1]);

%%%%%%%% Se obtiene el espectro de la señal de entrada %%%%%%%%%
ys = fft(y);

n = length(y);          % number of samples
f = (0:n-1)*(Fs/n);     % frequency range
power = abs(ys).^2/n;    % power of the DFT
power = [power(:,[1]),-power(:,[2])];

offset = 0; 
y = [offset + y(:,[1]) , y(:,[2]) - offset];

%%%%%%%% Se grafican las señales de entrada y su espectro %%%%%%%%%

subplot(2,3,1)
plot(f,power)
xlabel('Frequency')
ylabel('Power')
xlim([0 600])
title('Espectro de la señal estereo')

subplot(2,3,4)
plot(t,y)
xlabel('Time')
ylabel('Signal')
xlim([25/Fp 30/Fp])
title('Señal estereo')

%%%%%%%% Se ejecuta el procesamiento de la señal en Simulink %%%%%%%%

sim('exampleSamplingTheorem.slx');


t = product1.Time; 

p = [product0.Data, product1.Data];


ps = fft(p);

n = length(ps);          % number of samples
f = (0:n-1)*(Fs/n);     % frequency range
power = abs(ps).^2/n;    % power of the DFT
power = [power(:,[1]),-power(:,[2])];

subplot(2,3,5)
plot(t,p)
xlabel('Time')
ylabel('Signal')
xlim([25/Fp 30/Fp])
title(['Señal estereo muestreada @' num2str(Fp) 'Hz'])


subplot(2,3,2)
plot(f,power)
xlabel('Frequency')
ylabel('Power')
xlim([0 600])
title(['Espectro de la señal estereo muestreada @' num2str(Fp) 'Hz'])

%%%%%%%% Se obtienen gráficas de la salida del modelo Simulink %%%%%%%%

t = recovered1.Time;   

output = [recovered0.Data, recovered1.Data];

M1 = max(recovered0.Data);
M2 = min(recovered1.Data);

os = fft(output);

n = length(os);          % number of samples
f = (0:n-1)*(Fs/n);     % frequency range
power = abs(os).^2/n;    % power of the DFT
power = [power(:,[1]),-power(:,[2])];

subplot(2,3,6)
plot(t,output)
xlabel('Time')
ylabel('Signal')
xlim([25/Fp 30/Fp])
title('Señal recuperada')

subplot(2,3,3)
plot(f,power)
xlabel('Frequency')
ylabel('Power')
xlim([0 600])
title("Espectro de la señal recuperada")


filename = ['output@'  num2str(Fp)  '.wav'];
audiowrite(filename,output,Fs);




