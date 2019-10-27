% function allAcc = LRSearchLambdaSGD(Xtrain, Ytrain, Xvalidation, Yvalidation, lambdas)
% For each value of lambda provided, fit parameters to the training data and return
% the accuracy in the validation data in the corresponding entry of allAcc.
% For instance, allAcc(i) = accuracy in the validation set using lambdas(i).
%
% Inputs:
% Xtrain        training data features   (numTrainInstances x numFeatures)
% Ytrain        training set labels      (numTrainInstances x 1)
% Xvalidation   validation data features (numValidInstances x num features)
% Yvalidation   validation set labels    (numValidInstances x 1)
% lambdas       values of lambda to try  (numLambdas x 1)
%
% Output:
% allAcc        vector of accuracies in validation set  (numLambdas x 1)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

function allAcc = LRSearchLambdaSGD(Xtrain, Ytrain, Xvalidation, Yvalidation, lambdas)

  % You may use the functions we have provided such as LRTrainSGD, LRPredict, and LRAccuracy.
  
  allAcc = zeros(size(lambdas));
  
  %%%%%%%%%%%%%%
  %%% Student code
  for i = 1:length(lambdas)
    thetaOpt = LRTrainSGD(Xtrain, Ytrain, lambdas(i));
  	pred = LRPredict(Xvalidation, thetaOpt);
	  allAcc(i) = LRAccuracy(Yvalidation, pred);
	end


  %%%%%%%%%%%  
 
end 
