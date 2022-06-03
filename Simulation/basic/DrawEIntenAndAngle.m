function DrawEIntenAndAngle(E, i)
%画出光强及从侧面看的图片

%I = E .* conj(E);
I = Intensity(E);

sz = [size(E)];
Nx = sz(1);
Ny = sz(2);
x = linspace(-1,1,Nx);
y = linspace(-1,1,Ny);
[X,Y]=meshgrid(x, y);    

figure(i)
subplot(1, 2, 1);
surf(X,Y,real(I))
colorbar
shading interp
colormap gray
view(0,90)
subplot(1, 2, 2);
surf(X,Y,real(I))
colorbar
shading interp
colormap gray
view(0,0)
set(gcf, 'position', [250 300 1500 500]);