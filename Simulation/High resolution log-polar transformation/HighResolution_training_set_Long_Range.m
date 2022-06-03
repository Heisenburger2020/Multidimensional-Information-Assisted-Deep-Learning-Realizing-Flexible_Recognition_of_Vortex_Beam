function [Field1, Field2, Field3] = HighResolution_training_set_Long_Range(Am)
%%
N = 2048;
L = 0.15;
w0 = 0.03;
E_LG = zeros(N);
%%
% Generate Light Beam with Angular Momentum
for i = 1:length(Am)
    E_LG = E_LG + Am(i) * GenerateLGLight(i-14, 0, w0, L, N);
end
%%
% Spiral Phase
x = gpuArray.linspace(-N/2,N/2,N);
[x, y] = meshgrid(x);
Phase_SPP1 = exp(9*1i*arctan2(y, x,1));
Phase_SPP2 = exp(-9*1i*arctan2(y, x,1));
%% 
% Get angular spectrum information
% maxI: 3:1.06e5   2:2.3e5  1:8.9e4
LightSource = E_LG;

n = 150;

Field2 = LightSource;
Field2 = HighResolution_LP(Field2);
%DrawIntenWithoutCorr(Intensity(resize(Field2,n)),2)

Field1 = LightSource .* Phase_SPP1;
Field1 = HighResolution_LP(Field1);
%DrawIntenWithoutCorr(Intensity(resize(Field1,n)),1)

Field3 = LightSource .* Phase_SPP2;
Field3 = HighResolution_LP(Field3);
%DrawIntenWithoutCorr(Intensity(resize(Field3,n)),3)

%%
% x = linspace(-1,1,X_num);
% [x, y] = meshgrid(x);
% set(gcf, 'position', [250 300 1500 500]);
% I = resize(Intensity(fftshift(rot90(Field))) / 10^7 * 2, 200);
% imshow(I,[0,10])
