
%%%%%%%% Se lee el archivo de audio y se convierte en arreglos %%%%%%%
Fp = 800;   %%%% FRECUENCIA DE MUESTREO 
[y,Fs] = audioread('organ.wav');

%-----------------------------------------------------
%   Ganancias para el volumen de acuerdo al canal

%Kl=1; % sin ganancia en el volumen
%Kr=1; 
Kl=25; % % Ganacias para el volumen, activar si desea  corregir el volumen
Kr=25; % % Ganacias para el volumen, activar si desea  corregir el volumen
%-----------------------------------------------------



% lectura de las muestras del archivo para ser asignadas a un array para trabajar
for i = 1:length(y)
    channel0(i,1) = i/Fs;   %valores en el eje x para graficar
    channel0(i,2) = y(i,1); %right channel amplitude
    channel1(i,1) = i/Fs;   %valores en el eje x para graficar
    channel1(i,2) = y(i,2); %left channel amplitude
end 




t = channel0(:,[1]); % vector de tiempos para graficar, es una variable auxiliar


%--------------------------------------------------------------------------
%   Se grafican las señales de entrada y su espectro 
%--------------------------------------------------------------------------

%-------------------------------
%  Gráfica de Señal de Entrada
%-------------------------------

ys = fft(y); % Se obtiene el espectro de la señal de entrada %
n = length(y);         % number of samples
f = (0:n-1)*(Fs/n);     % frequency range
power = abs(ys).^2/n;    % power of the DFT
power = [power(:,[1]),-power(:,[2])];

offset = 0; % esto es solo para visualizar en los gráficos, para tener el valor original mantener en 0
y = [offset + y(:,[1]) , y(:,[2]) - offset];

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

%-----------------------------------
%  Gráfica de  Señal de muestreada
%-----------------------------------

ps = fft(p);
kte= length(ps)/length(channel0); %factor de escala para graficar bien 
n = length(ps);          % number of samples
f = (0:n-1)*(kte*Fs/n);     % frequency range
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

%-------------------------------
%  Gráfica de Señal recuperada
%-------------------------------

os = fft(output);
n = length(os);          % number of samples
f = (0:n-1)*(Fs/n);     % frequency range
power = abs(os).^2/n;    % power of the DFT
power = [power(:,[1]),-power(:,[2])];

%-----------------------------------------------------
%   Ganancias para el volumen de acuerdo al canal

%Kl=max_ch0_freq_in2/max_ch0_freq_out2; % modificar para corregir el volumen de cada canal
%Kr=max_ch1_freq_in2/max_ch1_freq_out2; %esta es para corregir el volumen del otro canal
%-----------------------------------------------------


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
audiowrite(filename,output,Fs); %se guarda el archivo generado




