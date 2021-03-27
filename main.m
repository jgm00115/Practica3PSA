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
%% Definición de LPF y HPF FIR con método del enventanado
msg = {'Jaime García Martínez','Doble Grado Ingeniería Teleco. y Telema','EPS Linares'};
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
% Filtramos la componente de Luminancia de la imagen y volvemos a convertir
% a RGB
Z = filter2(h,Y);
FZ_abs = log10(1 + fftshift(abs(fft2(Z))));
y = YUV2rgb(Z,U,V);
% Representamos resultados
[H1D,w] = freqz(B,1);
H1D = abs(H1D);
% Respuestas en frecuencia de los filtros
figure('Name','LPF');
subplot(121);plot(w/pi,H1D);title('Respuesta en frecuencia 1D');
xlabel('Frecuencia normalizada ($\frac{\omega}{\pi}$)','Interpreter','latex');
ylabel('Magnitud');grid on;
subplot(122);freqz2(h);title('Respuesta en frecuencia 2D');
annotation('textbox',[.82,.8,.2,.2],'String',msg,'FitBoxToText','on');
% Imágenes y espectros
figure('Name','Imspctrm');
subplot(231);imshow(x);title('Imagen original');
subplot(232);imshow(h,[]);title('Respuesta impulsiva');
subplot(233);imshow(y);title('Imagen filtrada');
subplot(234);imshow(FY_abs,[]);title('log_{10}(1 + |FFT(Y)|)');
subplot(235);imshow(log10(1 + fftshift(abs(fft2(h)))),[]);title('log_{10}(1 + |FFT(h)|)');
subplot(236);imshow(FZ_abs,[]);title('log_{10}(1 + |FFT(Z)|)');
annotation('textbox',[.82,.8,.2,.2],'String',msg,'FitBoxToText','on');
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
y = YUV2rgb(Z,U,V);
% Representamos resultados
[H1D,w] = freqz(B,1);
H1D = abs(H1D);
% Respuestas en frecuencia de los filtros
figure('Name','HPF');
subplot(121);plot(w/pi,H1D);title('Respuesta en frecuencia 1D');
xlabel('Frecuencia normalizada ($\frac{\omega}{\pi}$)','Interpreter','latex');
ylabel('Magnitud');grid on;
subplot(122);freqz2(h);title('Respuesta en frecuencia 2D');
annotation('textbox',[.82,.8,.2,.2],'String',msg,'FitBoxToText','on');
% Imágenes y espectros
figure('Name','Imspctrm');
subplot(231);imshow(Y);title('Luminancia imagen original');
subplot(232);imshow(h,[]);title('Respuesta impulsiva');
subplot(233);imshow(Z,[]);title('Luminancia imagen filtrada');
subplot(234);imshow(FY_abs,[]);title('log_{10}(1 + |FFT(Y)|)');
subplot(235);imshow(log10(1 + fftshift(abs(fft2(h)))),[]);title('log_{10}(1 + |FFT(h)|)');
subplot(236);imshow(FZ_abs,[]);title('log_{10}(1 + |FFT(Z)|)');
annotation('textbox',[.82,.8,.2,.2],'String',msg,'FitBoxToText','on');
% Reconstrucción de imagen rgb filtrada
figure('Name','RGBfiltered');
imshow(y);title('Imagen RGB filtrada');
annotation('textbox',[.82,.8,.2,.2],'String',msg,'FitBoxToText','on');
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