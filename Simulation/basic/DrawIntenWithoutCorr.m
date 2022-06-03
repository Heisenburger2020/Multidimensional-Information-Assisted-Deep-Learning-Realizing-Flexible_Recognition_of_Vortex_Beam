function DrawIntenWithoutCorr(I_LG, i)

% 不显示坐标的带标签的绘图
% 绘制朴素的光强分布图像
I_LG = Intensity(I_LG);
sz = [size(I_LG)];
Nx = sz(1);
Ny = sz(2);
x = linspace(-1,1,Nx);
y = linspace(-1,1,Ny);
[X,Y]=meshgrid(x, y);    


figure(i)
surf(X,Y,real(I_LG))
colormap gray
axis off
shading interp
view(0,90)