 function [x2, y2, Uout] ...
 = two_step_prop(Uin, wvl, d1, d2, Dz)
 % function [x2 y2 Uout] ...
 % = two_step_prop(Uin, wvl, d1, d2, Dz)

 N = size(Uin, 1); % number of grid points
 k = 2*pi/wvl; % optical wavevector
 % source-plane coordinates
 [x1, y1] = meshgrid((-N/2 : 1 : N/2 - 1) * d1);
 % magnification
 m = d2/d1;
 % intermediate plane
 Dz1 = Dz / (1 + m); % propagation distance
 d1a = wvl * abs(Dz1) / (N * d1); % coordinates
 [x1a, y1a] = meshgrid((-N/2 : N/2-1) * d1a);
 % evaluate the Fresnel-Kirchhoff integral
 Uitm = 1 / (1i*wvl*Dz1) ...
 .* exp(1i*k/(2*Dz1) * (x1a.^2+y1a.^2)) ...
 .* ft2(Uin .* exp(1i * k/(2*Dz1) ...
 * (x1.^2 + y1.^2)), d1);
 % observation plane
 Dz2 = Dz - Dz1; % propagation distance
 % coordinates
 [x2, y2] = meshgrid((-N/2 : N/2-1) * d2);
 % evaluate the Fresnel diffraction integral
 Uout = 1 / (1i*wvl*Dz2) ...
 .* exp(1i*k/(2*Dz2) * (x2.^2+y2.^2)) ...
.* ft2(Uitm .* exp(1i * k/(2*Dz2) ...
 * (x1a.^2 + y1a.^2)), d1a);