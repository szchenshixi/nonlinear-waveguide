% Parameters of 
% "Raman gain and nonlinear optical absorption
% measurements in a low-loss silicon
% waveguide"

linearLoss_dB = 2;        % 
TPA = 0.5e-9;  % Ref: 0.5cm/GW, a well-known number at wavelengths near 1550nm
FCA = 1.45e-17;          % Ref: 1.45e-17cm2
lifetime = 23e-9;           % Ref: 23ns

zspan = [0 4.8];         % Ref: 0 - 4.8cm
pwr0_W = 100e-3;             % Ref: 100mW
Aeff = 1.57e-8;             % 1 um^2 -> 1e-8 cm^2
linearLoss = (linearLoss_dB/10) * log(10);        % Ref: a dB/cm -> alpha = (a/10)*ln(10)/cm
intensity0 = pwr0_W / Aeff;  
%intensity0 = 15e6;            %15MW/cm^2