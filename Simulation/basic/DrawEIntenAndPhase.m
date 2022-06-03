function DrawEIntenAndPhase(E, i)

% 画带标号的相位及光强分布图
% E为电磁场复振幅
% 为图片标号

phase = angle(E);
I = E .* conj(E);
sz = [size(E)];
Nx = sz(1);
Ny = sz(2);
x = linspace(-1,1,Nx);
y = linspace(-1,1,Ny);
[X,Y]=meshgrid(x, y);    

figure(i)
subplot(1, 2, 1);
surf(X,Y,real(I))
axis off
colorbar
shading interp
colormap copper
view(0,90)
subplot(1, 2, 2);
surf(X,Y,phase)
axis off
colorbar
shading interp
colormap copper
view(0,90)
set(gcf, 'position', [250 300 1500 500]);

