function C = FCT2D(x)
% FCT2D calcula la DCT en 2 dimensiones de la matriz recibida como
% parámetro de entrada.
% INPUT:
%     x: Matriz de entrada
% OUTPUT:
%     C: DCT(x)
[M,N] = size(x);
C = zeros(M,N);
% Obtenemos la DCT de las filas de la matriz x
for n = 1:M
    C(n,:) = FCT(x(n,:));
end
% Calculamos la DCT de las columnas de la matriz resultante de la operación
% anterior
for n = 1:N
    C(:,n) = FCT(C(:,n));
end
end

