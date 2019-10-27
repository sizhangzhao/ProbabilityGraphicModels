clear;clc;

I = load("TestI0.mat");
I = I.TestI0;
test_factor = I.RandomFactors(10);

I.RandomFactors(10) = struct('var', [], 'card', [], 'val', []);
[baseline_meu, baseline_opt] = OptimizeWithJointUtility(I);

I.DecisionFactors(1) = struct('var', [9, 11], 'card', [2, 2], 'val', [0, 0, 0, 0]);

test_factor.val = [0.75, 0.25, 0.001, 0.999];
I.RandomFactors(10) = test_factor;
[meu_1, opt_1] = OptimizeWithJointUtility(I);
dollar1 = exp((meu_1 - baseline_meu) / 100) - 1;

test_factor.val = [0.999, 0.001, 0.25, 0.75];
I.RandomFactors(10) = test_factor;
[meu_2, opt_2] = OptimizeWithJointUtility(I);
dollar2 = exp((meu_2 - baseline_meu) / 100) - 1;

test_factor.val = [0.999, 0.001, 0.001, 0.999];
I.RandomFactors(10) = test_factor;
[meu_3, opt_3] = OptimizeWithJointUtility(I);
dollar3 = exp((meu_3 - baseline_meu) / 100) - 1;