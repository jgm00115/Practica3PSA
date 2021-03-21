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
T_abs = log10(abs(fftshift(T)));
T_angle = angle(fftshift(T));
% MatLab ya implementa una función para el cálculo de la DFT en 2D
P = fft2(Y);   
P_abs = log10(abs(fftshift(P)));
P_angle = angle(fftshift(P));
% Representación de módulo y fase en escala logarítmica
figure('Name','2D_DTF');
subplot(221);imshow(T_abs,[]);title('log_{10}(T)');set(gca,'visible','on');
subplot(223);imshow(T_angle,[]);title('Arg(T)');set(gca,'visible','on');
subplot(222);imshow(P_abs,[]);title('log_{10}(P)');set(gca,'visible','on');
subplot(224);imshow(P_angle,[]);title('Arg(P)');set(gca,'visible','on');
% Hemos representado las dos transformadas para comprobar que el resultado
% es igual.