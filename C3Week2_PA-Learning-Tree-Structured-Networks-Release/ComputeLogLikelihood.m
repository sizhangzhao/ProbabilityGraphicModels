function loglikelihood = ComputeLogLikelihood(P, G, dataset)
% returns the (natural) log-likelihood of data given the model and graph structure
%
% Inputs:
% P: struct array parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description)
%
%    NOTICE that G could be either 10x2 (same graph shared by all classes)
%    or 10x2x2 (each class has its own graph). your code should compute
%    the log-likelihood using the right graph.
%
% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
% 
% Output:
% loglikelihood: log-likelihood of the data (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset,1); % number of examples
K = length(P.c); % number of classes
numVar = 10;

loglikelihood = 0;
% You should compute the log likelihood of data as in eq. (12) and (13)
% in the PA description
% Hint: Use lognormpdf instead of log(normpdf) to prevent underflow.
%       You may use log(sum(exp(logProb))) to do addition in the original
%       space, sum(Prob).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:N
	ll = -Inf;
	sample = squeeze(dataset(i, :, :));
	for c = 1:K
		ill = log(P.c(c));
		if length(size(G)) == 2
			currG = G;
		else
			currG = squeeze(G(:, :, c));
		end
		for p = 1:10
			currSigmaX = P.clg(p).sigma_x(c);
			currSigmaY = P.clg(p).sigma_y(c);
			currSigmaAngle = P.clg(p).sigma_angle(c);
			if currG(p, 1) == 0
				currMeanX = P.clg(p).mu_x(c);
				currMeanY = P.clg(p).mu_y(c);
				currMeanAngle = P.clg(p).mu_angle(c);
			else
				parent = currG(p, 2);
				currMeanY = P.clg(p).theta(c, 1) + [P.clg(p).theta(c, 2), P.clg(p).theta(c, 3), P.clg(p).theta(c, 4)] * sample(parent, :)';
				currMeanX = P.clg(p).theta(c, 5) + [P.clg(p).theta(c, 6), P.clg(p).theta(c, 7), P.clg(p).theta(c, 8)] * sample(parent, :)';
				currMeanAngle = P.clg(p).theta(c, 9) + [P.clg(p).theta(c, 10), P.clg(p).theta(c, 11), P.clg(p).theta(c, 12)] * sample(parent, :)';
			end
			ill = ill + lognormpdf(sample(p, 2), currMeanX, currSigmaX) + lognormpdf(sample(p, 1), currMeanY, currSigmaY) + lognormpdf(sample(p, 3), currMeanAngle, currSigmaAngle);
		end
		ll = log(exp(ll) + exp(ill));
	end
	loglikelihood = loglikelihood + ll;

end


