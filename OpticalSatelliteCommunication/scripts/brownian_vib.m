function [theta_H1, theta_V1] = brownian_vib(theta_V, theta_H, sigma_V, sigma_H)

%Generates a stochastic random walking motion.
%Sets the standard deviation of the step size for the brownian walk.
d_sigma_H = sigma_H/100;

%Generates a step of random length and direction along the azimuthal axis.
d_theta_H = randn()*d_sigma_H - theta_H*d_sigma_H/sigma_H;

%the new error angle is produced by adding the random step the the current
%error angle.
theta_H1 = theta_H + d_theta_H;

%The same principle for the elevation axis.
d_sigma_V = sigma_V/100;
d_theta_V = randn()*d_sigma_V - theta_V*d_sigma_V/sigma_V;

theta_V1 = theta_V + d_theta_V;

end