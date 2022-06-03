function HighResolution_training_set(Am)
%% units
m = 1;
cm = 1e-2;
mm = 1e-3;
um = 1e-6;
nm = 1e-9;
deg = pi/180;

%% Spatial Parameters
X_num = 2048;
Y_num = 2048;
px=10*um;    %% signle pixel size
%% 
Width  = X_num*px;
Height = Y_num*px;        
var = space_2D('x',Width,X_num,'y',Height,Y_num); 

%% Light Parameters
Wavelength = 405*nm; 
%%
% % 5个阶数的时候
% E1 = Am(1) * GenerateLGLightZheng(-2, 0, 1.5*mm, var.rho, var.theta);
% E2 = Am(2) * GenerateLGLightZheng(-1, 0, 1.5*mm, var.rho, var.theta);
% E3 = Am(3) * GenerateLGLightZheng(0, 0, 1.5*mm, var.rho, var.theta);
% E4 = Am(4) * GenerateLGLightZheng(1, 0, 1.5*mm, var.rho, var.theta);
% E5 = Am(5) * GenerateLGLightZheng(2, 0, 1.5*mm, var.rho, var.theta);
% LightSource = E5 + E4 + E1 + E2 + E3;

%DeepLearningDraw(LightSource .* conj(LightSource))

%%
% % 7个阶数的时候
% E1 = Am(1) * GenerateLGLightZheng(-3, 0, 1.5*mm, var.rho, var.theta);
% E2 = Am(2) * GenerateLGLightZheng(-2, 0, 1.5*mm, var.rho, var.theta);
% E3 = Am(3) * GenerateLGLightZheng(-1, 0, 1.5*mm, var.rho, var.theta);
% E4 = Am(4) * GenerateLGLightZheng(0, 0, 1.5*mm, var.rho, var.theta);
% E5 = Am(5) * GenerateLGLightZheng(1, 0, 1.5*mm, var.rho, var.theta);
% E6 = Am(6) * GenerateLGLightZheng(2, 0, 1.5*mm, var.rho, var.theta);
% E7 = Am(7) * GenerateLGLightZheng(3, 0, 1.5*mm, var.rho, var.theta);
% LightSource = E5 + E4 + E1 + E2 + E3 + E6 + E7;

%%
% 9个阶数的时候
E1 = Am(1) * GenerateLGLightZheng(-4, 0, 1.5*mm, var.rho, var.theta);
E2 = Am(2) * GenerateLGLightZheng(-3, 0, 1.5*mm, var.rho, var.theta);
E3 = Am(3) * GenerateLGLightZheng(-2, 0, 1.5*mm, var.rho, var.theta);
E4 = Am(4) * GenerateLGLightZheng(-1, 0, 1.5*mm, var.rho, var.theta);
E5 = Am(5) * GenerateLGLightZheng(0, 0, 1.5*mm, var.rho, var.theta);
E6 = Am(6) * GenerateLGLightZheng(1, 0, 1.5*mm, var.rho, var.theta);
E7 = Am(7) * GenerateLGLightZheng(2, 0, 1.5*mm, var.rho, var.theta);
E8 = Am(8) * GenerateLGLightZheng(3, 0, 1.5*mm, var.rho, var.theta);
E9 = Am(9) * GenerateLGLightZheng(4, 0, 1.5*mm, var.rho, var.theta);
LightSource = E5 + E4 + E1 + E2 + E3 + E6 + E7 + E8 + E9;




%%
kz = 2*pi*sqrt((1./Wavelength).^2-(var.fx).^2-(var.fy).^2);
Propagate  =@(field,dis) fft2(exp(-1i*kz.*dis).*ifft2(field)); 

%% System Element
FocusLength = 100*cm;
LENS_Phase = 2*pi/Wavelength.*(var.x.^2+var.y.^2)./2./FocusLength;
%% OAM sorting system
a=0.4*mm;
b=3*mm;

P1 = 2*pi*a./Wavelength./FocusLength*(var.x.*angle(-var.y+1i*var.x)+ var.y.*log(1./b.*sqrt(var.x.^2+var.y.^2))-var.y+0.5/a*(var.x.^2+var.y.^2));
P1(isnan(P1))=0;

m_ = [-1 0 1];
b_=[1.329 1 1.329];
a_ = [-pi/2 0 -pi/2];
fai_ = [0 pi*(3/2) 0];

theta=2*pi*a./FocusLength;
add_term_fz = zeros(size(P1));
add_term_fm = zeros(size(P1));
Fai_2  = zeros(size(P1));
for num = 1:length(m_)
  m_val = m_(num);
  b_val = b_(num);
  a_val = a_(num);
  fai_val = fai_(num);
  add_term_fz = add_term_fz+b_val.*sin(2.*pi.*theta./Wavelength.*m_val.*var.x+a_val);
  add_term_fm = add_term_fm+b_val.*cos(2.*pi.*theta./Wavelength.*m_val.*var.x+a_val); 
  
  Fai_2 = Fai_2+rectpuls((var.x-m_val*theta*FocusLength)./(theta*FocusLength)).*(-2*pi*a.*b./Wavelength./FocusLength.*exp(-(var.y)/a).*cos(var.x/a)+fai_val);
end
fai_part1 = angle(1i*add_term_fz+add_term_fm);

P1 = P1+fai_part1;

P2 =  Fai_2 -2*pi*a.*b./Wavelength./FocusLength.*(-1/a/b*(var.x.^2+(var.y).^2));

DrawsubplotE2angle(P2, 2)
%% 
ELM{1}.PhaseModulation = P1;
ELM{1}.AmplitudeModulation = 1;
ELM{1}.Dis=FocusLength;

% 
ELM{2}.PhaseModulation = P2;
ELM{2}.AmplitudeModulation = 1;
ELM{2}.Dis=1*FocusLength;

Field = LightSource;
for index = 1:length(ELM)
    TEMP = ELM{index};
    Field = Propagate(TEMP.AmplitudeModulation.*exp(1i*TEMP.PhaseModulation).*Field,TEMP.Dis);
end
x = linspace(-1,1,X_num);
[x, y] = meshgrid(x);
% DrawsubplotE2angle(fftshift(rot90(Field)), x, y, 2)
% set(gcf, 'position', [250 300 1500 500]);
I = resize(Intensity(fftshift(rot90(Field))) / 10^7 * 2, 200);
max(max(I))
%imshow(I,[0,10])
