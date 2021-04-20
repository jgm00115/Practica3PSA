%% Práctica 3: TRANSFORMADAS DE LA IMAGEN
% Jaime García Martínez
% Doble Grado Ingeniería de Telecomunicaciones y Telemática
% Procesado de Señales Audiovisuales
%% Transformada de Fourier de una imagen, representación
im = double(imread('Images/lena.tif'))/255;
[Y,U,V] = rgb2YUV(im);
% Trabajaremos con la luminancia para hacer la transformada de Fourier
T = fft(Y,[],1);    %DFT de cada columna de la matriz de Luminancia
T = fft(T,[],2);    %DFT de cada fila del resultado de la operación anterior
figure;imshow(log10(1 + abs(T)),[]);
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
% Podemos representar el módulo de la transformada en 3D
[M,N] = size(T_abs);
[x,y] = meshgrid(linspace(-1,1,N),linspace(-1,1,M));
label = 'frecuencia normalizada $\frac{\omega}{\pi}$';
figure('Name','3DDFT');
mesh(x,y,T_abs);xlabel(label,'Interpreter','latex');ylabel(label,'Interpreter','latex');
zlabel('log_{10}(1 + |T|)');title('3D DFT')
%% Definición de LPF y HPF FIR con método del enventanado
% Importamos imagen
x = double(imread('Images/lena.tif'))/255;
[Y,U,V] = rgb2YUV(x);
FY_abs = log10(1 + fftshift(abs(fft2(Y))));
% LPF specs:
Ws = 0.35;               %Frecuencia de corte del filtro en radianes (normalizada [0,1])
Aw = 0.05*pi;            %Ancho de banda de transición
M = ceil(6.6*pi/Aw);     %Orden para ventana de Hamming
% Cálculo de coeficientes del filtro 1D
B = fir1(M,Ws,hamming(M+1));
% Respuesta impulsiva del filtro en 2D
h = ftrans2(B);
% Filtramos la componente de Luminancia de la imagen
Z = filter2(h,Y);
FZ_abs = log10(1 + fftshift(abs(fft2(Z))));
% Representamos resultados
[H1D,w] = freqz(B,1);
H1D = abs(H1D);
% Respuestas en frecuencia de los filtros
figure('Name','LPF');
subplot(121);plot(w/pi,H1D);title('Respuesta en frecuencia 1D');
xlabel('Frecuencia normalizada ($\frac{\omega}{\pi}$)','Interpreter','latex');
ylabel('Magnitud');grid on;
subplot(122);freqz2(h);title('Respuesta en frecuencia 2D');
% Imágenes y espectros
figure('Name','Imspctrm');
subplot(231);imshow(Y);title('Imagen original');
subplot(232);imshow(h,[]);title('Respuesta impulsiva');
subplot(233);imshow(Z);title('Imagen filtrada');
subplot(234);imshow(FY_abs,[]);title('log_{10}(1 + |FFT(Y)|)');
subplot(235);imshow(log10(1 + fftshift(abs(fft2(h)))),[]);title('log_{10}(1 + |FFT(h)|)');
subplot(236);imshow(FZ_abs,[]);title('log_{10}(1 + |FFT(Z)|)');
% HPF specs:
Ws = 0.16;               %Frecuencia de corte del filtro en radianes (normalizada [0,1])
Aw = 0.05*pi;            %Ancho de banda de transición
M = ceil(6.6*pi/Aw);     %Orden para ventana de Hamming
% Cálculo de coeficientes del filtro 1D
B = fir1(M,Ws,'high',hamming(M+1));
% Respuesta impulsiva del filtro en 2D
h = ftrans2(B);
% Filtramos la componente de Luminancia de la imagen y volvemos a convertir
% a RGB
Z = filter2(h,Y);
FZ_abs = log10(1 + fftshift(abs(fft2(Z))));
% Representamos resultados
[H1D,w] = freqz(B,1);
H1D = abs(H1D);
% Respuestas en frecuencia de los filtros
figure('Name','HPF');
subplot(121);plot(w/pi,H1D);title('Respuesta en frecuencia 1D');
xlabel('Frecuencia normalizada ($\frac{\omega}{\pi}$)','Interpreter','latex');
ylabel('Magnitud');grid on;
subplot(122);freqz2(h);title('Respuesta en frecuencia 2D');
% Imágenes y espectros
figure('Name','Imspctrm');
subplot(231);imshow(Y);title('Luminancia imagen original');
subplot(232);imshow(h,[]);title('Respuesta impulsiva');
subplot(233);imshow(Z);title('Luminancia imagen filtrada');
subplot(234);imshow(FY_abs,[]);title('log_{10}(1 + |FFT(Y)|)');
subplot(235);imshow(log10(1 + fftshift(abs(fft2(h)))),[]);title('log_{10}(1 + |FFT(h)|)');
subplot(236);imshow(FZ_abs,[]);title('log_{10}(1 + |FFT(Z)|)');
% La imagen filtrada con el filtro paso alto revela los bordes de la imagen
figure('Name','Luminancia HPF');
subplot(121);imshow(Z);title('Luminancia imagen filtrada con HPF hamming');
subplot(122);imshow(Z,[]);title('Luminancia imagen filtrada ajustando límites de escala de grises')
%% Definición de LPF y HPF gaussianos 
% Imagen de entrada
im = double(imread('Images/lena.tif'))/255;
Y = rgb2gray(im);   % Trabajaremos con la luminancia de la imagen
FY_abs = log10(1 + fftshift(abs(fft2(Y))));
% LPF specs:
M = 17; %Filas de la matriz del filtro 
N = 17; %Columnas de la matriz del filtro
bw = 0.30;   %Ancho de banda del filtro
% Calculamos la respuesta impulsiva del filtro paso bajo
[x,y] = meshgrid(0:M-1,0:N-1);
h_low = fspecial('gaussian',[M,N],1/bw);
% Filtramos obteniendo la señal de salida y su espectro
Z = filter2(h_low,Y);
FZ_abs = log10(1 + fftshift(abs(fft2(Z))));
% Representamos
figure('Name','LPF gaussiano');
subplot(231);imshow(Y);title('Luminancia imagen original');
subplot(234);imshow(FY_abs,[]);title('log_{10}(1 + |FFT(Y)|)');
subplot(232);mesh(x,y,h_low);title('Respuesta impulsiva LPF')
subplot(235);freqz2(h_low);title('Respuesta en frecuencia LPF');
subplot(233);imshow(Z);title('Luminancia imagen filtrada');
subplot(236);imshow(FZ_abs,[]);title('log_{10}(1 + |FFT(Z)|)')
% HPF specs: Mismas que el filtro paso bajo
% Usaremos el método del enventanado, definiendo la respuesta en frecuencia
% del filtro paso alto ideal y enventando con la ventana gaussiana
% calculada en el filtro paso bajo
H_high = ones([M,N]);
[wx,wy] = freqspace([M,N],'meshgrid');
r = sqrt(wx.^2 + wy.^2);
H_high(r < bw) = 0; % Respuesta en frecuencia ideal
h_high = fwind2(H_high,h_low); % Enventanamos la respuesta ideal
% Normalizaremos la respuesta en frecuencia para que la amplitud máxima sea
% 1
H_high = fft2(h_high);
H_high = H_high/max(abs(H_high(:)));
h_high = ifft2(H_high);
% Filtramos obteniendo la señal de salida y su espectro
Z = filter2(h_high,Y);
FZ_abs = log10(1 + fftshift(abs(fft2(Z))));
% Representamos
figure('Name','HPF gaussiano');
subplot(231);imshow(Y);title('Luminancia imagen original');
subplot(234);imshow(FY_abs,[]);title('log_{10}(1 + |FFT(Y)|)');
subplot(232);mesh(x,y,h_high);title('Respuesta impulsiva HPF')
subplot(235);freqz2(h_high);title('Respuesta en frecuencia HPF');
subplot(233);imshow(Z);title('Luminancia imagen filtrada');
subplot(236);imshow(FZ_abs,[]);title('log_{10}(1 + |FFT(Z)|)');
figure('Name','Luminancia HPF');
subplot(121);imshow(Z);title('Luminancia imagen filtrada con HPF gaussiano');
subplot(122);imshow(Z,[]);title('Luminancia imagen filtrada ajustando límites de escala de grises')
%% Cálculo y representación de la DCT
x = double(imread('Images/lena.tif'))/255;
[Y,U,V] = rgb2YUV(x);
C = FCT2D(Y);
Z = dct2(Y);
figure('Name','DCT');
subplot(131);imshow(Y);title('Imagen analizada');
subplot(132);imshow(C);title('DCT con nuestro algoritmo');
subplot(133);imshow(Z);title('DCT con la función de MatLab');
%% Compresión de imágenes con DCT
a = double(imread('Images/lena.tif'))/255;
[Y,U,V] = rgb2YUV(a);
b = 0.1;    %Porcentaje de coeficientes que se quiere conservar
[Z,C,b] = dctComp(Y,b);
figure;
subplot(221);imshow(Y);
subplot(223);imshow(dct2(Y));
subplot(222);imshow(Z);
subplot(224);imshow(C);
fprintf('\nEl procentaje real de coeficientes conservados de la DCT es de %f \n',b);
%% Eliminación de ruido de una imagen
% Imagen ruidosa1
im = double(imread('Images/ruidosa1.jpg'))/255;
% Eliminamos el ruido interferente
r = 0.5;    % radio del círculo de bajas frecuencias
th = 0.0004;   % amplitud relativa del umbral de detección   
[y] = denoise(im,th,r);
figure;
subplot(121);imshow(im);
subplot(122);imshow(y);
% Imagen ruidosa2
im = double(imread('Images/ruidosa2.jpg'))/255;
r = 0.1;
th = 2e-3;
[y,X,~,H] = denoise(im,th,r);
figure;
subplot(121);imshow(im);
subplot(122);imshow(y);
[wy,wx] = freqspace(size(H),'meshgrid');
figure;
subplot(131);mesh(wx,wy,log10(1 + abs(X)));
subplot(132);mesh(wx,wy,H);
subplot(133);mesh(wx,wy,log10(1 + abs(fftshift(fft2(y)))));