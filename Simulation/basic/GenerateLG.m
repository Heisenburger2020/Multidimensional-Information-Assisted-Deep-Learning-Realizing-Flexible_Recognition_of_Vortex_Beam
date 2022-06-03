function [ E_LG ] = GenerateLG( L, w0, t, l, p, z)
%GenerateLG ����LG���������


shift = 0;
aphi = 0;
a=linspace(-L+shift, L+shift, t);
[x,y]=meshgrid(a);

r = sqrt(x.^2 + y.^2);
phi = atan2(y, x);                  
w_l = 532e-9;                         %����
W0s = w0;                           %�����뾶
z_r = (2*pi/w_l)*(W0s^2)/2;           
C = sqrt(2/pi/factorial(abs(l)));
Wz = W0s*sqrt((z^2+z_r^2)/z_r^2);
Cxi = r./Wz;
F = W0s*(sqrt(2).*Cxi).^abs(l).*exp(-Cxi.^2)./Wz;
%LG_pl = laguerreL(p, abs(l), 2*Cxi.^2);
LG_pl = 1;
Phase_Genal = exp(1i.*(l.*phi+2*pi/w_l.*r.^2*z/2/(z^2+z_r^2)));
Phase_Gouy = exp(-1i*((2*p+abs(l)+1)*atan(z/z_r)));
Phase = Phase_Genal.*Phase_Gouy;

E_LG=C.*F.*LG_pl.*Phase.*exp(1i*aphi);            %�����

I_LG = E_LG.*conj(E_LG);              %��ǿ
% J = sum(sum(I_LG))*(2*L/t)*(2*L/t)
% E_LG = E_LG ./ sqrt(J);

end

