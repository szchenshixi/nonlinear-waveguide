%clc
%clear
%close all

settings = 4;  % 0: Raman gain and nonlinear optical absorption ...
% 1: Four-wave mixing and nonlinear losses ...
%    Thick waveguide
% 2: Nano-waveguide
% 4: The thick waveguide w1th experimental results
% 5: A testing case for the model in C++
size__ = 27;
nonlinearLoss_dB = zeros(1,size__);
for dBm = 0:0 + size__
    switch (settings)
        case 0
            modelPara_0;
        case 1
            modelPara_1;
            pwr0_W = 10^(dBm/10) * 1e-3;
            intensity0 = pwr0_W / Aeff;
        case 2
            modelPara_2;
            pwr0_W = 10^(dBm/10) * 1e-3;
            intensity0 = pwr0_W / Aeff;
        case 4
            modelPara_4;
            pwr0_W = 10^(dBm/10) * 1e-3;
            intensity0 = pwr0_W / Aeff;
        case 5
            modelPara_5;
            pwr0_W = 10^(dBm/10) * 1e-3;
            intensity0 = pwr0_W / Aeff;
        otherwise
            disp('Set /"settings/" to a valid number');
    end
    
    ode = @(z,intensity) powerWaveguide(z,intensity,linearLoss,TPA,FCA,lifetime);
    %[z,intensity] = ode45(ode, zspan, intensity0);
    [z,intensity] = ode15s(ode, zspan, intensity0);
    
    % plot(z,log10(pwr) - log10(pwr(1)))
    decibel = 10 * log10(intensity*Aeff*1e3); %unit: dBm
    %plot(z,decibel)
    xlabel("propagation distance (cm)")
    ylabel("optical power (dBm)")
    hold on
    %plot(z,yfit,'r-')
    %hold off
    nonlinearLoss_dB(dBm+1) = decibel(1) - decibel(length(decibel)) - linearLoss_dB*(zspan(2) - zspan(1));
end
dBm_ = 0:0 + size__;
plot(dBm_, nonlinearLoss_dB, 'DisplayName', "Simulated")
xlabel("coupled power (dBm)")
ylabel("nonlinear loss (dB)")
legend();