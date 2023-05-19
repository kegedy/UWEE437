function Lp = PointingLoss(Gt, theta)

% Lp = pointing loss
% theta = pointing offset (radians)
% Gt = Transmitt telescope gain (real)
Lp = exp(-Gt.*theta.^2);

end
