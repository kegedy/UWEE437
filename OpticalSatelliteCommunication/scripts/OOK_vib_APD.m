function Pb = OOK_vib_APD(var_theta, Pmax, Pmin, Br, Keff, G, Is, Ib,...
Pback, Rl, Tr, n, lambda, Dt, Dr, nt, nr, d, Lil)

% Solves the double integral that evaluates the mean BER for a certain
% standard deviation of the pointing jitter.
Pb = 0;
for theta_r = 0:2*10^-6:10^-4
	P = 0;
	for theta_t = 0:2*10^-6:10^-4
		P = P + P_OOK_theta(Pmax, Pmin, Br, Keff, G, Is, Ib, Pback, Rl,...
		Tr, n, lambda, theta_t, theta_r, Dt, Dr, nt, nr, d, Lil)*...
		raylpdf(theta_t, var_theta)*(2*10^-6);
	end
	Pb = Pb + P*raylpdf(theta_r, var_theta)*(2*10^-6);
end

end

%Gives the BER for OOK transmitter and receiver pointing error.

% Pmax = maximum received optical power (W).
% Pmin = minimum received optical power (W).
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
% Dt = Transmitt aperture diameter (m)
% Dr = Recieve aperture diameter (m)
% nt = Transmitt optics efficiency
% nr = Recieve optics efficiency
% d = distance (m)
% Lil = implementation loss
 
function P_OOK = P_OOK_theta(Pmax, Pmin, Br, Keff, G, Is, Ib, Pback, Rl,...
Tr, n, lambda, theta_t, theta_r, Dt, Dr, nt, nr, d, Lil)

Pr1 = Pmax...
    *PointingLoss(Ap_G(Dt, lambda, nt), theta_t)...
    *Ap_G(Dt,lambda,nt)...
    *SpaceLoss(lambda,d)...
    *PointingLoss(Ap_G(Dr, lambda, nr), theta_r)...
    *Ap_G(Dr,lambda,nr)...
    *10^(-Lil/10);

Pr0 = Pmin...
    *PointingLoss(Ap_G(Dt, lambda, nt), theta_t)...
    *Ap_G(Dt,lambda,nt)...
    *SpaceLoss(lambda,d)...
    *PointingLoss(Ap_G(Dr, lambda, nr), theta_r)...
    *Ap_G(Dr,lambda,nr)...
    *10^(-Lil/10);

[Xs, varXs, Xns, varXns, SNR] = ...
    meanvar_APD(Pr1, Pr0, 1, Br, Keff, G, Is, Ib, Pback, Rl, Tr, n, lambda);

P_OOK = OOK(Xs, Xns, varXs, varXns);

end