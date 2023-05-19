function [Xs, stdXs]=noise_ADP(u, Br, M, Keff, G, Is, Ib, Pb, Rl, Tr, n, lambda)

%u = Received optical power (W).
%Br = Bit rate (bps).
%M = The M number of the PPM (Scalar).
%Keff = Effective ratio of the APD hole and electron ionization
%coefficients (Scalar).
%G = APD Gain (Scalar).
%Is = APD surface leakage current (A).
%Ib = APD bulk leakage current (A).
%Pb = incident background power (W).
%Rl = Receiver load resistor (Ohm).
%Tr = Thermal noise temperature (K).
%n = detector quantum efficiency (Scalar).
%lambda = optical wavelength (m).

q = 1.60217646*10^-19; % Electron charge (C).
Kb = 1.38065*10^-23; % Boltzmann (J/K).
h = 6.6260688*10^-34; % Plank (Js).
c = 299792458; % speed of light in vaccum (m/s).

f = c/lambda; % Optical frequency (Hz).
R = G*q*n/(h*f); % Responsivity of the APD (A/W).
Bw = Br*M/log2(M); % Occupied bandwidth of the modulation (Hz).
F = Keff*G + (1 - Keff)*(2 - 1/G); % APD excess noise figure (Scalar).

%The variances of different noise sources for an APD receiver.
varSn = 2*q*F*u*R*G*Bw; %Signal shot noise (A^2).
varDc = 2*q*F*G^2*Ib*Bw + 2*q*Bw*Is; %Dark current noise (A^2).
varBg = 2*q*F*Pb*R*G*Bw; %Background noise (A^2).
varTh = 4*Kb*Tr*Bw/Rl; %Thermal noise (A^2).

% Mean (A) and variance (A^2) for the input signal.
Xs = (R*u + R*Pb + G*Ib + Is)*T;

stdXs = sqrt((varSn + varBg + varDc + varTh)*T);

end