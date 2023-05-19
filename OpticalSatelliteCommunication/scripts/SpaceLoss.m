function Ls = SpaceLoss(lambda, d)

% Ls = free-space loss
% lambda = wavelength (m)
% d = distance (m)
Ls = (lambda/(4*pi*d))^2;

end