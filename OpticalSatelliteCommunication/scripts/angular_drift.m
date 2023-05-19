function [theta_H, theta_V, t_o] = angular_drift(t, t_last, speed_V, speed_H, ...
theta_o_V, theta_o_H)

%Generates a drifting angular motion in both elevational and azimuthal
%directions at a desired speed.
theta_H = theta_o_V + speed_H*(t - t_last);
theta_V = theta_o_H + speed_V*(t - t_last);
t_o = t;

end