function [meanPINOA1, varPINOA1, meanPINOA0, varPINOA0, SNR] =...
meanvar_PIN_OA(Pmax, Pmin, M, d_lambda, F, Br, Lout, Lin, RIN,...
G, Pback, nsp, Id, Rl, Tr, n, lambda)

% Pmax = received maximum power (W).
% Pmin = received minimum power (W).
% M = number of slots in a PPM word, M = 1 for OOK (Scalar).
% d_lambda = optical filter bandwidth (m).
% F = noise figure (dB).
% Br = Bit rate (bps).
% Lout = Output optical amplifier insertion loss (dB).
% Lin = Input optical amplifier loss (dB).
% RIN = Relative intensity noise (dB/Hz).
% G = Optical amplifier gain (Scalar).
% Pback = Received background power (W).
% nsp = spontaneous emission coefficient (Scalar).
% Id = dark current (A).
% Rl = Load resistance (Ohm).
% Tr = thermal temperature (K).
% n = quantum efficiency (Scalar).
% lambda = optical wavelength (m).

q = 1.60217646*10^-19; % electron charge (C).
Kb = 1.38065*10^-23; % Boltzmann (J/K).
h = 6.6260688*10^-34; % plank (Js).
c = 299792458; % speed of light in vaccum (m/s).
f = c/lambda; % Optical frequency (Hz).
R = q*n/(h*f); % Responsivity of the PIN (A/W).
Bop = d_lambda*c/lambda^2; % Bop = optical filter bandwidth in the
% frequency domain (Hz).
Bw = Br*M/log2(M); % Occupied bandwidth of the modulation (Hz).

if M == 1 % Makes sure that OOK gets correct average power and bandwidth.
    Bw = Br;
    M = 2;
end

Pavg = Pmax*(1 + Pmin/Pmax*(M-1))/M; % Average received optical power (W).

%The variances of different noise sources.
%Amplified signal shot noise (A^2).
varSn_0 = 2*q*G*R*Pmin*Bw;
varSn_1 = 2*q*G*R*Pmax*Bw;
varSn_avg = 2*q*G*R*Pavg*Bw;

%Amplified source relative intensity noise (A^2).
varRIN_0 = 10^(RIN/10)*(R*G*Pmin)^2*Bw;
varRIN_1 = 10^(RIN/10)*(R*G*Pmax)^2*Bw;
varRIN_avg = 10^(RIN/10)*(R*G*Pavg)^2*Bw;

%Amplified signal-spontaneous beat noise (A^2).
varSgSp_0 = 4*R^2*Pmin*G*Lin*Lout^2*(G-1)*nsp*h*f*Bw;
varSgSp_1 = 4*R^2*Pmax*G*Lin*Lout^2*(G-1)*nsp*h*f*Bw;
varSgSp_avg = 4*R^2*Pavg*G*Lin*Lout^2*(G-1)*nsp*h*f*Bw;

%Dark current noise (A^2).
varDc = 2*q*Id*Bw;

%Thermal noise (A^2).
varTh = 4*Kb*Tr*F*Bw/Rl;

%Amplified background noise (A^2).
varBg = 2*q*G*R*Pback*Bw;

%Amplified spontaneous emissions (A^2).
varSe = 4*R*q*h*f*nsp*(G-1)*Lout^2*Bw*Bop;

%Amplified spontaneous-spontaneous beat noise (A^2).
varSpSp = 8*(R*Lout*(G-1)*nsp*h*f)^2*Bop*Bw;

%The mean (A) and variance (A^2) for the "1" signal.
meanPINOA1 = R*G*Pmax + R*Pback + Id;
varPINOA1 = varSn_1 + varRIN_1 + varSgSp_1 + varDc + varTh + varBg...
+ varSe + varSpSp;

%The mean (A) and variance (A^2) for the "0" signal.
meanPINOA0 = R*G*Pmin + R*Pback + Id;
varPINOA0 = varSn_0 + varRIN_0 + varSgSp_0 + varDc + varTh + varBg...
+ varSe + varSpSp;

%The signal to noise ratio depends on the average received signal power.
varPINOA_avg = varSn_avg + varRIN_avg + varSgSp_avg + varDc + varTh...
+ varBg + varSe + varSpSp;

SNR = 10*log((R*G*Pavg)^2/(varPINOA_avg)); %dB

end