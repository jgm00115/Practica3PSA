%% Práctica 3: TRANSFORMADAS DE LA IMAGEN
% Jaime García Martínez
% Doble Grado Ingeniería de Telecomunicaciones y Telemática
% Procesado de Señales Audiovisuales
%% Transformada de Fourier de una imagen, representación
x = double(imread('Images/lena.tif'))/255;
[Y,U,V] = rgb2YUV(x);
% Trabajaremos con la luminancia para hacer la transformada de Fourier
T = fft(Y,[],1);    %DFT de cada columna de la matriz de Luminancia
T = fft(T,[],2);    %DFT de cada fila del resultado de la operación anterior
T_abs = log10(1 + abs(fftshift(T)));
T_angle = angle(fftshift(T));
% MatLab ya implementa una función para el cálculo de la DFT en 2D
P = fft2(Y);   
P_abs = log10(1 + abs(fftshift(P)));
P_angle = angle(fftshift(P));
% Representación de módulo y fase en escala logarítmica
figure('Name','2D_DTF');
subplot(221);imshow(T_abs,[]);title('log_{10}(1 + |T|)');set(gca,'visible','on');
subplot(223);imshow(T_angle,[]);title('Arg(T)');set(gca,'visible','on');
subplot(222);imshow(P_abs,[]);title('log_{10}(1 + |P|)');set(gca,'visible','on');
subplot(224);imshow(P_angle,[]);title('Arg(P)');set(gca,'visible','on');
% Hemos representado las dos transformadas para comprobar que el resultado
% es igual.
%% LPF y HPF ideal
x = double(imread('Images/lena.tif'))/255;
[Y,U,V] = rgb2YUV(x);
% Definimos las especificaciones del filtro
B = 0.2;    %Frecuencia normalizada [0,1]
M = 50;     %Número de filas 
N = 50;     %Número de columnas 
% Definimos la respuesta en frecuencia deseada
[x,y] = freqspace([M,N],'meshgrid');
r = sqrt(x.^2 + y.^2);
H = ones(M,N);
H(r > 0.2) = 0;
figure;mesh(x,y,H);title('Respuesta en frecuencia deseada');
xlabel('Frecuencia normalizada [-\pi,\pi] rad');
ylabel('Frecuencia normalizada [-\pi,\pi] rad');
% Definimos la ventana que vamos a emplear
win = rectwin(M)*rectwin(N)';
% Obtenemos la respuesta impulsiva
h = fwind2(H,win);
%% Definición de LPF y HPF FIR
Ws = 0.7;      %Frecuencia de corte del filtro en radianes (normalizada [0,1])
Aw = 0.3*pi;   %Ancho de banda de transición
M = ceil(6.6*pi/Aw);   %Orden
B = fir1(M,Ws,'high',hamming(M+1));  %Fir mediante enventanado
h = ftrans2(B);
[U,w] = freqz(B,1);
U = 20*log10(abs(U));
figure('Name','RespuestaFrecuencia');
subplot(121);plot(w/pi,U);title('Respuesta en frecuencia 1D');
xlabel('Frecuencia normalizada ($\frac{\omega}{\pi}$)','Interpreter','latex');
ylabel('Magnitud (dB)');grid on;
subplot(122);freqz2(h);title('Respuesta en frecuencia 2D')
%% Cálculo y representación de la DCT
x = double(imread('Images/lena.tif'))/255;
[Y,U,V] = rgb2YUV(x);
C = FCT2D(Y);
Z = dct2(Y);
figure('Name','DCT');
subplot(131);imshow(Y);title('Imagen analizada');
subplot(132);imshow(C);title('DCT con nuestro algoritmo');
subplot(133);imshow(Z);title('DCT con la función de MatLab');