function [x] = jpegDeco(J)
% JPEGDECO decodifica la matriz J obtenida de aplicar la función jpegCod
% INPUT:
%     J: matriz codificada de la imagen
% OUTPUT:
%     x: imagen recuperada

% El proceso es el inverso al aplicado en la codificación: 
[M,N] = size(J);
x = zeros([M,N]);
% Matriz de cuantificación
los = [16,11,10,16,24,40,51,61;
    12,12,14,19,26,58,60,55;
    14,13,16,24,40,57,69,56;
    14,17,22,29,51,87,80,62;
    18,22,37,56,68,109,103,77;
    24,35,55,64,81,104,113,92;
    49,64,78,87,103,121,120,101;
    72,92,95,98,112,100,103,99];
% Recorremos la matriz J
for fila = 1:8:M-7
    for col = 1:8:N-7
        S = J(fila:fila+7,col:col+7);
        % Multiplicamos elemento a elemento la submatriz S por la matriz de cuantificación
        S = S.*los; 
        % Realizamos la IDCT, redondeamos y sumamos 128
        s = round(idct2(S)) + 128;
        x(fila:fila+7,col:col+7) = s;
    end
end
x = uint8(x);
end

