function accuracy = ClassifyDataset(dataset, labels, P, G)
% returns the accuracy of the model P and graph G on the dataset 
%
% Inputs:
% dataset: N x 10 x 3, N test instances represented by 10 parts
% labels:  N x 2 true class labels for the instances.
%          labels(i,j)=1 if the ith instance belongs to class j 
% P: struct array model parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description) 
%
% Outputs:
% accuracy: fraction of correctly classified instances (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset, 1);
numVar = size(dataset, 2);
K = size(labels, 2);
accuracy = 0.0;
predictions = zeros(size(labels));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:N
	classifiedK = 1;
	lll = -Inf;
	sample = squeeze(dataset(i, :, :));
	for c = 1:K
		ll = log(P.c(c));
		if length(size(G)) == 2
			currG = G;
		else
			currG = squeeze(G(:, :, c));
		end
		for p = 1:numVar
			currSigmaX = P.clg(p).sigma_x(c);
			currSigmaY = P.clg(p).sigma_y(c);
			currSigmaAngle = P.clg(p).sigma_angle(c);
			if currG(p, 1) == 0
				currMeanX = P.clg(p).mu_x(c);
				currMeanY = P.clg(p).mu_y(c);
				currMeanAngle = P.clg(p).mu_angle(c);
			else
				parent = currG(p, 2);
				currMeanY = P.clg(p).theta(c, 1) + [P.clg(p).theta(c, 2), P.clg(p).theta(c, 3), P.clg(p).theta(c, 4)] * sample(parent, :)';
				currMeanX = P.clg(p).theta(c, 5) + [P.clg(p).theta(c, 6), P.clg(p).theta(c, 7), P.clg(p).theta(c, 8)] * sample(parent, :)';
				currMeanAngle = P.clg(p).theta(c, 9) + [P.clg(p).theta(c, 10), P.clg(p).theta(c, 11), P.clg(p).theta(c, 12)] * sample(parent, :)';
			end
			ll = ll + lognormpdf(sample(p, 2), currMeanX, currSigmaX) + lognormpdf(sample(p, 1), currMeanY, currSigmaY) + lognormpdf(sample(p, 3), currMeanAngle, currSigmaAngle);
		end
		if(ll > lll)
			classifiedK = c;
			lll = ll;
		end
	end
	predictions(i, classifiedK) = 1;
end

dif = predictions - labels;
dif = dif(:, 1);
correct = sum(dif == 0);
accuracy = correct / N;

fprintf('Accuracy: %.2f\n', accuracy);