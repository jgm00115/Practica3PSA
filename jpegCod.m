function J = jpegCod(x)
% JPEGCOD aplica una técnica de compresión de imagen similar al standard JPEG
% haciendo uso de la DCT en subbloques de 8x8.
% INPUT: 
%     x: matriz de entrada con valores uint8 (8 bits)
% OUTPUT:
%     J: matriz x codificada 

% Restamos 128 a los valores de la matriz para que el rango dinámico quede
% entre [-128, 127]
x = double(x) -128;
% Definimos la matriz de cuantificación digital de Losheller
los = [16,11,10,16,24,40,51,61;
    12,12,14,19,26,58,60,55;
    14,13,16,24,40,57,69,56;
    14,17,22,29,51,87,80,62;
    18,22,37,56,68,109,103,77;
    24,35,55,64,81,104,113,92;
    49,64,78,87,103,121,120,101;
    72,92,95,98,112,100,103,99];
% Obtenemos tamaño de la matriz y añadimos padding si es necesario
[M,N] = size(x);
P = ceil(M/8)*8;
Q = ceil(N/8)*8;
g = zeros([P,Q]);
g(1:M,1:N) = x; %Trabajaremos con la matriz g
% Reservamos espacio para la matriz de salida
J = zeros([P Q]);
% Recorremos la matriz g dividiéndola en submatrices de 8x8
for fila = 1:8:P-7
    for col = 1:8:Q-7
        s = g(fila:fila+7,col:col+7);
        % DCT y redondeamos los coeficientes al entero más próximo
        S = round(dct(s));        
        % Dividimos los coeficientes de la DCT entre los de la matriz
        % losheller y volvemos a redondear
        J(fila:fila+7,col:col+7) = round(S./los);
    end
end
end


