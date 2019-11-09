function loglikelihood = E_step(P, poseData, actionData, G, K)

	N = size(poseData, 1);
	numVar = size(poseData, 2);
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
  
  loglikelihood = 0;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  marg_ind = actionData.marg_ind;
  pair_ind = actionData.pair_ind;
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

  loglikelihood = loglikelihood + logsumexp(calibrateP.cliqueList(1).val);
