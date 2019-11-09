% File: EM_HMM.m
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

function [P loglikelihood ClassProb PairProb] = EM_HMM(actionData, poseData, G, InitialClassProb, InitialPairProb, maxIter)

% INPUTS
% actionData: structure holding the actions as described in the PA
% poseData: N x 10 x 3 matrix, where N is number of poses in all actions
% G: graph parameterization as explained in PA description
% InitialClassProb: N x K matrix, initial allocation of the N poses to the K
%   states. InitialClassProb(i,j) is the probability that example i belongs
%   to state j.
%   This is described in more detail in the PA.
% InitialPairProb: V x K^2 matrix, where V is the total number of pose
%   transitions in all HMM action models, and K is the number of states.
%   This is described in more detail in the PA.
% maxIter: max number of iterations to run EM

% OUTPUTS
% P: structure holding the learned parameters as described in the PA
% loglikelihood: #(iterations run) x 1 vector of loglikelihoods stored for
%   each iteration
% ClassProb: N x K matrix of the conditional class probability of the N examples to the
%   K states in the final iteration. ClassProb(i,j) is the probability that
%   example i belongs to state j. This is described in more detail in the PA.
% PairProb: V x K^2 matrix, where V is the total number of pose transitions
%   in all HMM action models, and K is the number of states. This is
%   described in more detail in the PA.

% Initialize variables
N = size(poseData, 1);
K = size(InitialClassProb, 2);
L = size(actionData, 2); % number of actions
V = size(InitialPairProb, 1);
numVar = size(poseData, 2);

ClassProb = InitialClassProb;
PairProb = InitialPairProb;

loglikelihood = zeros(maxIter,1);

P.c = [];
P.clg.sigma_x = [];
P.clg.sigma_y = [];
P.clg.sigma_angle = [];

% EM algorithm
for iter=1:maxIter
  
  % M-STEP to estimate parameters for Gaussians
  % Fill in P.c, the initial state prior probability (NOT the class probability as in PA8 and EM_cluster.m)
  % Fill in P.clg for each body part and each class
  % Make sure to choose the right parameterization based on G(i,1)
  % Hint: This part should be similar to your work from PA8 and EM_cluster.m
  
  P.c = zeros(1,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for a = 1:L
    for k = 1:K
     P.c(k) = P.c(k) + ClassProb(actionData(a).marg_ind(1), k);
    end
  end
  P.c = P.c / sum(P.c);

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
  
  % M-STEP to estimate parameters for transition matrix
  % Fill in P.transMatrix, the transition matrix for states
  % P.transMatrix(i,j) is the probability of transitioning from state i to state j
  P.transMatrix = zeros(K,K);
  
  % Add Dirichlet prior based on size of poseData to avoid 0 probabilities
  P.transMatrix = P.transMatrix + size(PairProb,1) * .05;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  for action = 1:L
      for edge = actionData(action).pair_ind
          tempTran = reshape(PairProb(edge,:),K,K);
          P.transMatrix = P.transMatrix + tempTran;
      end
  end
  
  for source = 1:K
      P.transMatrix(source,:) = P.transMatrix(source,:) / sum(P.transMatrix(source,:));
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    
  % E-STEP preparation: compute the emission model factors (emission probabilities) in log space for each 
  % of the poses in all actions = log( P(Pose | State) )
  % Hint: This part should be similar to (but NOT the same as) your code in EM_cluster.m
  
  logEmissionProb = zeros(N,K);
  
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
      logEmissionProb(i, k) = sum(sum(sample_pdf));
    end
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    
  % E-STEP to compute expected sufficient statistics
  % ClassProb contains the conditional class probabilities for each pose in all actions
  % PairProb contains the expected sufficient statistics for the transition CPDs (pairwise transition probabilities)
  % Also compute log likelihood of dataset for this iteration
  % You should do inference and compute everything in log space, only converting to probability space at the end
  % Hint: You should use the logsumexp() function here to do probability normalization in log space to avoid numerical issues
  
  ClassProb = zeros(N,K);
  PairProb = zeros(V,K^2);
  loglikelihood(iter) = 0;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  for a = 1:L
    name = actionData(a).action;
    marg_ind = actionData(a).marg_ind;
    pair_ind = actionData(a).pair_ind;
    num_vars = length(marg_ind);

    factors = repmat(struct ('var', [], 'card', [], 'val', []), 1, 2 * num_vars );
    curr_pos = 1;

    factors(curr_pos) = struct("var", 1, "card", K, "val", log(P.c));
    curr_pos = curr_pos + 1;

    for i = 2:num_vars
      factors(curr_pos) = struct("var", [i-1, i], "card", [K, K], "val", log(P.transMatrix(:)'));
      curr_pos = curr_pos + 1;
    end

    for i = 1:num_vars
      factors(curr_pos) = struct("var", [i], "card", [K], "val", logEmissionProb(marg_ind(i), :));
      curr_pos = curr_pos + 1;
    end

    [marginals, calibrateP] = ComputeExactMarginalsHMM(factors);

    for p = 1:num_vars
      ClassProb(marg_ind(p), :) = exp(marginals(p).val);
    end

    for p = 1:length(pair_ind)
      edge_number = pair_ind(p);
      start_pos = p;
      end_pos = p + 1;
      for f = 1:length(calibrateP.cliqueList)
        curr_factor = calibrateP.cliqueList(f);
        if all(ismember([start_pos, end_pos], curr_factor.var))
          PairProb(edge_number, :) = exp(curr_factor.val - logsumexp(curr_factor.val));
          break;
        end
      end
    end

    loglikelihood(iter) = loglikelihood(iter) + logsumexp(calibrateP.cliqueList(1).val);
  end


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Print out loglikelihood
  disp(sprintf('EM iteration %d: log likelihood: %f', ...
    iter, loglikelihood(iter)));
  if exist('OCTAVE_VERSION')
    fflush(stdout);
  end
  
  % Check for overfitting by decreasing loglikelihood
  if iter > 1
    if loglikelihood(iter) < loglikelihood(iter-1)
      break;
    end
  end
  
end

% Remove iterations if we exited early
loglikelihood = loglikelihood(1:iter);
