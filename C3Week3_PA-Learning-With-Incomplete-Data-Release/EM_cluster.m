% File: EM_cluster.m
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

function [P loglikelihood ClassProb] = EM_cluster(poseData, G, InitialClassProb, maxIter)

% INPUTS
% poseData: N x 10 x 3 matrix, where N is number of poses;
%   poseData(i,:,:) yields the 10x3 matrix for pose i.
% G: graph parameterization as explained in PA8
% InitialClassProb: N x K, initial allocation of the N poses to the K
%   classes. InitialClassProb(i,j) is the probability that example i belongs
%   to class j
% maxIter: max number of iterations to run EM

% OUTPUTS
% P: structure holding the learned parameters as described in the PA
% loglikelihood: #(iterations run) x 1 vector of loglikelihoods stored for
%   each iteration
% ClassProb: N x K, conditional class probability of the N examples to the
%   K classes in the final iteration. ClassProb(i,j) is the probability that
%   example i belongs to class j

% Initialize variables
N = size(poseData, 1);
K = size(InitialClassProb, 2);
numVar = size(G, 1);

ClassProb = InitialClassProb;

loglikelihood = zeros(maxIter,1);

P.c = [];
P.clg = repmat(struct('mu_x', [], 'mu_y', [], 'mu_angle', [], 'sigma_x', [], 'sigma_y', [], 'sigma_angle', [], 'theta', []), 1, numVar);

% EM algorithm
for iter=1:maxIter
  
  % M-STEP to estimate parameters for Gaussians
  %
  % Fill in P.c with the estimates for prior class probabilities
  % Fill in P.clg for each body part and each class
  % Make sure to choose the right parameterization based on G(i,1)
  %
  % Hint: This part should be similar to your work from PA8
  
  P.c = zeros(1,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  sumProb = sum(ClassProb, 1);
  P.c = sumProb / sum(sumProb);
  for k = 1:K
    if length(size(G)) == 2
      currG = G;
    else
      currG = squeeze(G(:, :, k));
    end
    weight = ClassProb(:, k);
    for p = 1:numVar
      if(currG(p, 1) == 0)
        [P.clg(p).mu_x(k), P.clg(p).sigma_x(k)] = FitG(squeeze(poseData(:, p, 2)), weight);
        [P.clg(p).mu_y(k), P.clg(p).sigma_y(k)] = FitG(squeeze(poseData(:, p, 1)), weight);
        [P.clg(p).mu_angle(k), P.clg(p).sigma_angle(k)] = FitG(squeeze(poseData(:, p, 3)), weight);
      else
        parent = currG(p, 2);
        [P.clg(p).theta(k, [2:4, 1]), P.clg(p).sigma_y(k)] = FitLG(squeeze(poseData(:, p, 1)), squeeze(poseData(:, parent, :)), weight);
        [P.clg(p).theta(k, [6:8, 5]), P.clg(p).sigma_x(k)] = FitLG(squeeze(poseData(:, p, 2)), squeeze(poseData(:, parent, :)), weight);
        [P.clg(p).theta(k, [10:12, 9]), P.clg(p).sigma_angle(k)] = FitLG(squeeze(poseData(:, p, 3)), squeeze(poseData(:, parent, :)), weight);
      end
    end
  end

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % E-STEP to re-estimate ClassProb using the new parameters
  %
  % Update ClassProb with the new conditional class probabilities.
  % Recall that ClassProb(i,j) is the probability that example i belongs to
  % class j.
  %
  % You should compute everything in log space, and only convert to
  % probability space at the end.
  %
  % Tip: To make things faster, try to reduce the number of calls to
  % lognormpdf, and inline the function (i.e., copy the lognormpdf code
  % into this file)
  %
  % Hint: You should use the logsumexp() function here to do
  % probability normalization in log space to avoid numerical issues
  
  ClassProb = zeros(N,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  mus = zeros([K, size(poseData)]);
  sigmas = zeros([K, size(poseData)]);
  for i=1:N
    for c = 1:K
      if length(size(G)) == 2
          currG = G;
        else
          currG = squeeze(G(:, :, c));
        end
      for p = 1:numVar
        sigmas(c, i, p, 2) = P.clg(p).sigma_x(c);
        sigmas(c, i, p, 1) = P.clg(p).sigma_y(c);
        sigmas(c, i, p, 3) = P.clg(p).sigma_angle(c);
        if currG(p, 1) == 0
          mus(c, i, p, 2) = P.clg(p).mu_x(c);
          mus(c, i, p, 1) = P.clg(p).mu_y(c);
          mus(c, i, p, 3) = P.clg(p).mu_angle(c);
        else
          parent = currG(p, 2);
          mus(c, i, p, 1) = P.clg(p).theta(c, 1) + [P.clg(p).theta(c, 2), P.clg(p).theta(c, 3), P.clg(p).theta(c, 4)] * squeeze(poseData(i, parent, :));
          mus(c, i, p, 2) = P.clg(p).theta(c, 5) + [P.clg(p).theta(c, 6), P.clg(p).theta(c, 7), P.clg(p).theta(c, 8)] * squeeze(poseData(i, parent, :));
          mus(c, i, p, 3) = P.clg(p).theta(c, 9) + [P.clg(p).theta(c, 10), P.clg(p).theta(c, 11), P.clg(p).theta(c, 12)] * squeeze(poseData(i, parent, :));
        end
      end
    end
  end
  pdfs = lognormpdf(repmat(reshape(poseData, [1, size(poseData)]), K, 1), mus, sigmas); %K, N, numVar, 3

  for i=1:N
    for k=1:K
      sample_pdf = squeeze(pdfs(k, i, :, :)); %numVar * 3
      ClassProb(i, k) = sum(sum(sample_pdf)) + log(P.c(k));
    end
    ClassProb(i, :) = exp(ClassProb(i, :) - logsumexp(squeeze(ClassProb(i, :))));
  end


  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Compute log likelihood of dataset for this iteration
  % Hint: You should use the logsumexp() function here
  loglikelihood(iter) = 0;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for i=1:N
    jointProd = ones(1, K);
    for k=1:K
      sample_pdf = squeeze(pdfs(k, i, :, :)); %numVar * 3
      jointProb(k) = sum(sum(sample_pdf)) + log(P.c(k));
    end
    loglikelihood(iter) = loglikelihood(iter) + logsumexp(jointProb);
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Print out loglikelihood
  disp(sprintf('EM iteration %d: log likelihood: %f', ...
    iter, loglikelihood(iter)));
  if exist('OCTAVE_VERSION')
    fflush(stdout);
  end
  
  % Check for overfitting: when loglikelihood decreases
  if iter > 1
    if loglikelihood(iter) < loglikelihood(iter-1)
      break;
    end
  end
  
end

% Remove iterations if we exited early
loglikelihood = loglikelihood(1:iter);
