function factors = ComputePairwiseFactors (images, pairwiseModel, K)
% This function computes the pairwise factors for one word and uses the
% given pairwise model to set the factor values.
%
% Input:
%   images: An array of structs containing the 'img' value for each
%     character in the word.
%   pairwiseModel: The provided pairwise model. It is a K-by-K matrix. For
%     character i followed by character j, the factor value should be
%     pairwiseModel(i, j).
%   K: The alphabet size (accessible in imageModel.K for the provided
%     imageModel).
%
% Output:
%   factors: The pairwise factors for this word.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

n = length(images);

% If there are fewer than 2 characters, return an empty factor list.
if (n < 2)
    factors = [];
    return;
end

factors = repmat(struct('var', [], 'card', [], 'val', []), n - 1, 1);

% Your code here:
card = [K, K];
assignments = IndexToAssignment(1:prod(card), card);

for i = 1:n-1
	factors(i).var = [i+1, i];
	factors(i).card = card;
	factors(i).val = ones(prod(card),1);
	for j = 1:(size(assignments, 1))
		factors(i).val(j) = pairwiseModel(assignments(j, 2), assignments(j, 1));
	end
end

end
