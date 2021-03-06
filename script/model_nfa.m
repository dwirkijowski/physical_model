%% Physical Model Script
%
% dw 05112017

%% setup st7model class
sys = st7model();
sys.pathname = 'C:\Users\DomWirk\Documents\git_dwirkijowski\physical_model\models';
sys.filename = filename;
sys.scratchpath = 'C:\Temp';

%% setup nfa solver info
% Note that nfa.coords [x,y] is an optional input - nfa will snap or 
% default to all nodes
nfa = NFA();
nfa.name = fullfile(sys.pathname,[sys.filename(1:end-4) '.NFA']);
nfa.nmodes = 10; % set number of modes to compute
nfa.run = 1;

%% setup node restraints
bc = boundaryNode();
bc.nodeid = [1 11]; % fully fixed at nodes 1 and 11
bc.restraint = ones(length(bc.nodeid),6); % [nnodes x 6dof]
bc.fcase = ones(size(bc.nodeid));         % [nnodes x 1]

%% assign input structures to main model structure
model.sys = sys;
model.nfa = nfa;
model.bc = bc;

%% run the apis-shell using main function
fcn = @main;
results = apish(fcn,model);

%% view frequencies
fprintf('Natural Frequencies [Hz]:\n');
fprintf('\t%f\n',results.nfa.freq);
