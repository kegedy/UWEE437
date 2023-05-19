function [Xs, stdXs] = noise_PIN(u, M, Br, Id, Pb, Rl, Tr, n, lambda)

% u = Received power (W).
% M = Number of slots in a PPM word (Scalar).
% Br = Bit rate (bps)
% Id = Dark current (A).
% Pb = Received background optical power (W).
% Rl = Load resistance (Ohm).
% Tr = Thermal temperature (K).
% n = Quantum efficiency (Scalar).
% lambda = Optical wavelength (m).

q = 1.60217646*10^-19; % Electron charge (C).
Kb = 1.38065*10^-23; % Boltzmann (J/K).
h = 6.6260688*10^-34; % plank (Js).
c = 299792458; % Speed of light in vacuum (m/s).

f = c/lambda; % Optical frequency (Hz).
R = q*n/(h*f); % Responsivity of the PIN (A/W).
Bw = Br*M/log2(M); % Occupied bandwidth of the modulation (Hz).

%The variances of different noise sources for a PIN receiver.
varSn = 2*q*R*u*Bw; %signal shot noise for (A^2).
varDc = 2*q*Id*Bw; %Dark current noise (A^2).
varBg = 2*q*Pb*R*Bw; %background noise (A^2).
varTh = 4*Kb*Tr*Bw/Rl; %Thermal noise (A^2).

% Mean (A) and variance (A^2) for the signal.
Xs = R*u + R*Pb + Id;

stdXs = sqrt(varSn + varBg + varDc + varTh);

end