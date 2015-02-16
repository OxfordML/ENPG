% Recursive function called by getMotifs.m.  By Mark Ebden, October 2014.
% Inputs a 1xn vector (pN) of what nodes have been tapped in the past.
% The 'statics' are, for each of the provenance graph and the motif graph:
% adjacency matrix, node types, node attributes, and node names.
% Outputs an m-column matrix (indTot) of possible 1xm mappings of H to G.
% Also outputs a success indicator (returnCode) which is '1' if an 
% additional motif has been found in that function call.

function [indTot, returnCode] = findMotifs (pN, statics)
G=statics.G; H=statics.H; typesG=statics.typesG; typesH = statics.typesH;
attG=statics.attG; attH=statics.attH; namesG=statics.namesG; namesH=statics.namesH;

n = size(G,1); m = size(H,1);
spN = num2str(pN);

pvec = find(pN>0); % prospective parents for the next unassigned node in H
if length(pvec) < length(pN), % if any H nodes have yet to be assigned to G nodes
  indTot = []; % growing matrix of answers
  returnCode = 0; % signals that a new answer has been generated here or downstream
  H_index = length(pvec)+1; % In this function call we will find a G node to match to the H node corresponding to the first zero in pN
  for P_index = fliplr(pvec), % cycle through the prospective parents for the H_index node
    G_index = pN(P_index); % consider a node which had previously been added to the motif
    Gconnects = G(G_index,:); % list of candidate neighbours for this node which had previously been added to the motif
    EA = H(P_index,H_index); % the edge attribute required (eg 'UsedBy' might be 'EA = 4')
    u = checkBinCode (Gconnects, EA)'; % see which neighbours' edges are compatible with the H node
    u = setdiff(u,pN); % exclude nodes which are already in the motif (no cycles permitted in H)
    for i = 1:length(u), % cycle through the candidate neighbours
      neigh_index = u(i); % the index to the candidate neighbour
      if typesG(neigh_index) == typesH(H_index), % the type of node (eg 'entity') matches
        if any(attH{H_index}), % consider whether there is any node attribute in the motif
          matchingA = 0; % the node-attribute match is assumed not to occur until proven otherwise
          for u1 = 1:length(attG{neigh_index}), % cycle through all attributes of the G node
            if any(strfind(attG{neigh_index}{u1},attH{H_index})), % see if H's string is within the G string
              matchingA = 1; % note the search for a match could be generalized to other inter-node compatibilities
            end
          end
        else
          matchingA = 1; % no node attributes to check for
        end
        if matchingA == 1, % so far the node type and node attributes match
          matchingN = 1; % the node-name match is assumed until shown otherwise
          if any(namesH{H_index}), % consider whether there is a node name specified in the motif
            if ~any(strfind(namesG{neigh_index},namesH{H_index})), % see if H's string is within the G string
              matchingN = 0; % again the search for a match could be generalized to other inter-node compatibilities
            end 
          end
          if matchingN == 1, % so far the node type, attributes, and name match
            pN(H_index) = neigh_index; % assign this G node to the motif and move on to the next H index with recursion
            [tempInd, returnC] = findMotifs (pN, statics);
            if returnC == 1, % the function call successfully found a new motif
              indTot = unique([indTot; tempInd], 'rows'); % add this complete motif to the list of answers
              returnCode = 1; % it just takes one success within this .m file to flag returnCode
            end
          end
        end
      end
    end
  end
else
  indTot = pN;
  returnCode = 1; % All entries in pN have been assigned
end
