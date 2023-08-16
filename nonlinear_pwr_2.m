clc
clear
close all

settings = 1;  % 0: Raman gain and nonlinear optical absorption ...
               % 1: Four-wave mixing and nonlinear losses ... 
               %    Thick waveguide
               % 2: Nano-waveguide

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

%TPA = 0.5e-9;               % Ref: 0.5cm/GW
TPA = 0.74e-9;               % Ref: 0.5cm/GW
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
    otherwise
        disp('Set /"settings/" to a valid number');
end


A = zeros(11,11);
for n=11:21
    %   Customized settings
    %    linearLoss_dB = 0.15;
    %    linearLoss = (linearLoss_dB/10) * log(10);        % Ref: a dB/cm -> alpha = (a/10)*ln(10)/cm
    pwr0_W = 10^(n/10) * 1e-3;
    %for n2=0:10
    for n2=0:10
        Aeff = 1e-9 + n2*1e-9;
        
        intensity0 = pwr0_W / Aeff;
        
        ode = @(z,intensity) powerWaveguide(z,intensity,linearLoss,TPA,FCA,lifetime);
        [z,intensity] = ode45(ode, zspan, intensity0);
        
        decibel = 10 * log10(intensity*Aeff*1e3); %unit: dBm
        h = figure;
        plot(z,decibel)
        
        title("effective mode area: " + Aeff*1e8 + "um^2, coupledPower: " + 1e3 * pwr0_W + "mW (" + n + "dBm)")
        xlabel("propagation distance (cm)")
        ylabel("optical power (dBm)")
        hold on
        yfit = -linearLoss_dB*(z - z(length(z))) + decibel(length(decibel));
        plot(z,yfit,'r-')
        hold off
        %axis([0 5 n-9 n])
        disp("Nonlinear loss (dB):")
        nonLoss = decibel(1) - yfit(1)
        A(n-10,n2+1) = nonLoss;
        % put the textbox at 75% of the width and
        % 10% of the height of the figure
        annotation('textbox', [0.5, 0.6, 0.1, 0.1], 'String', "Nonlinear loss is " + nonLoss + "dB")
        legend('w/ nonlinear loss','w/o nonlinear loss')
        %saveas(h,sprintf('nonlinearity/Aeff%f_pwr%ddBm.png', Aeff*1e8, n)); % will save each plot
    end
    
end