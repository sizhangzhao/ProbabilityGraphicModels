data = load("PA8Data.mat");
cases = load("PA8SampleCases.mat");

G1 = data.G1;
G2 = data.G2;
trainData = data.trainData;
testData = data.testData;

exampleInput = cases.exampleINPUT;
exampleOutput = cases.exampleOUTPUT;

[P1, l1] = LearnCPDsGivenGraph(trainData.data, G1, trainData.labels);
[P2, l2] = LearnCPDsGivenGraph(trainData.data, G2, trainData.labels);

accuracy1 = ClassifyDataset(testData.data, testData.labels, P1, G1);
accuracy2 = ClassifyDataset(testData.data, testData.labels, P2, G2);
VisualizeModels(P1, G1);
VisualizeModels(P2, G2);
