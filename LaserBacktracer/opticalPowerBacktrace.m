close all;
clc;
clear;

% ------------------------------------------------------------
%                      User Configuration
% ------------------------------------------------------------

% linearLoss_dB = 0.2;              % Ref. 0.2dB/cm
% TPA = 0.8e-9;               % Ref: 0.5 - 0.8cm/GW
% FCA = 1.45e-17;          % Ref: 1.45e-17cm2
% lifetime = 23e-9;           % Ref: 23ns
% zspan = [0 1.5];         % Ref: 0 - 5cm
% wavelengths = 16;
% Aeff = 1e-8;             % 0.1um^2 -> 1eclose all-9cm^2

linearLoss_dB = 1.5;              % est. 2dB/cm
TPA = 0.8e-9;               % Ref: 0.5cm/GW
FCA = 1.45e-17;          % Ref: 1.45e-17cm2
lifetime = 10e-9;           % Ref: 23ns
% zspan = [0 0.075];         % Ref: 0 - 5cm
% wavelengths = 16;
Aeff = 0.0662536e-8;            % (cm^2) um^2 -> 1e-8cm^2

power_per_wavelength_W = 1e-3;        % Ref: 2mW/wavelength

% ------------------------------------------------------------
%                    End of User Configuration
% ------------------------------------------------------------

linearLoss = (linearLoss_dB/10) * log(10);
ode = @(z,intensity) PowerBacktracer(z,intensity,linearLoss,TPA,FCA,lifetime);

% for num_wavelengths = 1 : wavelengths
sum = 0;
for zspan_end = 0.1: 0.15 : 0.55
    for num_wavelengths = 4 : 4
        %    figure();
        zspan = [0 zspan_end];
        coupled_out_intensity = (power_per_wavelength_W * num_wavelengths) / Aeff;

        %[z,intensity] = ode15s(ode, zspan, coupled_out_intensity);
        [z,intensity] = ode45(ode, zspan, coupled_out_intensity);
        %intensity = fliplr(intensity);
        figure()
        decibel = 10 * log10(intensity * Aeff * 1e3); %unit: dBm
        plot(z,decibel)
        
        coupled_out_power = power_per_wavelength_W * num_wavelengths * 1e3;
        title("coupled-out optical power: " + coupled_out_power + "mW (" + 10*log(coupled_out_power)/log(10) + "dBm)")
        xlabel("waveguide length (cm)")
        ylabel("coupled-in optical power (dBm)")
        
        hold on
        plot(z,linearLoss_dB * z + decibel(1), "r--");
        axis([0 1.2 0 35])
        
        coupleInPower_mW = intensity(end) * Aeff * 1e3;
        sum = sum + coupleInPower_mW;
        display("Required coupled-in power: " + coupleInPower_mW)
        %axis([0 42 0 25])
        %     figure();
        %     efficiency = zeros([1 size(intensity)]);
        %     for i = 1: size(intensity)
        %         efficiency(i) = coupled_out_intensity / intensity(i);
        %     end
        %     plot(z, efficiency);
        %     title("power delivery efficiency (out\_power: " + coupled_out_power + "mW)")
        %     xlabel("waveguide length (cm)")
        %     ylabel("efficiency")
    end
end

% figure();
% plot(z, efficiency);
% title("power delivery efficiency (out\_power: 2mW)")
% xlabel("waveguide length (cm)")
% ylabel("efficiency")
