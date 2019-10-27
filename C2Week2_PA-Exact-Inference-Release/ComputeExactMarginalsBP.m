%COMPUTEEXACTMARGINALSBP Runs exact inference and returns the marginals
%over all the variables (if isMax == 0) or the max-marginals (if isMax == 1). 
%
%   M = COMPUTEEXACTMARGINALSBP(F, E, isMax) takes a list of factors F,
%   evidence E, and a flag isMax, runs exact inference and returns the
%   final marginals for the variables in the network. If isMax is 1, then
%   it runs exact MAP inference, otherwise exact inference (sum-prod).
%   It returns an array of size equal to the number of variables in the 
%   network where M(i) represents the ith variable and M(i).val represents 
%   the marginals of the ith variable. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function M = ComputeExactMarginalsBP(F, E, isMax)

% initialization
% you should set it to the correct value in your code
M = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Implement Exact and MAP Inference.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

P = CreateCliqueTree(F, E);
P = CliqueTreeCalibrate(P, isMax);

vars = [];

for i = 1:length(F)
	vars = union(vars, F(i).var);
end

N = length(vars);

M = repmat(struct('var', [], 'card', [], 'val', []), 1, N);
marginalized = 0;

for i = 1:length(P.cliqueList)
	if marginalized == N
		break 
	end
	clique_var = P.cliqueList(i).var;
	for j = 1:length(clique_var)
		if isempty(M(clique_var(j)).var)
			if isMax
				M(clique_var(j)) = FactorMaxMarginalization(P.cliqueList(i), setdiff(clique_var, clique_var(j)));
			else
				M(clique_var(j)) = FactorMarginalization(P.cliqueList(i), setdiff(clique_var, clique_var(j)));
				M(clique_var(j)).val = M(clique_var(j)).val / sum(M(clique_var(j)).val);
			end
		marginalized = marginalized + 1;
		end
	end
end


end
