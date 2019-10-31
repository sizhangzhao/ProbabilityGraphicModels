function [P loglikelihood] = LearnCPDsGivenGraph(dataset, G, labels)
%
% Inputs:
% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
% G: graph parameterization as explained in PA description
% labels: N x 2 true class labels for the examples. labels(i,j)=1 if the 
%         the ith example belongs to class j and 0 elsewhere        
%
% Outputs:
% P: struct array parameters (explained in PA description)
% loglikelihood: log-likelihood of the data (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset, 1);
K = size(labels,2);
numVar = 10;

loglikelihood = 0;
P.c = zeros(1,K);
P.clg = repmat(struct('mu_x', [], 'mu_y', [], 'mu_angle', [], 'sigma_x', [], 'sigma_y', [], 'sigma_angle', [], 'theta', []), 1, numVar);

% estimate parameters
% fill in P.c, MLE for class probabilities
% fill in P.clg for each body part and each class
% choose the right parameterization based on G(i,1)
% compute the likelihood - you may want to use ComputeLogLikelihood.m
% you just implemented.
%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
numLabel = sum(labels, 1);
P.c = numLabel / sum(numLabel);

for k = 1:K
	if length(size(G)) == 2
		currG = G;
	else
		currG = squeeze(G(:, :, k));
	end
	pos = labels(:, k) == 1;
	samples = dataset(pos, :, :);
	for p = 1:numVar
		if(currG(p, 1) == 0)
			[P.clg(p).mu_x(k), P.clg(p).sigma_x(k)] = FitGaussianParameters(squeeze(samples(:, p, 2)));
			[P.clg(p).mu_y(k), P.clg(p).sigma_y(k)] = FitGaussianParameters(squeeze(samples(:, p, 1)));
			[P.clg(p).mu_angle(k), P.clg(p).sigma_angle(k)] = FitGaussianParameters(squeeze(samples(:, p, 3)));
		else
			parent = currG(p, 2);
			[P.clg(p).theta(k, [2:4, 1]), P.clg(p).sigma_y(k)] = FitLinearGaussianParameters(squeeze(samples(:, p, 1)), squeeze(samples(:, parent, :)));
			[P.clg(p).theta(k, [6:8, 5]), P.clg(p).sigma_x(k)] = FitLinearGaussianParameters(squeeze(samples(:, p, 2)), squeeze(samples(:, parent, :)));
			[P.clg(p).theta(k, [10:12, 9]), P.clg(p).sigma_angle(k)] = FitLinearGaussianParameters(squeeze(samples(:, p, 3)), squeeze(samples(:, parent, :)));
		end
	end
end

loglikelihood = ComputeLogLikelihood(P, G, dataset);

% These are dummy lines added so that submit.m will run even if you 
% have not started coding. Please delete them.
% P.clg.sigma_x = 0;
% P.clg.sigma_y = 0;
% P.clg.sigma_angle = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('log likelihood: %f\n', loglikelihood);

