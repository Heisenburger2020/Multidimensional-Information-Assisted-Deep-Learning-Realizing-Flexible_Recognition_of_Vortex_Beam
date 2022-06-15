function Eout = GenerateAT3(Ein, N, L, r0, z, lambda, n1, n2)
% n1为总的传播epoch
% n2为湍流相位屏次数
L0 = 50;
l0 =  0.0003;
delta = 2 * L / N;

% 通过湍流相位屏之前传播的距离
if (n1-n2) > 0
    for i = 1:(n1-n2)
        [~, ~, Ein] = ang_spec_prop(Ein, lambda, delta, delta, z);
    end
end

%通过湍流相位屏
phz = ft_phase_screen(r0, N, delta, L0, l0);
E = Ein .* exp(1i * phz);
[~, ~, E] = ang_spec_prop(E, lambda, delta, delta, z);
if n2 > 1
    for i = 1:n2-1
        phz = ft_phase_screen(r0, N, delta, L0, l0);
        E = E .* exp(1i * phz);
        [~, ~, E] = ang_spec_prop(E, lambda, delta, delta, z);
    end
end
Eout = E;