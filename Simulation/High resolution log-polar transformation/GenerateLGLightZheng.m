function u = GenerateLGLightZheng(l, p, w0, r, theta)
   
a = sqrt(2) * r / w0;
term2 = mlaguerre(p, abs(l), a.^2);
b = abs(l);
term1 = sqrt((2*factorial(p))/(pi*factorial(p+b)));
term3 = exp(-1*l*1i*theta);
term4 = exp(-1*(a.^2)/2);
term5 = (a.^b)*((-1)^p)/(w0);
u = term1 .* term2 .* term3 .* term4 .* term5;