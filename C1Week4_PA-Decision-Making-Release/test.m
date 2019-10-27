fullI = load("FullI.mat");
factors = fullI.FullI;
EU1 = SimpleCalcExpectedUtility(factors);

factors.RandomFactors = ObserveEvidence(factors.RandomFactors, [3, 2], 1);
EU2 = SimpleCalcExpectedUtility(factors);