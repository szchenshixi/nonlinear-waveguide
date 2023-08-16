% Parameters of 
% Four-wave mixing and nonlinear losses
% in nano-silicon waveguides
%linearLoss_dB = 2;              % est. 2dB/cm
linearLoss_dB = 0.15;              % est. 2dB/cm

TPA = 0.8e-9;               % Ref: 0.5cm/GW
FCA = 1.45e-17;          % Ref: 1.45e-17cm2
lifetime = 4e-9;           % Ref: 23ns

zspan = [0 1.5];         % Ref: 0 - 1.3cm
pwr0_W = 100e-3;        % Ref: 100mW
Aeff = 0.1e-8;           % 0.1um^2 -> 0.1e-8cm^2
% intensity0 = 10e2;             % Ref: 100W/cm^2 -> 100mW with this Aeff
linearLoss = (linearLoss_dB/10) * log(10);        % Ref: a dB/cm -> alpha = (a/10)*ln(10)/cm
intensity0 = pwr0_W / Aeff;  



