function S = CountingAngularSpectrum(I_in)

S = gpuArray(zeros(1,9));
M = sum(I_in, 2);
for i = -4:4
    y = 6*i+51;
    for j = y-3:y+3
        S(i+5) = S(i+5) + M(j);
    end
end