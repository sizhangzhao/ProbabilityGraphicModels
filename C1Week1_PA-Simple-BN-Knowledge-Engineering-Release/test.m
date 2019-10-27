FACTORS.INPUT(1) = struct('var', [1], 'card', [2], 'val', [0.11, 0.89]);
FACTORS.INPUT(2) = struct('var', [2, 1], 'card', [2, 2], 'val', [0.59, 0.41, 0.22, 0.78]);
FACTORS.INPUT(3) = struct('var', [3, 2], 'card', [2, 2], 'val', [0.39, 0.61, 0.06, 0.94]);

%result = FactorProduct(FACTORS.INPUT(1), FACTORS.INPUT(2));

%result = FactorMarginalization(FACTORS.INPUT(2), [2]);
FACTORS.MARGINALIZATION = struct('var', [1], 'card', [2], 'val', [1 1]); 

%result = ObserveEvidence(FACTORS.INPUT, [2 1; 3 2]);
FACTORS.EVIDENCE(1) = struct('var', [1], 'card', [2], 'val', [0.11, 0.89]);
FACTORS.EVIDENCE(2) = struct('var', [2, 1], 'card', [2, 2], 'val', [0.59, 0, 0.22, 0]);
FACTORS.EVIDENCE(3) = struct('var', [3, 2], 'card', [2, 2], 'val', [0, 0.61, 0, 0]);

%result = ComputeJointDistribution(FACTORS.INPUT);
FACTORS.JOINT = struct('var', [1, 2, 3], 'card', [2, 2, 2], 'val', [0.025311, 0.076362, 0.002706, 0.041652, 0.039589, 0.119438, 0.042394, 0.652548]);

result = ComputeMarginal([2, 3], FACTORS.INPUT, [1, 2]);
FACTORS.MARGINAL = struct('var', [2, 3], 'card', [2, 2], 'val', [0.0858, 0.0468, 0.1342, 0.7332]);