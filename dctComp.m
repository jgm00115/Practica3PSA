function [Z,C,b] = dctComp(Y,p)
% dctComp aplica un simple algoritmo de compresión donde se truncarán a 0
% un porcentaje de coeficientes de la DCT de la imagen, teniendo en cuenta
% que la mayor concentración de energía se encuentra en la parte superior
% izquierda de la matriz de la transformada.
% 
% El porcentaje lo interpretaremos como el cociente entre las dos
% siguientes áreas:
%   - El área del círculo con radio r y centro en la esquina superior
%     izquierda de la matriz de la DCT,que es el número de coeficientes que
%     queremos conservar
%   - El área de la matriz MxN son los coeficientes en total de la DCT
% 
% Por lo tanto, todos los coeficientes con índices que queden fuera del
% círculo de radio r se truncarán a 0.
% INPUT:
%   Y:  imagen en escala de grises
%   p:  porcentaje de coeficientes que se quieren conservar, indicado en
%       de forma decimal [0,1]
% OUTPUT:
%   Z:  imagen resultado de la compresión
%   C:  DCT de la imagen resultado
%   b:  porcentaje real de coeficientes conservados
C = dct2(Y);
[M,N] = size(C);
% Calcularemos los índices de los coeficientes que vamos a truncar
[x,y] = meshgrid(1:N,1:M);
r2 = p*M*N*4/pi;
% Primer coeficiente en (1,1), el centro no es el (0,0)
index = (x-1).^2+(y-1).^2 > r2;
% Truncamos los coeficientes indexados
C(index) = 0;
% DCT inversa
Z = idct2(C);
% Porcentaje de coeficientes conservados
j = C ~=0;
j = sum(sum(j));
b = j/(M*N);
end

