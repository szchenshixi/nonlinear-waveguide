function d_dz = Waveguide_WoN(z,intensity,linearLoss)
% This function mimic a piece of silicon waveguide WITHOUT nonlinear loss 
% model and returns the output optical power intensity based on waveguide 
% length and input power intensity

%linearLoss                             % cm^-1, Ref: 0.22dB/cm -> 0.050656/cm
%TPACoeff                               % cm/GW, Ref: 0.5cm/GW
%FCACoeff                               % cm^2, Ref: 1.45e-17cm^2
%lifetime                               % ns, Ref: 10ns
%hv = 1.28e-19;                         % J, Ref: for 1550nm, the photon energy is 1.28e-19J (kg*m^2/s^2)
%z                                      % cm
%intensity                              % W/cm^2

alpha = linearLoss;     %Ref: 0.22dB/cm -> 0.050656/cm

d_dz = -alpha*intensity;
end

