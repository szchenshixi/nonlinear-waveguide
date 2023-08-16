%ver_0.0.2

% Device parameters
grating_coupler_loss = 1.5;             % dB
insertion_loss_per_ring = 1.5;          % dB
passing_loss_per_ring = 0.05;           % dB
crossing_loss = 0.05;                   % dB
splitter_excess_loss = 0.2;             % dB
linear_propagation_loss = 1.5;          % dB/cm
% effective_carrier_lifetime = 1e-9;      % s
effective_carrier_lifetime = 10e-9;     % s
TPA = 0.8e-9;                           % cm/GW
% TPA = 0.6e-9;                           % cm/GW
FCA = 1.45e-17;                         % cm2
% Aeff = 0.1e-8;                         % effective_area, cm^2 (1um^2 -> 1e-8cm^2)
Aeff = 0.0662536e-8;                    % cm^2, 0.0662um^2 for 220x450nm_50nm slab waveguide
hv = 1.28e-19;                          %Ref: for 1550nm, the photon energy is 1.28e-19J (kg*m^2/s^2)

% System configurations
% output_pwr_per_wavelength = 2;          % mW
% wavelength_per_channel = 4;

% Derived module parameters in scalar scale
injection_loss_per_coupler = 10^(-(grating_coupler_loss)/10);
splitter_loss = 10^(-(splitter_excess_loss)/10);  % percentage
