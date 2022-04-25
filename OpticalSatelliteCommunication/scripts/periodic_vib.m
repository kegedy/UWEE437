function [theta_H, theta_V] = periodic_vib(t, amp_V, amp_H, omega_V, omega_H, ...
phase_V, phase_H)

%generates periodical motion.
theta_H = amp_H*sin(omega_H*t/(2*pi) - phase_H);
theta_V = amp_V*cos(omega_V*t/(2*pi) - phase_V);

end