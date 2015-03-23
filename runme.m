% Matlab code to accompany the HAIDM workshop paper in AAMAS 2015
% by Ebden, Huynh, Moreau, and Roberts. March 2015
%
%         runme.m - top-level file
%     prov31545.m - loads a small provenance graph (Graph 'A' of the paper)
%  getSubgraphs.m - a wrapper to call findSubgraphs.m, returning a graph's subgraphs
% findSubgraphs.m - the recursive function outlined in 'Algorithm 1' of the paper
%  checkBinCode.m - called by findSubgraphs.m to compare two graph edges

% Inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
playerid = 'transporter88'; % the name of the human who will receive the incentivizing message
tasktype = 'WaterSource'; % what kind of task to search for in that player's provenance-graph history

% Initializations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prov31545
if ~isequal(A,A'), % in Matlab R2014, 'issymmetric' is an alternative
    A = A + A'; % Recall that 'A' contains binary encodings, not just 1's
end

% Preprocessing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In linear time, identify the nodes that are:
% - target-related entities (type 4, eg 'Patient23.1'), or
% - target-connected agent-instantiations (type 5, eg 'soldier92.1')
for i=find(T==1)
    l = N{i};
    u = [strfind(l,'Animal') strfind(l,'Patient') strfind(l,'Fuel') strfind(l,'Radioactive') ...
    strfind(l,'WaterSource') strfind(l,'InfrastructureDamage') strfind(l,'MedicalEmergency') strfind(l,'Crime')];
    if min(u) > 0, % the entity name contains that of a target
       T(i) = 4; % See first paragraph of the appendix
    end
end
for i=find(T==1)
    l = N{i};
    u = [strfind(l,'soldier') strfind(l,'medic') strfind(l,'transporter') strfind(l,'firefighter')];
    if min(u) > 0, % the entity name contains that of an agent
        u1 = 0;
        u2 = find(A(i,:)>0);
        while u1 < length(u2),
            u1 = u1 + 1;
            % we seek an instantiated player, not e.g. an entity related to text messages
            if T(u2(u1)) == 4 || T(u2(u1)) == 2, % this agent-instantiation entity is connected to a target-entity or a (target) activity
                T(i) = 5; % useful instantiation
            end
        end
    end
end

% Design subgraph M2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = [0 8 0 0; 0 0 16 0; 0 0 0 16; 0 0 0 0]; % adjacency matrix (8=specializationOf, 16=wasDerivedFrom, 512=Used, etc)
typesI = [3 5 4 4]; % node types: 1=certain entities, 2=certain activities, 3=agent, 4=target-related entity, 5=agent-instantiation entity
attI = cell(1,size(I,1)); % node attributes
namesI = cell(1,size(I,1)); % node names
namesI{4} = ['Safe' tasktype]; % specification of a node-name constraint for this subgraph
namesI{1} = playerid; % this subgraph detection will be run twice: first for the player itself

% Print a message %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M2 = getSubgraphs (A,I,T,typesI,W,attI,N,namesI); % returns subgraph instances
if any(M2),
  disp('You have completed this type of task before.')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
