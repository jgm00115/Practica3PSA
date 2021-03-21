function [Y,U,V] = rgb2YUV(x)
% rgb2YUV obtiene las componentes de luminancia y crominancia de la imagen
% x, que debe estar previamente normalizada entre 0 y 1.
% INPUT:
%     x: imagen rgb
% OUTPUT:
%     Y: Luminancia
%     U: Crominancia B-Y ponderada
%     V: Crominancia R-Y ponderada
[~,~,p] = size(x);
if p ~=3
    warning('No se puede separar las componentes RGB de la imagen');
else 
%     Separamos las componentes RGB
    r = x(:,:,1);
    g = x(:,:,2);
    b = x(:,:,3);
%     Calculamos luminancia y crominancia
    Y = 0.299*r + 0.587*g + 0.114*b;
    U = 0.492*(b-Y);
    V = 0.877*(r-Y);
end


end

