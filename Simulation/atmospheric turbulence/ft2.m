 function G = ft2(g, delta)
 % function G = ft2(g, delta)
 G = fftshift(fft2(fftshift(g))) * delta^2;