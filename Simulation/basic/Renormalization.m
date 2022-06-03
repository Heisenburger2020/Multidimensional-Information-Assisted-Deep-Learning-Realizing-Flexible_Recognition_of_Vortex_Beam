function E_out = Renormalization(E)
I = Intensity(E);
E_out = E ./ max(max(I));