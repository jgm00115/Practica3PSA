function [y,X,Y,H] = denoise(im,th,r)
% DENOISE aplica un algoritmo simple de reducción de ruido a una imagen
% analizando el espectro de la DFT en 2D
% INPUT:
%     im: imagen que se va a procesar.
%     th: umbral de detección de picos de ruido con respecto a la amplitud
%     máxima del espectro de la imagen.
%     r: radio del círculo que contiene las bajas frecuencias de la señal,
%     con valor entre 0 y 1. Si r es pequeño, es posible que eliminemos
%     picos de bajas frecuencias. Si r es grande, es posible que no se
%     eliminen picos de ruido.
% OUTPUT:
%     y: imagen de salida
%     X: espectro imagen de entrada
%     Y: espectro de la imagen de salida
%     H: respuesta en frecuencia del filtro aplicado

% Calculamos dimensiones, amplitud máxima y espectro de la imagen de entrada
X = fftshift(fft2(im));
[M,N] = size(X);
A = max(abs(X(:)));
% Buscamos los índices de los picos de amplitud del espectro de la señal.
% Para ello, obviaremos las bajas frecuencias de la imagen
[x,y] = freqspace([M,N],'meshgrid');
rv = sqrt(x.^2 + y.^2);
% Hacemos una copia del espectro de la imagen a la que le hemos suprimido
% las bajas frecuencias 
G = abs(X);
G(rv < r) = 0;
% Asumiremos que todos los picos del espectro G son ruido. 
ind = G > th*A;
% Construimos la respuesta en frecuencia del filtro que queremos obtener 
H = ones([M,N]);
H(ind) = 0;
% Obtenemos la convolución circular (que no lineal) 
% entre la respuesta del filtro y la imagen.
Y = fftshift(X.*H);
y = ifft2(Y);
% Representamos resultados
figure;
subplot(131);
imshow(log10(1 + abs(X)),[]);title('Espectro imagen original');
subplot(132);
imshow(log10(1 + abs(H)),[]);title('Respuesta en frecuencia del filtro');
subplot(133);
imshow(log10(1 + fftshift(abs(Y))),[]);title('Espectro imagen resultante');
end