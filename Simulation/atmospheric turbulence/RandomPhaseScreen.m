%模拟LG光束在湍流传播
clc                                             
clear                                      

Cn2=2e-13;                                    %   湍流结构常数
lamda=0.6328e-6;                                %   波长
k=2*pi/lamda;                                   %   波数
w0=1.0e-3;                                     %   束腰半径
z=150;                                         %   设置传输距离
deltz=15;                                      %   设置相位屏间距
L=3.0e-1;                                        %   屏的大小
caiyang=512; 
delta=L/caiyang;
N=512; 
dfx=1/(N*delta);
dfy=1/(N*delta);
buchang=L/caiyang;
C=2*pi/L;
f=3.0e+8./lamda;
k=2*pi/lamda;
[x,y]=meshgrid(-L/2:buchang:L/2-buchang,-L/2:buchang:L/2-buchang);
[theta,r]=cart2pol(x,y);
%  拉盖尔涡旋光束
m=3;p=0;                                                                                     %确定光束的阶数m，模数p
u0=1/w0.*sqrt(2/pi)*(sqrt(2)*r/w0).^abs(m).*exp(-r.^2/w0^2).*exp(-1i*m*theta)...
    +1/w0.*sqrt(2/pi)*(sqrt(2)*r/w0).^abs(m).*exp(-r.^2/w0^2).*exp(1i*m*theta);       %光场表达式
  I=u0.*conj(u0);
  Iu=I/max(max(I));
[x1,y1]=meshgrid(-caiyang/2:1:caiyang/2-1,-caiyang/2:1:caiyang/2-1);       
l0=0.01;
L0=1;
km = 5.92/l0;
k0 = 1/L0;
kr=sqrt((2*pi*x1/L).^2+(2*pi*y1/L).^2);      %k为三维空间的波数，kr=(kx2+ky2)的1/2次方
pusai=2*pi*k.^2*0.033*Cn2*deltz * exp(-(kr/km).^2) ./ (kr.^2 + k0^2).^(11/6);
[m n]=find(pusai==inf);

pusai=fftshift(pusai);     %傅里叶反变换
bushu=z/deltz;
h=waitbar(0,'计算中，请等待...');
 %%随机相位屏
for l=1:bushu;  
    
    ra=randn(caiyang,caiyang);         %零均值，单位方差的高斯随机数   
    rb=randn(caiyang,caiyang);
    rr=ra+i.*rb;

    ping=sqrt(C)*caiyang^2*ifft2(rr.*sqrt(pusai));           
    ping=real(ping); 
    figure(1);
    mesh(ping);
    figure(2);
    imshow(mat2gray(ping)); 
    Eu1=fft2(u0.*exp(i.*ping));
    Eu1=fftshift(Eu1);
 %% 自由空间衍射
  fx=(-N/2:N/2-1)*dfx;
  fy=(-N/2:N/2-1)*dfy; 
  [Fx,Fy]=meshgrid(fx,fy);
  H=exp(1i*k*deltz*sqrt(ones(N,N)-(lamda*Fx).^2-(lamda*Fy).^2));% 传递函数
    %pfac = fftshift(H); 
    u1=Eu1.*H;         %光场表达式
    u1=ifftshift(u1);
    u2=ifft2(u1);
    u0=u2;
    shijian=num2str(l/bushu*100);
    shijian=num2str(fix(l/bushu*100));
    waitbar(l/bushu,h,['请等待，已完成',shijian,'%']);
end
%close(h);
I=u0.*conj(u0);
Iu=I/max(max(I));
figure(3);
mesh(x,y,Iu);
xlabel('平面X坐标/m');
ylabel('平面Y坐标/m');
zlabel('光强');
shading interp
figure(4)
pcolor(x,y,Iu);
%imshow(mat2gray(Iu))
xlabel('平面X坐标/m');
ylabel('平面Y坐标/m');
shading interp
%figure(4)
%imshow(abs(u2).^2,[]);
%w=32;  %omiga 目标物角速度
%duomo=0.14.*(exp(-i.*theta)+exp(-2i.*theta)+exp(-i*3.*theta)...
    %+exp(i.*theta)+exp(2i.*theta)+exp(i*3.*theta));%到底该怎么写调制函数呢？
%u3=u2.*duomo;
u3=u0;
for l=1:bushu;
    %% 自由空间衍射
    fx=(-N/2:N/2-1)*dfx;
    fy=(-N/2:N/2-1)*dfy; 
    [Fx,Fy]=meshgrid(fx,fy);
    H=exp(1i*k*deltz*sqrt(ones(N,N)-(lamda*Fx).^2-(lamda*Fy).^2));  % 传递函数
   %pfac = fftshift(H); 
    u4=fft2(u3);
    Eu4=fftshift(u4);   
    u4=Eu4.*H;         %光场表达式
    u4=ifftshift(u4);
    u4=ifft2(u4);
    
    shijian=num2str(l/bushu*100);
    shijian=num2str(fix(l/bushu*100));
    waitbar(l/bushu,h,['请等待，已完成',shijian,'%']);
    
    ra=randn(caiyang,caiyang);         %零均值，单位方差的高斯随机数   
    rb=randn(caiyang,caiyang);
    rr=ra+i.*rb;

    ping=sqrt(C)*caiyang^2*ifft2(rr.*sqrt(pusai));           
    ping=real(ping); 
    figure(5);
    mesh(ping);
    figure(6);
    imshow(mat2gray(ping));
    u5=u4.*exp(i.*ping);
    u3=u5;
end

I=u3.*conj(u3);
Iu=I/max(max(I));
figure(7);
mesh(x,y,Iu);
xlabel('平面X坐标/m');
ylabel('平面Y坐标/m');
zlabel('光强');
figure(8)
pcolor(x,y,Iu);
%imshow(mat2gray(Iu))
xlabel('平面X坐标/m');
ylabel('平面Y坐标/m');
shading interp

input_E=u0;
AS=angularspectrum_2(input_E,x,y,10)
hold on;

input_E=u3;
AS=angularspectrum_2(input_E,x,y,10)
hold on;

