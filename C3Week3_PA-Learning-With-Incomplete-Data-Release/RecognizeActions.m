% File: RecognizeActions.m
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

function [accuracy, predicted_labels] = RecognizeActions(datasetTrain, datasetTest, G, maxIter)

% INPUTS
% datasetTrain: dataset for training models, see PA for details
% datasetTest: dataset for testing models, see PA for details
% G: graph parameterization as explained in PA decription
% maxIter: max number of iterations to run for EM

% OUTPUTS
% accuracy: recognition accuracy, defined as (#correctly classified examples / #total examples)
% predicted_labels: N x 1 vector with the predicted labels for each of the instances in datasetTest, with N being the number of unknown test instances


% Train a model for each action
% Note that all actions share the same graph parameterization and number of max iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Classify each of the instances in datasetTrain
% Compute and return the predicted labels and accuracy
% Accuracy is defined as (#correctly classified examples / #total examples)
% Note that all actions share the same graph parameterization

accuracy = 0;
predicted_labels = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_action_type = length(datasetTrain);
parameters = repmat(struct("P", struct(), "ClassProb", [], "PairProb", []), 1, num_action_type);
Ks = zeros(1, num_action_type);

for i = 1:num_action_type
	actionData = datasetTrain(i).actionData;
	poseData = datasetTrain(i).poseData;
	InitialClassProb = datasetTrain(i).InitialClassProb;
	Ks(i) = size(InitialClassProb, 2);
	InitialPairProb = datasetTrain(i).InitialPairProb;
	[P loglikelihood ClassProb PairProb] = EM_HMM(actionData, poseData, G, InitialClassProb, InitialPairProb, maxIter);
	parameters(i) = struct("P", P, "ClassProb", ClassProb, "PairProb", PairProb);
end

actionData = datasetTest.actionData;
poseData = datasetTest.poseData;
labels = datasetTest.labels;
num_actions_test = length(actionData);
predicted_labels = zeros(num_actions_test, 1);

for i = 1:num_actions_test
    i
	action = actionData(i);
	loglikelihoods = zeros(1, num_action_type);
	for a = 1:num_action_type
		loglikelihoods(a) = E_step(parameters(a).P, poseData, action, G, Ks(a));
	end
	[ dummy predicted_labels(i) ] = max(loglikelihoods);
end

accuracy = sum(predicted_labels == labels) / length(labels);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
