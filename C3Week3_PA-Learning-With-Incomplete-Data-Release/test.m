% a = [1,2;3,4;5,6];
% mu = ones(size(a));
% sigma = ones(size(a));

% p = lognormpdf(a, mu, sigma);

data = load("PA9SampleCases.mat");
inputData = data.exampleINPUT;
outputData = data.exampleOUTPUT;

%[P loglikelihood ClassProb] = EM_cluster(inputData.t1a1, inputData.t1a2, inputData.t1a3, 2);

% [P loglikelihood ClassProb PairProb] = EM_HMM(inputData.t2a1, inputData.t2a2, inputData.t2a3, inputData.t2a4, inputData.t2a5, 1);

load PA9Data;
%[accuracy, predicted_labels] = RecognizeActions(datasetTrain1, datasetTest1, G, 10);
predicted_labels = RecognizeUnknownActions(datasetTrain1, datasetTest1, G, 10);