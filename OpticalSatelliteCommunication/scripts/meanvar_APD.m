function [meanAPD1, varAPD1, meanAPD0, varAPD0, SNR] =...
meanvar_APD(Pmax, Pmin, M, Br, Keff, G, Is, Ib, Pback, Rl, Tr, n, lambda)

% Pmax = maximum received optical power (W).
% Pmin = minimum received optical power (W).
% M = Numder of slots in PPM, M = 1 for OOK (Scalar).
% Br = Bit rate (bps).
% Keff = Effective ratio of the APD hole and electron ionization
%        coefficients (Scalar).
% G = APD Gain (Scalar).
% Is = APD surface leakage current (A).
% Ib = APD bulk leakage current (A).
% Pback = incident background power (W).
% Rl = Receiver load resistor (Ohm).
% Tr = Thermal noise temperature (K).
% n = detector quantum efficiency (Scalar).
% lambda = optical wavelength (m).

q = 1.60217646*10^-19; % electron charge (C).
Kb = 1.38065*10^-23; % Boltzmann (J/K).
h = 6.6260688*10^-34; % plank (Js).
c = 299792458; % speed of light in vaccum (m/s).
f = c/lambda; % Optical frequency (Hz).
R = G*q*n/(h*f); % Responsivity of the APD (A/W).
Bw = Br*M/log2(M); % Occupied bandwidth of the modulation (Hz).

if M == 1 % Makes sure that OOK gets correct average power and bandwidth.
	Bw = Br;
	M = 2;
end

Pavg = Pmax*(1 + Pmin/Pmax*(M-1))/M; % Average received power (W).
F = Keff*G + (1 - Keff)*(2 - 1/G); % APD excess noise figure (Scalar).

%The variances of different noise sources for an APD receiver
varSn0 = 2*q*F*Pmin*R*G*Bw; %signal shot noise for "0" (A^2).
varSn1 = 2*q*F*Pmax*R*G*Bw; %signal shot noise for "1" (A^2).
varSnavg= 2*q*F*Pavg*R*G*Bw; %signal shot noise for average power (A^2).
varDc = 2*q*F*G^2*Ib*Bw + 2*q*Bw*Is; %Dark current noise (A^2).
varBg = 2*q*F*Pback*R*G*Bw; %background noise (A^2).
varTh = 4*Kb*Tr*Bw/Rl; %Thermal noise (A^2).

% Mean (A) and variance (A^2) for a "zero" signal.
meanAPD0 = R*Pmin + R*Pback + G*Ib + Is;
varAPD0 = varSn0 + varBg + varDc + varTh;

% Mean (A) and variance (A^2) for a "one" signal.
meanAPD1 = R*Pmax + R*Pback + G*Ib + Is;
varAPD1 = varSn1 + varBg + varDc + varTh;

% The signal to noise ratio depends on the average received signal power.
varAPDavg = varSnavg + varBg + varDc + varTh;
SNR = 10*log((R*Pavg)^2/(varAPDavg)); %dB

end