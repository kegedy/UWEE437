function [meanPIN1, varPIN1, meanPIN0, varPIN0, SNR] =...
    meanvar_PIN(Pmax, Pmin, M, Br, Id, Pback, Rl, Tr, n, lambda)

% Pmax = received power for a "one" (W).
% Pmin = received power for a "zero" (W).
% M = number of slots in a PPM symbol, for the case of
% OOK modulation, M = 1 (Scalar).
% Br = Bit rate (bps).
% Id = dark current (A)
% Pback = received background optical power (W).
% Rl = Load resistance (ohm).
% Tr = thermal temperature (K).
% n = quantum efficiency (Scalar).
% lambda = optical wavelength (m).

q = 1.60217646*10^-19; % electron charge (C).
Kb = 1.38065*10^-23; % Boltzmann (J/K).
h = 6.6260688*10^-34; % plank (Js).
c = 299792458; % speed of light in vaccum (m/s).
f = c/lambda; % Optical frequency (Hz).
R = q*n/(h*f); % Responsivity of the PIN (A/W).
Bw = Br*M/log2(M); % Occupied bandwidth of the modulation (Hz).

if M == 1 % Makes sure that OOK gets correct average power and bandwidth.
    Bw = Br;
    M = 2;
end

Pavg = Pmax*(1 + Pmin/Pmax*(M-1))/M; % Average received power (W).

%The variances of different noise sources for a PIN receiver without
%optical amplifier.
varSn0 = 2*q*R*Pmin*Bw; %signal shot noise for "0" (A^2).
varSn1 = 2*q*R*Pmax*Bw; %signal shot noise for "1" (A^2).
varSnavg= 2*q*R*Pavg*Bw; %signal shot noise for average power (A^2).
varDc = 2*q*Id*Bw; %Dark current noise (A^2).
varBg = 2*q*Pback*R*Bw; %background noise (A^2).
varTh = 4*Kb*Tr*Bw/Rl; %Thermal noise (A^2).

% Mean (A) and variance (A^2) for a "zero" signal.
meanPIN0 = R*Pmin + R*Pback + Id;
varPIN0 = varSn0 + varBg + varDc + varTh;

% Mean (A) and variance (A^2) for a "one" signal.
meanPIN1 = R*Pmax + R*Pback + Id;
varPIN1 = varSn1 + varBg + varDc + varTh;

% The signal to noise ratio depends on the average received signal power.
varPINavg = varSnavg + varBg + varDc + varTh;
SNR = 10*log((R*Pavg)^2/(varPINavg)); %dB

end