% Copyright (C) Daphne Koller, Stanford University, 2012

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test case 1 - a very simple influence diagram in which X1 is a random variable
% and D is a decision.  The utility U is a function of X1 and D.  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X1 = struct('var', [1], 'card', [2], 'val', [7, 3]);
X1.val = X1.val / sum(X1.val);
D = struct('var', [2], 'card', [2], 'val', [1 0]);
U1 = struct('var', [1, 2], 'card', [2, 2], 'val', [10, 1, 5, 1]);

I1.RandomFactors = X1;
I1.DecisionFactors = D;
I1.UtilityFactors = U1;

% All possible decision rules.
D1 = D;
D2 = D;
D2.val = [0 1];
AllDs = [D1 D2];

allEU = zeros(length(AllDs),1);
for i=1:length(AllDs)
  I1.DecisionFactors = AllDs(i);
  allEU(i) = SimpleCalcExpectedUtility(I1);
end

% OUTPUT
% allEU => [7.3000, 3.8000]

% Get EUF...
euf = CalculateExpectedUtilityFactor(I1);
PrintFactor(euf)
% PrintFactor(euf) =>
% 2	
% 1	7.300000
% 2	3.800000

[meu0 optdr0] = OptimizeMEU(I1)
PrintFactor(optdr0);
[meu1 optdr1] = OptimizeWithJointUtility(I1)
PrintFactor(optdr1);
[meu2 optdr2] = OptimizeLinearExpectations(I1)
PrintFactor(optdr2);
% OUTPUT
% All should have the same results: 
% meu => 7.3000
% PrintFactor(optdr) => 
%     2     0
%     1     1
%     2     0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test case 2 - Introduce a random variable node X3 between U and the 
% variable X1.  D acts on X3 instead of X1 now, but still contributes directly
% to the utility.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add node between 1 and 2 and the utility
X1 = struct('var', [1], 'card', [2], 'val', [7, 3]);
X1.val = X1.val / sum(X1.val);
D = struct('var', [2], 'card', [2], 'val', [1 0]);
X3 = struct('var', [3,1,2], 'card', [2,2,2], 'val', [4 4 1 1 1 1 4 4]);
X3 = CPDFromFactor(X3,3);

% U is now a function of 3 instead of 2.
U1 = struct('var', [2,3], 'card', [2, 2], 'val', [10, 1, 5, 1]);

I2.RandomFactors = [X1 X3];
I2.DecisionFactors = D;
I2.UtilityFactors = U1;

% All possible decision rules.
D1 = D;
D2 = D;
D2.val = [0 1];
AllDs = [D1 D2];

allEU = zeros(length(AllDs),1);
for i=1:length(AllDs)
  I2.DecisionFactors = AllDs(i);
  allEU(i) = SimpleCalcExpectedUtility(I2);
end
% OUTPUT
% allEU => [7.5000, 1.0000]

% Get EUF...
euf = CalculateExpectedUtilityFactor(I2);
% PrintFactor(euf) =>
% 2	
% 1	7.500000
% 2	1.000000

[meu00 optdr00] = OptimizeMEU(I2)
PrintFactor(optdr00);
[meu11 optdr11] = OptimizeWithJointUtility(I2)
PrintFactor(optdr11);
[meu22 optdr22] = OptimizeLinearExpectations(I2)
PrintFactor(optdr22);
% OUTPUT
% meu => 7.5000
% PrintFactor(optdr) => 
% 2     0
% 1     1
% 2     0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test case 3 - Make D a function of X1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X1 = struct('var', [1], 'card', [2], 'val', [7, 3]);
X1.val = X1.val / sum(X1.val);
D = struct('var', [2,1], 'card', [2,2], 'val', [1,0,0,1]);
X3 = struct('var', [3,1,2], 'card', [2,2,2], 'val', [4 4 1 1 1 1 4 4]);
X3 = CPDFromFactor(X3,3);

% U is now a function of 3 instead of 2.
U1 = struct('var', [2,3], 'card', [2, 2], 'val', [10, 1, 5, 1]);

I3.RandomFactors = [X1 X3];
I3.DecisionFactors = D;
I3.UtilityFactors = U1;

% All possible decision rules
D1 = D;D2 = D;D3 = D;D4 = D;
D1.val = [1 0 1 0];
D2.val = [1 0 0 1];
D3.val = [0 1 1 0];
D4.val = [0 1 0 1];

AllDs = [D1 D2 D3 D4];
allEU = zeros(length(AllDs),1);
for i=1:length(AllDs)
  I3.DecisionFactors = AllDs(i);
  allEU(i) = SimpleCalcExpectedUtility(I3);
end

% Get EUF...
euf = CalculateExpectedUtilityFactor(I3);
% PrintFactor(euf) =>
% 1	2	
% 1	1	5.250000
% 2	1	2.250000
% 1	2	0.700000
% 2	2	0.300000

[meu000 optdr000] = OptimizeMEU(I3)
PrintFactor(optdr000);
[meu111 optdr111] = OptimizeWithJointUtility(I3)
PrintFactor(optdr111);
[meu222 optdr222] = OptimizeLinearExpectations(I3)
PrintFactor(optdr222);
% OUTPUT
% allEU =
% 7.5000
% 5.5500
% 2.9500
% 1.0000
% meu = 7.5000
% PrintFactor(optdr) => 
% 1	2	
% 1	1	1.000000
% 2	1	1.000000
% 1	2	0.000000
% 2	2	0.000000

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test case 4 - Add another utility node that is a function of D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X1 = struct('var', [1], 'card', [2], 'val', [7, 3]);
X1.val = X1.val / sum(X1.val);
D = struct('var', [2,1], 'card', [2,2], 'val', [1,0,0,1]);
X3 = struct('var', [3,1,2], 'card', [2,2,2], 'val', [4 4 1 1 1 1 4 4]);
X3 = CPDFromFactor(X3,3);

% U is now a function of 3 instead of 2.
U1 = struct('var', [2,3], 'card', [2, 2], 'val', [10, 1, 5, 1]);
U2 = struct('var', [2], 'card', [2], 'val', [1, 10]);

I4.RandomFactors = [X1 X3];
I4.DecisionFactors = D;
I4.UtilityFactors = [U1 U2];

[meu1111 optdr1111] = OptimizeWithJointUtility(I4)
PrintFactor(optdr1111);
[meu2222 optdr2222] = OptimizeLinearExpectations(I4)
PrintFactor(optdr2222);
% OUTPUT
% meu => 11
% PrintFactor(optdr) => 
% 1	2	
% 1	1	0.000000
% 2	1	0.000000
% 1	2	1.000000
% 2	2	1.000000

