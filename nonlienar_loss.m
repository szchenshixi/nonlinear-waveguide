I_0 = 100 * 1e11; % 10 MW/cm2 = 1e11W/um2 -> 157mW for 1.57um2

alpha = 100;    % 100dB/m
k_0 = 2*pi/1550e-9;     
n_2 = 6e-18;
belta = 5e-12;
L = 0:1e-6:1e-2;
L_eff = (1-exp(-alpha*L))/alpha;
I = (I_0 * exp(-alpha*L))./(1 + belta * I_0 * L_eff);
I = I./I_0;
I_log = 10*log(I);
subplot(2,1,1);
plot(L, I, "r");
xlabel("Propagation length (m)")
ylabel("Nomalized itensity")
subplot(2,1,2);
plot(L, I_log);
xlabel("Propagation length (m)")
ylabel("Nomalized itensity (dB)")
