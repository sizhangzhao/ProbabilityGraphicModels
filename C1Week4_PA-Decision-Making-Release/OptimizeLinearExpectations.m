% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeLinearExpectations( I )
  % Inputs: An influence diagram I with a single decision node and one or more utility nodes.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  % You may assume that there is a unique optimal decision.
  %
  % This is similar to OptimizeMEU except that we will have to account for
  % multiple utility factors.  We will do this by calculating the expected
  % utility factors and combining them, then optimizing with respect to that
  % combined expected utility factor.  
  MEU = [];
  OptimalDecisionRule = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  % A decision rule for D assigns, for each joint assignment to D's parents, 
  % probability 1 to the best option from the EUF for that joint assignment 
  % to D's parents, and 0 otherwise.  Note that when D has no parents, it is
  % a degenerate case we can handle separately for convenience.
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  U = I.UtilityFactors;
  D = I.DecisionFactors(1);
  eufs = [];
  
  for i = 1:length(U)
    temU = I;
    temU.UtilityFactors = [U(i)];
    euf = CalculateExpectedUtilityFactor(temU);
    eufs = [eufs, euf];
  end

  % EUF = FactorSum(eufs);

  EUF = eufs(1);

  for i = 2:length(eufs)
    EUF = FactorSum2(EUF, eufs(i));
  end

  OptimalDecisionRule = D;
  index = zeros(1, length(D.var));

  varD = D.var(1);

  for i = 1:length(EUF.var)
    currVar = EUF.var(i);
    indices = find(D.var == currVar);
    index(i) = indices(1);
    if currVar == varD
      posD = i;
    end
  end

  assignments = IndexToAssignment(1:length(D.val), D.card);
  for i = 2:2:size(assignments, 1)
    assignment = assignments(i,:);
    corAssignment = assignment;
    for j = 1:length(assignment)
      corAssignment(j) = assignment(index(j));
    end
    corAssignment(posD) = 1;
    corIndex = AssignmentToIndex(corAssignment, EUF.card);
    val0 = EUF.val(corIndex);
    corAssignment(posD) = 2;
    corIndex = AssignmentToIndex(corAssignment, EUF.card);
    val1 = EUF.val(corIndex);
    if val0 > val1
      OptimalDecisionRule.val(i-1) = 1;
      OptimalDecisionRule.val(i) = 0;
    else
      OptimalDecisionRule.val(i-1) = 0;
      OptimalDecisionRule.val(i) = 1;
    end

    I.DecisionFactors = [OptimalDecisionRule];
    I.UtilityFactors = [EUF];
    I.RandomFactors = [];
    MEU = SimpleCalcExpectedUtility(I);


end
