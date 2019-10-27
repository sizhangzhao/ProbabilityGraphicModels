%COMPUTEINITIALPOTENTIALS Sets up the cliques in the clique tree that is
%passed in as a parameter.
%
%   P = COMPUTEINITIALPOTENTIALS(C) Takes the clique tree skeleton C which is a
%   struct with three fields:
%   - nodes: cell array representing the cliques in the tree.
%   - edges: represents the adjacency matrix of the tree.
%   - factorList: represents the list of factors that were used to build
%   the tree. 
%   
%   It returns the standard form of a clique tree P that we will use through 
%   the rest of the assigment. P is struct with two fields:
%   - cliqueList: represents an array of cliques with appropriate factors 
%   from factorList assigned to each clique. Where the .val of each clique
%   is initialized to the initial potential of that clique.
%   - edges: represents the adjacency matrix of the tree. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function P = ComputeInitialPotentials(C)

% number of cliques
N = length(C.nodes);

% initialize cluster potentials 
P.cliqueList = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
P.edges = zeros(N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% First, compute an assignment of factors from factorList to cliques. 
% Then use that assignment to initialize the cliques in cliqueList to 
% their initial potentials. 

% C.nodes is a list of cliques.
% So in your code, you should start with: P.cliqueList(i).var = C.nodes{i};
% Print out C to get a better understanding of its structure.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% assignments = {};

factors = C.factorList;
nodes = C.nodes;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for i = 1:N
% 	% assignments{i} = [];
% 	first = true;
% 	for j = 1:length(factors)
% 		contained = ismember(factors(j).var, nodes{i});
% 		if i == 8
% 			node = nodes{i};
% 		end
% 		if all(contained)
% 			if first
% 				temVar = factors(j).var(1);
% 				temCard = factors(j).card(1);
% 				clique = struct('var', [temVar], 'card', [temCard], 'val', ones(1, temCard));
% 				first = false;
% 			end
% 			clique = FactorProduct(clique, factors(j));
% 		end
% 	end
% 	P.cliqueList(i) = clique;
% end

% P.edges = C.edges;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vars = unique([factors(:).var]);
numVar = max(vars);
cards = zeros(1, numVar);
numVar = length(vars);
for i = 1:length(factors)
	if numVar == 0
		break;
	end
	factor_var = factors(i).var;
	factor_card = factors(i).card;
	for j = 1:length(factor_var)
		if cards(factor_var(j)) == 0
			cards(factor_var(j)) = factor_card(j);
			numVar = numVar - 1;
		end
	end
end

for i = 1:N
	P.cliqueList(i).var = nodes{i};
	card = zeros(1, length(nodes{i}));
	for j = 1:length(nodes{i})
		card(j) = cards(nodes{i}(j));
	end
	P.cliqueList(i).card = card;
	P.cliqueList(i).val = ones(1,prod(P.cliqueList(i).card));
end

alpha = zeros(length(C.factorList),1);

% for i = 1:N
% 	for j = 1:length(factors)
% 		contained = isempty(setdiff(factors(j).var, nodes{i}));
% 		if contained
% 			alpha(j) = i;;
% 		end
% 	end
% end

for i = 1:length(factors),
    for j = 1:N,

        % does clique contain all variables in factor
        if (isempty(setdiff(factors(i).var, nodes{j}))),
            P.cliqueList(j) = FactorProduct(P.cliqueList(j), factors(i)); 
            break;
        end;
    end;
end;


% for i = 1:length(alpha),
%     P.cliqueList(alpha(i)) = FactorProduct(P.cliqueList(alpha(i)), factors(i));    
% end;

P.edges = C.edges;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% P.cliqueList = C.factorList;

% % number of cliques
% N = length(C.nodes);

% % compute assignment of factors to cliques
% alpha = zeros(length(C.factorList),1);

% % Setting up the cardinality 
% V = unique([C.factorList(:).var]);

% C.card = zeros(1, length(V));
% for i = 1 : length(V),

%     for j = 1 : length(C.factorList)
%         if (~isempty(find(C.factorList(j).var == i)))
%             C.card(i) = C.factorList(j).card(find(C.factorList(j).var == i));
%             break;
%         end
%     end
% end

% for i = 1:length(C.factorList),
%     for j = 1:N,

%         % does clique contain all variables in factor
%         if (isempty(setdiff(C.factorList(i).var, C.nodes{j}))),
%             alpha(i) = j;
%             break;
%         end;
%     end;
% end;

% if (any(alpha == 0)),
%     warning('Clique Tree does not have family preserving property');
% end;

% P.edges = C.edges;

% % initialize cluster potentials 
% P.cliqueList = repmat(struct('var', [], 'card', [], 'val', []), N, 1);

% for i = 1:N,
%     P.cliqueList(i).var = C.nodes{i};
%     P.cliqueList(i).card = C.card(P.cliqueList(i).var);
%     P.cliqueList(i).val = ones(1,prod(P.cliqueList(i).card));
% end;

% for i = 1:length(alpha),
%     P.cliqueList(alpha(i)) = FactorProduct(P.cliqueList(alpha(i)), C.factorList(i));    
% end;


end

