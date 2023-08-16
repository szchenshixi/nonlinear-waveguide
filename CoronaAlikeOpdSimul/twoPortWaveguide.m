function [intensity,z] = twoPortWaveguide(zspan,intensityInit,isNonlinearModelEnabled)
% This function simulates the power decay along a silicon waveguide given
% its length and input optical intensity. User can specify whether to use
% nonlinear loss model. 

% Load device parameters
devicePara;

% linearLoss                             % cm^-1, Ref: 0.22dB/cm -> 0.050656/cm
% TPACoeff                               % cm/GW, Ref: 0.5cm/GW
% FCACoeff                               % cm^2, Ref: 1.45e-17cm^2
% lifetime                               % ns, Ref: 10ns
% hv
% hv = 1.28e-19;                         % J, Ref: for 1550nm, the photon energy is 1.28e-19J (kg*m^2/s^2)
% z                                      % cm
% intensity                              % W/cm^2

% intensityInit*Aeff*1e3

linearLoss = (linear_propagation_loss/10) * log(10);        % Ref: a dB/cm -> alpha = (a/10)*ln(10)/cm
if(isNonlinearModelEnabled)
    % use the waveguide model with nonlinear loss
    ode = @(z,intensity) waveguide_WN(z,intensity,linearLoss,TPA,FCA,effective_carrier_lifetime,hv);
else
    % use the waveguide mode without nonlinear loss
    ode = @(z,intensity) waveguide_WoN(z,intensity,linearLoss);
end
[z,intensity] = ode45(ode, zspan, intensityInit);
end

