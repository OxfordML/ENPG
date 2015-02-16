% Report all instances of a particular 'query motif' H in a provenance graph G
% Mark Ebden, October 2014
%
% Inputs:
% - G is mxm, H is nxn. Both are matrices of edge attributes (binary encoded)
% - typesG and typesH list the node types (1 = entity, 2 = process, 3 = agent)
% - attG and attH list the node attributes of G and H
% Output: M is a matrix n columns wide. Each row corresponds to a motif mapping.
%
% Note that:
% - In G (but not in H) two nodes can have more than one mutual
%   edge, so binary coding is used in the recursive function.
% - In G (but not in H), there can be graph cycles.
% - H thus encodes a tree. The nodes must be ordered such that each node's 
%   parent is somewhere to its left
% - Directionality of all edges is ignored.
%
% Example call:
% G = [0 2 1 0 0 0; 0 0 8 0 0 4; 0 0 0 0 2 0; 0 0 1 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0]; typesG = [1 2 1 1 2 3]; 
% H = [0 2 1; 0 0 0; 0 0 0]; typesH = [1 2 1]; % chevron of process and two entities
% M = getMotifs (G,H,typesG,typesH)
% Example of a real graph: https://provenance.ecs.soton.ac.uk/store/documents/25793

function M = getMotifs (G,H,typesG,typesH,attG,attH,namesG,namesH)

% A. Inputs
if nargin < 7,
    namesG = cell(1,size(G,1)); namesH = cell(1,size(H,1));
    if nargin < 5,
        attG = cell(1,size(G,1)); attH = cell(1,size(H,1));
        if nargin < 3,
            typesG = ones(1,size(G,1));
            typesH = ones(1,size(H,1));
        end
    end
end
if ~isequal(G,G'), % in Matlab R2014, 'issymmetric' is an alternative
    G = G + G';
end
if ~isequal(H,H'),
    H = H + H';
end

% B. Initializations
n = size(G,1); m = size(H,1);
statics.G=G; statics.H=H; statics.typesG=typesG; statics.typesH=typesH;
statics.attG=attG; statics.attH=attH; statics.namesG=namesG; statics.namesH=namesH;

% C. Find the motifs in G
M = []; % each row is a possible 1xm mapping of H to G
for i = 1:n, % the i'th node of G is the starting node; cycle through all n nodes in G for this
  if typesG(i) == typesH(1), % For each node, don't just launch in with a pN - must test the first element
    if any(attH{1}), % consider whether there is any node attribute in the motif
      matchingA = 0; % the node-attribute match is assumed not to occur, unless shown otherwise
      for u1 = 1:length(attG{i}), % cycle through all attributes of the starting node in G
        if any(strfind(attG{i}{u1},attH{1})), % see if H's string is within the G string
          matchingA = 1; % note the search for a match could be generalized to other inter-node compatibilities
        end
      end
    else
      matchingA = 1; % no node attributes to check for
    end
    if matchingA == 1, % so far the node type and node attributes match
      matchingN = 1; % the node-name match is assumed to occur, unless shown otherwise
      if any(namesH{1}), % consider whether there is a node name specified in the motif
        if ~any(strfind(namesG{i},namesH{1})), % see if H's string is within the G string
          matchingN = 0; % again the search for a match could be generalized to other inter-node compatibilities
        end 
      end
      if matchingN == 1, % the node type, attributes, and name match
        %disp(['**********' num2str(i) '**********'])
        pN = zeros(1,m); pN(1) = i; % initializing the motif assignment
        inducedSubgraphs = findMotifs (pN, statics); % begin recursive search. output has m columns
        M = [M; inducedSubgraphs]; % might add multiple rows at a time
      end
    end
  end
end

% D. Remove multiple-counting
M = unique(M,'rows'); % NB the computing time of this command is linear in the number of rows

if isempty(attH) && isempty(namesH), % all entities equivalent, ditto for processes and agents
    sM = sort(M,2); [~,u] = unique(sM,'rows');
    M = M(u,:); % a more concise listing of the induced subgraphs
end
