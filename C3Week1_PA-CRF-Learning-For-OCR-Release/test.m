% X = load("Train1X.mat");
% X = X.Train1X;
% y = load("Train1Y.mat");
% y = y.Train1Y;
% X2 = load("Train2X.mat");
% y2 = load("Train2Y.mat");
% X2 = X2.Train2X;
% y2 = y2.Train2Y;
% test_X = load("Test1X.mat");
% test_X = test_X.Test1X;
% test_y = load("Test1Y.mat");
% test_y = test_y.Test1Y;
% val_X = load("Validation1X.mat");
% val_X = val_X.Validation1X;
% val_y = load("Validation1Y.mat");
% val_y = val_y.Validation1Y;
% lambda = load("Part1Lambdas.mat");
% lambda = lambda.Part1Lambdas;
% accs = load("ValidationAccuracy.mat");
% accs = accs.ValidationAccuracy;

% thetaOpt = LRTrainSGD(X, y, 0);
% pred = LRPredict(X, thetaOpt);
% accuracy = LRAccuracy(y, pred);

% accuracies = LRSearchLambdaSGD(X, y, val_X, val_y, lambda);

part2 = load("Part2Sample.mat");
X = part2.sampleX;
y = part2.sampleY;
modelParam = part2.sampleModelParams;
thetas = part2.sampleTheta;

modelParam = struct("numHiddenStates", 26, "numObservedStates", 2, "lambda", 0);
% features = GenerateAllFeatures(X, modelParam);

[nll, grad, p, logz] = InstanceNegLogLikelihood(X, y, thetas, modelParam);
[nlld, gradd, pd, logzd] = InstanceNegLogLikelihoodDebug(X, y, thetas, modelParam);