clear;clc;
load("PA4Sample.mat", "NinePersonPedigree"); 
% ComputeMarginal(1, NinePersonPedigree, []);

testdata = load("PA4Test.mat");
% testinput1 = testdata.InitPotential.INPUT;
% res1 = ComputeInitialPotentials(testinput1);

% testGet1 = testdata.GetNextC.INPUT1;
% testGet2 = testdata.GetNextC.INPUT2;
% [res2i, res2j] = GetNextCliques(testGet1, testGet2);

% testcali = testdata.SumProdCalibrate.INPUT;
% res3 = CliqueTreeCalibrate(testcali, 0);

% testBP = testdata.ExactMarginal.INPUT;
% res4 = ComputeExactMarginalsBP(testBP, [], 0);

load('PA4Sample.mat', 'SixPersonPedigree'); 
res5 = ComputeExactMarginalsBP(SixPersonPedigree, [], 0);
res55 = res5(5);
ref5 = ComputeMarginal(5,SixPersonPedigree,[1 1]);

% testMax1 = testdata.FactorMax.INPUT1;
% testMax2 = testdata.FactorMax.INPUT2;
% res5 = FactorMaxMarginalization(testMax1, testMax2);

% testMaxSum = testdata.MaxSumCalibrate.INPUT;
% res6 = CliqueTreeCalibrate(testMaxSum, 1);

% testBPsum = testdata.MaxMarginals.INPUT;
% res7 = ComputeExactMarginalsBP(testBPsum, [], 1);

% testDec = testdata.MaxDecoded.INPUT;
% res8 = MaxDecoding(testDec);

% load('PA4Sample.mat', 'OCRNetworkToRun'); 
% maxMarginals = ComputeExactMarginalsBP(OCRNetworkToRun, [], 1); 
% MAPAssignment = MaxDecoding(maxMarginals); 
% DecodedMarginalsToChars(MAPAssignment)
