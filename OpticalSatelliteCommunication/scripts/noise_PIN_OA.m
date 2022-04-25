function [meanPPM, stdPPM] = noise_PIN_OA(u, d_lambda, F, M, Br, Lout, Lin,...
RIN, G, nsp, Id, Pb, Rl, Tr, n, lambda)

% u = received power (W).
% d_lambda = optical filter bandwidth (m).
% F = noise figure (dB).
% M = Number of slots in a symbol, M-PPM (Scalar).
% Br = Bit rate (bps).
% Lout = Output optical amplifier insertion loss (dB).
% Lin = Input optical amplifier loss (dB).
% RIN = Relative intensity noise (dB/Hz)
% G = Optical amplifier gain (Scalar).
% nsp = spontaneous emission coefficient (Scalar).
% Id = dark current (A).
% Pb = Background power (W).
% Rl = Load resistance (Ohm).
% Tr = thermal temperature (K).
% n = quantum efficiency (Scalar).
% lambda = optical wavelength (m).

q = 1.60217646*10^-19; % electron charge (C).
Kb = 1.38065*10^-23; % Boltzmann (J/K).
h = 6.6260688*10^-34; % plank (Js).
c = 299792458; % Speed of light in vacuum (m/s).

f = c/lambda; % Optical frequency (Hz).
R = q*n/(h*f); % Responsivity of the PIN (A/W).

% Optical filter bandwidth in the frequency domain (Hz).
Bop = d_lambda*c/lambda^2;
Bw = Br*M/k; % Occupied bandwidth of the modulation (Hz).

%The variances of different noise sources.

%Amplified signal shot noise (A^2).
varSn = 2*q*G*R*u*Bw;

%Amplified source relative intensity noise (A^2).
varRIN = 10^(RIN/10)*(R*G*u)^2*Bw;

%Amplified signal-spontaneous beat noise (A^2).
varSgSp = 4*R^2*u*G*Lin*Lout^2*(G-1)*nsp*h*f*Bw;

%Dark current noise (A^2).
varDc = 2*q*Id*Bw;

%Thermal noise (A^2).
varTh = 4*Kb*Tr*F*Bw/Rl;

%Amplified background noise (A^2).
varBg = 2*q*G*Pb*Bw;
%Amplified spontaneous emissions (A^2).
varSe = 4*R*q*h*f*nsp*(G-1)*Lout^2*Bw*Bop;

%Amplified spontaneous-spontaneous beat noise (A^2).
varSpSp = 8*(R*Lout*(G-1)*nsp*h*f)^2*Bop*Bw;

%The mean (A) and variance (A^2) for the signal for MPPM modultaion.
meanPPM = R*G*u*T + R*G*Pb*T + Id*T;
stdPPM = sqrt(varSn + varRIN + varSgSp + varDc + varTh + varBg +...
		varSe + varSpSp);
		
end