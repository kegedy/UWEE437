function Pb = PPM(Xs, Xns, varXs, varXns, M)

Nbs = M/(2*(M-1)); % Average number of bit errors per symbol error

% Determines the integration interval so it includes 1 - 2*10^-16
% percent of the entire area.
int1 = norminv([10^-16 (1 - 10^-16)], Xs, sqrt(varXs));
int2 = norminv([10^-16 (1 - 10^-16)], Xns, sqrt(varXns));

if int1(1) < int2(1)
	int_min = int1(1);
else
	int_min = int2(1);
end

if int1(2) > int2(2)
	int_max = int1(2);
else
	int_max = int2(2);
end

% Sets the step-size for the integration solver
step_s = (int_max - int_min)/100;

% Evaluates the symbol error probability
Pcsc = 0;
for x = int_min:step_s:int_max
	Pcsc = Pcsc + normpdf(x, Xs, sqrt(varXs))...
	*normcdf(x, Xns, sqrt(varXns))^(M-1)*step_s;
end

% Bit error probability
Pb = Nbs*(1-Pcsc);

% Makes the output look nicer for values that are out of bounds.
if Pb < 10^-16 || Pb > 1
	Pb=0;
end

end