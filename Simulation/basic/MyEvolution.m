function [ envolved_E ] = evolution2( input_E, x0, y0, z, L, lambda, N)
%   evolution 光场演化函数
%   input_E 输入光场复振幅
%   x0，y0 输入光场x,y坐标
%   input_E，x0，y0维度相同
%   光斑半径为输入平面半径1/5时，采样点不少于500*500，可以保证较快的速度和计算精度
%   z 演化距离
%   L 计算平面半径
%   L << z时计算有有较高精度
%   lamda 波长
%   N 解算精度
%   计算过程中输出i显示计算进度，i=N时计算完成
%   envolved_E 输出光场复振幅


Nx = N;   %x方向解算精度
Ny = N;   %y方向计算精度
k = (2 * pi) / lambda;     %波矢

x = gpuArray.linspace(-L, L, Nx );
y = gpuArray.linspace(-L, L, Ny);
envolved_E = zeros(Ny, Nx, 'gpuArray');

general_phase = 1i ./ (lambda .* z);
parfor i = 1 : Ny
    i
    for j = 1 : Nx
        phase_map = exp(1i .* k .* sqrt((x(j) - x0).^2 + (y(i) - y0).^2 + z^2));
        propagator = input_E .* phase_map;
        envolved_E(i, j) = sum(sum(propagator));
    end
end
envolved_E = general_phase .* envolved_E  * 4 * x0(1, 1)^2 ./ length(x0)^2;
end

