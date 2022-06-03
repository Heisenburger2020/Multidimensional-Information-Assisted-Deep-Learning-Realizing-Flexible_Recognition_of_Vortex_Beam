function var = space_2D(varargin)
% 创建变量空间
% para = space('dimension1',window1,sample1,'dimension2',window2,sample2,...)
% 输入
% dimension     -   维度 (字符串)，可取'x' 、 'y'
% window        -   范围
% sample        -   采样个数
%
% 输出
% para          -   变量空间
% 如果不定义某维度，则定义该维度window = 0,sample =1

[var.x_,var.fx_]=domain(0,0);
[var.y_,var.fy_]=domain(0,0);
var.c = 299792458;
for index_var =1:3:length(varargin)
    key = varargin{index_var};
    try
        window = varargin{index_var+1};
        sample = varargin{index_var+2};
    catch
        error(['unenougth parm for: ',key])
    end
    
    switch key
        case 'x'
            [var.x_,var.fx_]=domain(window,sample);
        case 'y'
            [var.y_,var.fy_]=domain(window,sample);
        case 't'
             ;
        otherwise
            error(['undefine key : ',key])
    end
end
[var.x,var.y] = meshgrid(var.x_,var.y_);
[var.fx,var.fy] = meshgrid(var.fx_,var.fy_);
[var.theta,var.rho] = cart2pol(var.x,var.y);
var.x = gpuArray(var.x);
var.y = gpuArray(var.y);
var.fx = gpuArray(var.fx);
var.fy = gpuArray(var.fy);
var.theta = gpuArray(var.theta);
var.rho = gpuArray(var.rho);