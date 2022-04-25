function [y0,y1] = decision_circuit(u0, u1, u2, u3, u4, u5, u6, u7)

% Finds the greatest input, and outputs the greatest value in y0 and the
% array number of the gretest value in y1.
[y0, y1] = max([u0 u1 u2 u3 u4 u5 u6 u7]);

% Makes the output go from 0-7 instead of 1-8.
y1 = y1 - 1;

end
