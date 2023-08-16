% This script generates the optical power distribution over a length of
% waveguide with considering the nonliear losses incurred by two photon
% absorption (TPA) and free carrier absorption (FCA).

clc
clear
close all
DisplayFigure = 1; %1 = display, 0 = no display

settings = 2;  % 0: Raman gain and nonlinear optical absorption ...
               % 1: Four-wave mixing and nonlinear losses ... 
               %    Thick waveguide
               % 2: Nano-waveguide
               % 3: Case used in paper

switch (settings)
    case 0
        % Parameters of
        % "Raman gain and nonlinear optical absorption
        % measurements in a low-loss silicon
        % waveguide"
        
        linearLoss_dB = 1;        % dB/cm
        TPA = 0.8e-9;  % Ref: 0.8cm/GW, a measured quantity at wavelengths near 1550nm
        FCA = 1.45e-17;          % Ref: 1.45e-17cm2
        lifetime = 23e-9;           % Ref: 23ns
        
        zspan = [0 4.8];         % Ref: 0 - 4.8cm
        pwr0_W = 100e-3;             % Ref: 100mW
        Aeff = 1.57e-8;             % 1 um^2 -> 1e-8 cm^2
        linearLoss = (linearLoss_dB/10) * log(10);        % Ref: a dB/cm -> alpha = (a/10)*ln(10)/cm
        intensity0 = pwr0_W / Aeff;
        %intensity0 = 15e6;            %15MW/cm^2
    case 1
        % Parameters of
        % Four-wave mixing and nonlinear losses
        % in thick silicon waveguides
        
        linearLoss_dB = 0.15;              % 2dB/cm
        
        TPA = 0.74e-9;               % Ref: 0.8cm/GW
        FCA = 1.45e-17;          % Ref: 1.45e-17cm2
        lifetime = 40e-9;           % Ref: 23ns
        
        zspan = [0 1.3];         % Ref: 0 - 1.3cm
        pwr0_W = 100e-3;        % Ref: 100mW
        Aeff = 2.75e-8;           % 0.1um^2 -> 0.1e-8cm^2
        % intensity0 = 10e2;             % Ref: 100W/cm^2 -> 100mW with this Aeff
        linearLoss = (linearLoss_dB/10) * log(10);        % Ref: a dB/cm -> alpha = (a/10)*ln(10)/cm
        intensity0 = pwr0_W / Aeff;

    case 2
        % in nano-silicon waveguides
        linearLoss_dB = 2;              % 2dB/cm
        
        TPA = 0.5e-9;               % Ref: 0.5cm/GW
        FCA = 1.45e-17;          % Ref: 1.45e-17cm2
        lifetime = 4e-9;           % Ref: 23ns
        
        zspan = [0 1.3];         % Ref: 0 - 1.3cm
        pwr0_W = 100e-3;        % Ref: 100mW
        Aeff = 0.1e-8;           % 0.1um^2 -> 0.1e-8cm^2
        % intensity0 = 10e2;             % Ref: 100W/cm^2 -> 100mW with this Aeff
        linearLoss = (linearLoss_dB/10) * log(10);        % Ref: a dB/cm -> alpha = (a/10)*ln(10)/cm
        intensity0 = pwr0_W / Aeff;
    case 3
        % A case for demonstration in paper
        linearLoss_dB = 1.5;              % Ref: 2dB/cm
        
        TPA = 0.8e-9;               % Ref: 0.8cm/GW
        FCA = 1.45e-17;          % Ref: 1.45e-17cm2
        lifetime = 10e-9;           % Ref: 10ns
        
        zspan = [0 3];         % Ref: 0 - 1.3cm
        pwr0_W = 100e-3;        % Ref: 100mW
%         Aeff = 0.1e-8;           % 0.1um^2 -> 0.1e-8cm^2
        Aeff = 0.062536e-8;                    % 0.0625um^2 for 220x450nm_50nm slab waveguide
        % intensity0 = 10e2;             % Ref: 100W/cm^2 -> 100mW with this Aeff
        linearLoss = (linearLoss_dB/10) * log(10);        % Ref: a dB/cm -> alpha = (a/10)*ln(10)/cm
        intensity0 = pwr0_W / Aeff;
    otherwise
        disp('Set /"settings/" to a valid number');
end


% A = zeros(11,11);
interpolation_granularity = 1e-4; % Meaning generates (1e4 + 1) data points for a plot
pwr0_mW_sample = [50 100 150 200 400 300 500];
len_secondary_index = 11;
power_at_1mm = zeros(len_secondary_index, length(pwr0_mW_sample));
efficiency = zeros(len_secondary_index, length(pwr0_mW_sample));
% for n=16:27
% for lifetime=5e-9:1e-9:15e-9 
for n=length(pwr0_mW_sample):-1:1
    secondary_index = 0;
