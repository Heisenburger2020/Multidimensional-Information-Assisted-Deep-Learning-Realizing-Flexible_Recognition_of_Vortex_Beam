clc
clear
tic
%%
%����LG�⼰��ز���
N = 400;
L = 0.1;
a=gpuArray.linspace(-L/5, L/5, N);     
[x,y]=meshgrid(a);                                   
p=0;                                 %����������        
l=2;                                %������
z=200;                              %�������
w_l=532e-9;                       %����
r0 = 10;                           %������ɳ���
w0 = 0.02;
delta = 2 * L / N;

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
    x) ./ (w_l * f);

transformed_E = evolution( E_LG.*exp(1i*transforming_phase), ...
    x, y, f, L/5, w_l, N);

[x, y] = meshgrid(gpuArray.linspace(-L/5, L/5, N), gpuArray.linspace(-L/5, L/5, N));
r = sqrt(x .^ 2 + y .^ 2);

DrawsubplotE2(transformed_E, 2)
%%
%��һ��ͨ��͸��
k=2*pi/w_l;
E_len=exp(-1i * k * r.^2 ./ (2*f));

Fourier_E = evolution( transformed_E .* E_len, ...
    x, y, f, L/5, w_l, N);

[x, y] = meshgrid(gpuArray.linspace(-L/5, L/5, N), gpuArray.linspace(-L/5, L/5, N));

DrawsubplotE2(Fourier_E, 3)
%%
%��λ����
%                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
correction_phase = -2 * pi * a * b * ...
    exp(- x / a) .* cos(y / a) ./...
    (w_l * f);

corrected_E = evolution( Fourier_E .* exp(1i * correction_phase), ...
    x, y, f, L/5, w_l, N);

DrawsubplotE2(corrected_E, 4)
%%
%ͨ��͸��
N = 200;
final_E = evolution( corrected_E .* E_len, ...
    x, y, f, L/20, w_l, N);
[x, y] = meshgrid(gpuArray.linspace(-L/10, L/10, N), gpuArray.linspace(-L/10, L/10, N));
DrawsubplotE2angle(final_E, x, y, 5)
DrawsubplotE2(final_E, 6)
toc