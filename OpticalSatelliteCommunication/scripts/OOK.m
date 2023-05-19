function Pb = OOK(Xs, Xns, varXs, varXns)

% "normalized distance" between the threshold and the distribution mean
DN = (Xs - Xns)/(sqrt(varXs) + sqrt(varXns));

% Bit error probability
Pb = 1/2*erfc(DN/sqrt(2));

end