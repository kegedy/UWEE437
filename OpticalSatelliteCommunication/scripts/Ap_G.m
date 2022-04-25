function G = Ap_G(D, lambda, n)

% G = aperture gain
% D = aperture diameter (m)
% lambda = wavelength (m)
% n = optics efficiency
G=(pi*D/lambda)^2*n;

end