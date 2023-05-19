function f = raylpdf(theta,variance)

%RAYLPDF probability density function of a Rayleigh distribution
% theta = total radial error angle [radians]
% variance = point error variance
f = theta/variance * exp(-theta^2/(2*variance));

end

