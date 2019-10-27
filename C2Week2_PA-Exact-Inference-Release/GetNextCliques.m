%GETNEXTCLIQUES Find a pair of cliques ready for message passing
%   [i, j] = GETNEXTCLIQUES(P, messages) finds ready cliques in a given
%   clique tree, P, and a matrix of current messages. Returns indices i and j
%   such that clique i is ready to transmit a message to clique j.
%
%   We are doing clique tree message passing, so
%   do not return (i,j) if clique i has already passed a message to clique j.
%
%	 messages is a n x n matrix of passed messages, where messages(i,j)
% 	 represents the message going from clique i to clique j. 
%   This matrix is initialized in CliqueTreeCalibrate as such:
%      MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);
%
%   If more than one message is ready to be transmitted, return 
%   the pair (i,j) that is numerically smallest. If you use an outer
%   for loop over i and an inner for loop over j, breaking when you find a 
%   ready pair of cliques, you will get the right answer.
%
%   If no such cliques exist, returns i = j = 0.
%
%   See also CLIQUETREECALIBRATE
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function [i, j] = GetNextCliques(P, messages)

% initialization
% you should set them to the correct values in your code
i = 0;
j = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edges = P.edges;
sent = zeros(size(edges));
N = size(edges, 1);
isBreak = false;

for ii = 1:N
	for jj = 1:N
		if length(messages(ii, jj).var) > 0
			sent(ii, jj) = 1;
		end
	end
end

numNeighbor = sum(edges, 1);
sumSent = sum(sent, 2);
sumReceive = sum(sent, 1);

for ii = 1:N
	if isBreak
		break;
	end
	if numNeighbor(ii) == sumSent(ii)
		continue;
	end
	if numNeighbor(ii) == sumReceive(ii)
		for jj = 1:N
			if(sent(ii, jj) == 0 && edges(ii, jj) == 1 && ii ~= jj)
				i = ii;
				j = jj;
				isBreak = true;
				break;
			end
		end
	end
	if numNeighbor(ii) == (sumReceive(ii) + 1)
		for jj = (ii+1):N
			if(sent(ii, jj) == 0 && sent(jj, ii) == 0 && ii ~= jj  && edges(ii, jj) == 1)
				i = ii;
				j = jj;
				isBreak = true;
				break;
			end
		end
	end
end



return;
