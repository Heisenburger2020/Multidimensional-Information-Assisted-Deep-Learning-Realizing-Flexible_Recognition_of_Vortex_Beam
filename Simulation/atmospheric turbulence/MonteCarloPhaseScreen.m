function phi = MonteCarloPhaseScreen(r0, N)
%r0 coherence diameter [m]
%N number of grid points per side
D = 2; % length of one side of square phase screen [m]
L0 = 100; % outer scale [m]
l0 = 0.01;% inner scale [m]
delta = D/N; % grid spacing [m]
 % spatial grid
% generate a random draw of an atmospheric phase screen
[phz_lo, phz_hi] = ft_sh_phase_screen(r0, N, delta, L0, l0);
phi = phz_lo + phz_hi;