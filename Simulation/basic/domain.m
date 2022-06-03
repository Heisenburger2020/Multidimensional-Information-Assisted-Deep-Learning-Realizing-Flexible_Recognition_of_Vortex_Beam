function [t,ft]=domain(window,sample)
%构建变量空间
% [t,ft]=domain(window,sample);
% 输入
% window   -   空间/时间窗口
% sample    -   采样点数目
%
% 输出
% t         -   空间/时间变量
% ft        -   空间频率/时间频率变量

if(sample <= 1)
    t =  0;
    ft = 0;
else
    if mod(sample,2)==1
        error(['sample should be even number '])
    else
        t = linspace(-window/2,window/2,sample+1);
        t(end) = [];
        t = fftshift(t);
        ft =[0:(sample/2-1) -sample/2:-1]/window;  
    end
end
