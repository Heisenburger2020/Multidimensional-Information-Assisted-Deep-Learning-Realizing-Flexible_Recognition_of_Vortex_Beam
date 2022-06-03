clc
clear
tic
%%
%����LG�⼰��ز���
N = 600;
L = 0.1;
a=linspace(-L/5, L/5, N);     
[x,y]=meshgrid(a);                                   
p=0;                                 %����������        
l=1;                                %������
z=0;                              %�������
w_l=532e-9;                       %����
r0 = 10;                           %������ɳ���
w0 = 0.02;
delta = 2 * L / N / 5;

E_LG = GenerateLGLight(l, p, w0, L, N);   

DrawsubplotE2(E_LG, 1)
%%
%������λ�ֲ�չ������
f = 5;
a = L/(10 * 2 * pi);
b = L/10;
phi=atan2(y,x); 
transforming_phase = 2 * pi * a * (y .* phi - ...
    x .* log(sqrt(x .^ 2 + y .^ 2) ./ b) + ...           
    x) ./ (w_l * f);                                %log-polar mapper
transformed_E = E_LG.*exp(1i*transforming_phase);            

DrawsubplotE2(transformed_E, 2)
%%
%��λ����
[x, y] = meshgrid(linspace(-L/5, L/5, N), linspace(-L/5, L/5, N));

Fourier_E = ft2(transformed_E, delta);
DrawsubplotE2(Fourier_E, 3)
correction_phase = -2 * pi * a * b * ...
    exp(- x / a) .* cos(y / a) ./...
    (w_l * f);                                      %mapper corrector
corrected_E =Fourier_E .* exp(1i * correction_phase);

DrawsubplotE2(corrected_E, 4)
%%
%ͨ��͸��

final_E = ift2(corrected_E, delta);

[x, y] = meshgrid(linspace(-L/5, L/5, N), linspace(-L/5, L/5, N));
DrawsubplotE2angle(final_E, x, y, 5)
DrawsubplotE2(final_E, 6)
final_E2 = final_E(225:375, 225:375);
[x, y] = meshgrid(gpuArray.linspace(-L/5, L/5, 101), gpuArray.linspace(-L/5, L/5, 101));
DrawsubplotE2(final_E2, 6)
toc