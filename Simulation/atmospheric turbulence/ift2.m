 function g = ift2(G, delta_f)
 % function g = ift2(G, delta_f)
 N = size(G, 1);
 g = ifftshift(ifft2(ifftshift(G))) * (N * delta_f)^2;