function [y,theta] = PointingLossTheta(u, theta_H, theta_V, G)

% Calculates the "line of sight damping" between the transmitter and
% receiver due to the pointing error.

theta = sqrt(theta_V^2 + theta_H^2);
y = u*exp(-G*theta^2);

end