%     for wavelength=1525:5:1575
%     for wavelength=1550
    wavelength=1550;
%    for lifetime=5e-9:1e-9:15e-9
    for lifetime=10e-9:10e-9
        secondary_index = secondary_index + 1;
        FCA = 1.45e-17 * (wavelength/1550)^2;
        pwr0_W =  pwr0_mW_sample(n) * 1e-3;
        intensity0 = pwr0_W / Aeff;
        
        ode = @(z,intensity) powerWaveguide(z,intensity,linearLoss,TPA,FCA,lifetime);
%        ode = @(z,intensity) powerWaveguide_woNonlinear(z,intensity,linearLoss,TPA,FCA,lifetime);
        [z,intensity] = ode45(ode, zspan, intensity0);
        z_mm = z * 10;  % Unit conversion to mm
       
            %         h = figure;    
        power_mW = intensity*Aeff*1e3;
        power_at_1mm(secondary_index, n) = measureAt(power_mW, z_mm, 1);    % request data point at 1mm
        efficiency(secondary_index, n) = power_at_1mm(secondary_index, n) / pwr0_mW_sample(n);
        if(DisplayFigure == 1)
            figure(1);  % This figure shows power in mW
            plot(z_mm, power_mW, 'DisplayName', pwr0_W*1e3 + " mW")
            title("modal area: " + Aeff*1e8 + "um^2, carrier lifetime: " + lifetime * 1e9 + "ns, " + linearLoss_dB + "dB/cm linear loss")
            xlabel("propagation length (mm)")
            ylabel("optical power (mW)")
            axis([0 inf 0 inf])
            hold on
            legend;
            
            figure(2);  % This figure shows power in dBm
            decibel = 10 * log10(intensity*Aeff*1e3); %unit: dBm
            plot(z_mm, decibel, 'DisplayName', pwr0_W*1e3 + " mW")
            %         title("effective mode area: " + Aeff*1e8 + "um^2, coupledPower: " + 1e3 * pwr0_W + "mW (" + n + "dBm)")
            title("modal area: " + Aeff*1e8 + "um^2, carrier lifetime: " + lifetime * 1e9 + "ns, " + linearLoss_dB + "dB/cm linear loss")
            xlabel("propagation length (mm)")
            ylabel("optical power (dBm)")
            hold on
            legend;
            %         yfit = -linearLoss_dB*(z - z(length(z))) + decibel(length(decibel));
            %         plot(z,yfit,'r-')
            %         hold off
            %axis([0 5 n-9 n])
            %         disp("Nonlinear loss (dB):")
            %         nonLoss = decibel(1) - yfit(1)
            %         A(n-10,n2+1) = nonLoss;
            % put the textbox at 75% of the width and
            % 10% of the height of the figure
            %         annotation('textbox', [0.5, 0.6, 0.1, 0.1], 'String', "Nonlinear loss is " + nonLoss + "dB")
            %         legend('w/ nonlinear loss','w/o nonlinear loss')
            %saveas(h,sprintf('nonlinearity/Aeff%f_pwr%ddBm.png', Aeff*1e8, n)); % will save each plot
            
            figure(3);  % This figure shows power loss per centimeter in dB/cm
            % first generate the interpolated optical power in dBm
            z_interp = z(1) : z(length(z))*interpolation_granularity : z(length(z));
            z_interp_mm = z_interp * 10;
            decibel_interp = interp1(z,decibel,z_interp,'spline');
            % plot(z_interp, decibel_interp); % plot the interpolated figure
            % title("modal area: " + Aeff*1e8 + "um^2, carrier lifetime: " + lifetime * 1e9 + "ns, " + linearLoss_dB + "dB/cm linear loss")
            % xlabel("propagation length (cm)")
            % ylabel("optical power (dBm)")
            loss_dB_per_cm = -gradient(decibel_interp, z(length(z))*interpolation_granularity);
            
            plot(z_interp_mm, loss_dB_per_cm,'DisplayName', pwr0_W*1e3 + " mW")
            title("modal area: " + Aeff*1e8 + "um^2, carrier lifetime: " + lifetime * 1e9 + "ns, " + linearLoss_dB + "dB/cm linear loss")
            xlabel("propagation length (mm)")
            ylabel("propagation loss (dB/cm)")
            hold on
            lgd = legend;
            % lgd.NumColumns = 2;
        end
%         pwr0_W_sample(n)
%         pwr0_W_sample
%         linear_dissipation = pwr0_W_sample(n) - pwr0_W_sample(n) * 10^(-(linearLoss_dB * 0.1)/10)
%         nonlinear_dissipation = pwr0_W_sample(n) - power_at_1mm(wavelength_index, n) - linear_dissipation
%         power_at_1mm
    end
end
% figure(1)
% axis([0 1 0 inf])

