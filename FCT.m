function C = FCT(x)
% FCT obtiene la DCT de la señal de entrada a través de la FFT de una
% secuencia del doble de muestras compuesta por la señal de entrada y 
% su inversión temporal desplazada, según el método de Makhoul.
% INPUT:
%     x:    señal de entrada
% OUTPUT:
%     C:    DCT(x)
N = length(x);
% Definimos la secuencia v de 2N puntos
v = zeros(2*N,1);
% Los primeros N puntos se corresponden con la secuencia x
v(1:N) = x;
% Los N siguientes puntos se corresponden con la secuencia x invertida
v(N+1:end) = x(end:-1:1);
% Calculamos la FFT de v y desechamos todo salvo las primeras N muestras
V = fft(v);
V = V(1:N);
% Definimos los pesos correspondientes a cada coeficiente
w = [sqrt(1/(4*N));sqrt(1/(2*N))*ones(N-1,1)];
% Obtenemos la DCT multiplicando los coeficientes de la FFT anteriormente
% seleccionados por los pesos (w) y aplicando un desplazamiento circular de
% media muestra teniendo en cuenta que hemos analizado una secuencia de 2N
% muestras
k = (0:N-1)';
C = w.*real(V.*exp((-j*pi*k)/(2*N)));
end

