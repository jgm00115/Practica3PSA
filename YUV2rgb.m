function x = YUV2rgb(Y,U,V)
% YUV2rgb calcula las componentes rgb de la imagen conocida la luminancia y
% crominancia.
% INPUT:
%     Y: luminancia
%     U: B-Y ponderada
%     V: R-Y ponderada
% OUTPUT:
%     x: imagen RGB
% Calculamos componentes rgb
r = V/0.877 + Y;
b = U/0.492 + Y;
g = (Y - 0.299*r - 0.114*b)/0.587;
% Confeccionamos la imagen RGB
x = zeros([size(r) 3]);
x(:,:,1) = r;
x(:,:,2) = g;
x(:,:,3) = b;
end

