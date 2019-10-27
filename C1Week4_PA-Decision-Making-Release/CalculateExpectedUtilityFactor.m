% Copyright (C) Daphne Koller, Stanford University, 2012

function EUF = CalculateExpectedUtilityFactor( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: A factor over the scope of the decision rule D from I that
  % gives the conditional utility given each assignment for D.var
  %
  % Note - We assume I has a single decision node and utility node.
  EUF = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

  F = [I.RandomFactors, I.UtilityFactors];
  DandParent = I.DecisionFactors(1).var;

  Z = [];

  for i = 1:length(F)
    Z = union(Z, F(i).var); %F(:).var
  end

  Z = setdiff(unique(Z), DandParent);

  ParFactors = VariableElimination(F, Z);

  newFactor = ParFactors(1);
  for i = 2:length(ParFactors)
    newFactor = FactorProduct(newFactor,ParFactors(i));
  end

  EUF = newFactor;
  
end  
