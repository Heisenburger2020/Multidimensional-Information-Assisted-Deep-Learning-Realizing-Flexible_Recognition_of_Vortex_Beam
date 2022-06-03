function [xf, yf, Ef] = log_polar2(E_LG)
%%
%生成LG光及相关参数
N = 600;
L = 0.1;
a=linspace(-L/5, L/5, N);     
[x,y]=meshgrid(a);                                   
w_l=532e-9;                       %波长
delta = 2 * L / N / 5;
%%
%环形相位分布展成条形
f = 5;
a = L/(10 * 2 * pi);
b = L/10;
phi=atan2(y,x); 
transforming_phase = 2 * pi * a * (y .* phi - ...
    x .* log(sqrt(x .^ 2 + y .^ 2) ./ b) + ...           
    x) ./ (w_l * f);                                %log-polar mapper
transformed_E = E_LG.*exp(1i*transforming_phase);       
%%
%相位补偿
[x, y] = meshgrid(linspace(-L/5, L/5, N), linspace(-L/5, L/5, N));
Fourier_E = ft2(transformed_E, delta);
correction_phase = -2 * pi * a * b * ...
    exp(- x / a) .* cos(y / a) ./...
    (w_l * f);                                      %mapper corrector
corrected_E =Fourier_E .* exp(1i * correction_phase);
%%
%通过透镜
final_E = ift2(corrected_E, delta);

Ef = final_E(225:375, 225:375);
[xf, yf] = meshgrid(gpuArray.linspace(-L/5, L/5, 151), gpuArray.linspace(-L/5, L/5, 151));