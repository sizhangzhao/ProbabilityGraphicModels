%CLIQUETREECALIBRATE Performs sum-product or max-product algorithm for 
%clique tree calibration.

%   P = CLIQUETREECALIBRATE(P, isMax) calibrates a given clique tree, P 
%   according to the value of isMax flag. If isMax is 1, it uses max-sum
%   message passing, otherwise uses sum-product. This function 
%   returns the clique tree where the .val for each clique in .cliqueList
%   is set to the final calibrated potentials.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function P = CliqueTreeCalibrate(P, isMax)


% Number of cliques in the tree.
N = length(P.cliqueList);

% Setting up the messages that will be passed.
% MESSAGES(i,j) represents the message going from clique i to clique j. 
MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We have split the coding part for this function in two chunks with
% specific comments. This will make implementation much easier.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
% While there are ready cliques to pass messages between, keep passing
% messages. Use GetNextCliques to find cliques to pass messages between.
% Once you have clique i that is ready to send message to clique
% j, compute the message and put it in MESSAGES(i,j).
% Remember that you only need an upward pass and a downward pass.
%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isMax
  % convert to log space
  for i = 1:N
    P.cliqueList(i).val = log(P.cliqueList(i).val);
  end
end

[from, to] = GetNextCliques(P, MESSAGES);
while from && to
	potential = P.cliqueList(from);
	target = P.cliqueList(to);
	sepset = intersect(potential.var, target.var);
	others = setdiff(potential.var, sepset);
	for j = 1:length(P.edges(:, from))
		if j == to || P.edges(j, from) == 0
			continue;
		end
		if ~isMax
			potential = FactorProduct(potential, MESSAGES(j, from));
		else
			potential = FactorSum(potential, MESSAGES(j, from));
		end
	end
	if isMax
		potential = FactorMaxMarginalization(potential, others);
	else
		potential = FactorMarginalization(potential, others);
		potential.val = potential.val / sum(potential.val);
	end
	MESSAGES(from, to) = potential;
	[from, to] = GetNextCliques(P, MESSAGES);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Now the clique tree has been calibrated. 
% Compute the final potentials for the cliques and place them in P.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:N
	potential = P.cliqueList(i);
	for j = 1:N
		if P.edges(i,j)
			if isMax
				potential = FactorSum(potential, MESSAGES(j, i));
			else
				potential = FactorProduct(potential, MESSAGES(j, i));
			end
		end
	end
	P.cliqueList(i) = potential;
end


return
