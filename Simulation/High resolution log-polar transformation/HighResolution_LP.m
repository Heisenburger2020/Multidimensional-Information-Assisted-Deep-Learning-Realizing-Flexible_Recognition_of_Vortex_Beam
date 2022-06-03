function Field = HighResolution_LP(E)
%% units
m = 1;
cm = 1e-2;
mm = 1e-3;
um = 1e-6;
nm = 1e-9;
deg = pi/180;
N = 2048;
%% Spatial Parameters
X_num = N;
Y_num = N;
px=10*um;    %% signle pixel size
%% 
Width  = X_num*px;
Height = Y_num*px;        
var = space_2D('x',Width,X_num,'y',Height,Y_num); 

%% Light Parameters
Wavelength = 405*nm; 

LightSource = fftshift(E);


kz = 2*pi*sqrt((1./Wavelength).^2-(var.fx).^2-(var.fy).^2);
Propagate  =@(field,dis) fft2(exp(-1i*kz.*dis).*ifft2(field)); 

%% System Element
FocusLength = 100*cm;
LENS_Phase = 2*pi/Wavelength.*(var.x.^2+var.y.^2)./2./FocusLength;
%% OAM sorting system
a=1*mm;
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
Field = fftshift(Field);
