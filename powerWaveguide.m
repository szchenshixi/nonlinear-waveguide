function dpwr_dz = powerWaveguide(z,intensity,linearLoss,TPACoeff,FCACoeff,lifetime)
alpha = linearLoss;     %Ref: 0.22dB/cm -> 0.050656/cm
beta = TPACoeff;        %Ref: 0.5cm/GW
sigma = FCACoeff;       %Ref: 1.45e-17cm^2
tau = lifetime;         %Ref: 10ns
hv = 1.28e-19;           %Ref: for 1550nm, the photon energy is 1.28e-19J (kg*m^2/s^2)

% z(unit:cm) intensity(unit:W/cm^2)

gamma = (sigma*tau*beta)/(2*hv);
%gamma = 0;
%temp0 = alpha*intensity;
%temp1 = beta*intensity^2;
%temp2 = gamma*intensity^3;
dpwr_dz = -alpha*intensity - beta*intensity^2 - gamma*intensity^3;

%zspan = [0 1e-3];
%ode = @(z,pwr)