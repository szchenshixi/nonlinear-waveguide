% Parameters of 
% Four-wave mixing and nonlinear losses
% in thick silicon waveguides (w/ experiment result)
linearLoss_dB = 0.15;              % dB/cm

%TPA = 0.5e-9;               % Ref: 0.8cm/GW
TPA = 0.8e-9;               % Ref: 0.8cm/GW
FCA = 1.45e-17;             % Ref: 1.45e-17cm2
lifetime = 55e-9;           % Ref: 23ns

zspan = [0 1.5];         % Ref: 0 - 1.3cm
%pwr0_W = 100e-3;        % Ref: 100mW
Aeff = 2.75e-8;          % 1um^2 -> 1e-8cm^2
%intensity0 = 10e2;             % Ref: 100W/cm^2 -> 100mW with this Aeff
linearLoss = (linearLoss_dB/10) * log(10);        % Ref: a dB/cm -> alpha = (a/10)*ln(10)/cm
%intensity0 = pwr0_W / Aeff;  

x = [8.852459016
11.27364439
13.99747793
15.92686003
17.8184111
18.83984868
19.82345523
21.67717528
23.22824716
24.32534678
25.04413619
25.7629256
];

y=[-0.051020408
-0.010204082
0.040816327
0.051020408
0.163265306
0.183673469
0.265306122
0.551020408
0.887755102
1.183673469
1.571428571
1.908163265
];
plot(x,y,"rx")
legend("Experimental")