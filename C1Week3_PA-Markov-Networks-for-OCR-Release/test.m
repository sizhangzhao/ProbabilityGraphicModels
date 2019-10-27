allWords = importdata("PA3Data.mat");
model = importdata("PA3Models.mat");
imageModel = model.imageModel;
imageModel.ignoreSimilarity=true;
pairwiseModel = model.pairwiseModel;
tripletList = model.tripletList;
samples = importdata("PA3SampleCases.mat");
% [charAcc, wordAcc] = ScoreModel(allWords, imageModel, pairwiseModel, tripletList);

% sampleCases = load('PA3SampleCases.mat');
% 
% model = importdata("PA3Models.mat");
% imageModel = model.imageModel;
% 
% images = sampleCases.Part1SampleImagesInput;
% 
% res = ComputeSingletonFactors(images, imageModel);
% 
% assert(res, sampleCases.Part1SampleFactorsOutput, 1e-15);

images = allWords(1);
% testVar = ComputeSimilarityFactor(images{1,1}, imageModel.K, 1, 2);
testVar = ChooseTopSimilarityFactors(ComputeAllSimilarityFactors(images{1,1}, imageModel.K), 2);