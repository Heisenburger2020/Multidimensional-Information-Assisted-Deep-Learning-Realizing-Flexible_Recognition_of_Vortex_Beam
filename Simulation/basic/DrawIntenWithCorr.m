function DrawIntenWithCorr(I_LG, x, y, i)

% 显示坐标地绘图
% I为光强分布
% x为光强分布的x坐标
% y为光强分布的y坐标
% i为图片的标号

J = max(max(I_LG));
I_LG = I_LG / J;

figure(i)
surf(x,y,real(I_LG))
colorbar
shading interp
colormap copper
view(0,90)