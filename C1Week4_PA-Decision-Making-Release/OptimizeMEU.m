% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeMEU( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  
  % We assume I has a single decision node.
  % You may assume that there is a unique optimal decision.
  D = I.DecisionFactors(1);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  % 
  % Some other information that might be useful for some implementations
  % (note that there are multiple ways to implement this):
  % 1.  It is probably easiest to think of two cases - D has parents and D 
  %     has no parents.
  % 2.  You may find the Matlab/Octave function setdiff useful.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    EUF = CalculateExpectedUtilityFactor(I);
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
      MEU = SimpleCalcExpectedUtility(I);
end
