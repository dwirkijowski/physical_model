function phymodel(modeltype)
%% Model Sensitivity Study
%
%
% dw 05112017
%% setup st7 file info
pathname = 'C:\Users\DomWirk\Documents\git_dwirkijowski\physical_model\models';
filename = modeltype;
scratchpath = 'C:\Temp';
Task = 'Beam Moment of Inertia';
plotname = filename(1:end-4);

%% setup nfa info
NFAnmodes = 12; % set number of modes to compute
modes = [1:8]; % apriori modes chosen for pairing

%% setup property info
propNum = 1;
range = ['HSS3x2x3/16' 'W6x16' 'W6x12' 'W8x13' 'W10x15' 'W12x16'];
steps = length(range);

%% End of setup ^

% Instantiate st7 model
sys = st7model();
sys.uID = 1;
sys.filename = filename;
sys.pathname = pathname;
sys.scratchpath = scratchpath;

% create nfa object for getting apriori shapes
APsolver = NFA();
APsolver.name = strcat(fullfile(sys.pathname,sys.filename(1:end-4)),'.NFA');
APsolver.nmodes = NFAnmodes;
APsolver.run = 1;

% add plate to parameters
modelP = parameter();
modelP.obj = beam();
modelP.name = name;
modelP.scale = scale;
modelP.obj.propNum = propNum;

% Populate empty parameter fields
% api options
APIop = apiOptions();
APIop.keepLoaded = 1;
APIop.keepOpen = 1;

% start logger
logg = logger(Task);

% get model nodes
% find all deck nodes from model for pairing
deck_nodes = deckNode();
apish(@findNodes,sys,deck_nodes,APIop);
APsolver.nodeid = deck_nodes.id;

% run shell
logg.task('Getting model props');
apish(@getModelProp,sys,modelP,APIop);

% get apriori shapes
logg.task('Setting up solver...');
apish(@solver,sys,APsolver,APIop)

% build model array
for ii = 1:steps

    logg.task('Running sensitivity study',ii,steps);

    % create new instance of nfa class
    % * this is because nfa subclasses the handle class. handles are 
    % persistent. if you create a copy and change it, the original changes 
    % too. we we need to create a new instance. 
    nfa = NFA();
    nfa.name = strcat(fullfile(sys.pathname,sys.filename(1:end-4)), ...
        '_step',num2str(ii),'.NFA');
    nfa.nmodes = NFAnmodes;
    nfa.run = 1;
    nfa.nodeid = deck_nodes.id;

    % Beam properties
    % Create new instance of parameter class
    Para = parameter();
    Para.obj = modelP.obj.clone; % create clone of previously defined beam class
    Para.obj.(modelP.name) = modelP.obj.(modelP.name)*range(ii); % overwrite with step value
    Para.name = modelP.name; % must correspond to the property being altered
    Para.scale = modelP.scale;

    % add sensitivity info to "model" structure
    model(ii).params = Para;
    model(ii).solvers = nfa;
    model(ii).options.populate = 0; % don't repopulate st7 property values

    logg.done();
end

%% run the shell
APIop.keepOpen = 1;

tic
% Run sensitivity shell
apish(@sensitivity,sys,model,APIop);
toc

% save last step model
new_filename = [sys.filename(1:end-4) '_step' num2str(ii) '.st7'];
api.saveas(sys.uID,sys.pathname,new_filename);

%% Close Model
api.closeModel(sys.uID)
sys.open=0;

%% Pair modes and sort frequencies accordingly

for ii = 1:length(model)
    logg.task('Pairing modes',ii,steps);

    % change matrix dimension
    u1 = permute(APsolver.U(:,:,modes),[1 3 2]);
    u2 = permute(model(ii).solvers.U,[1 3 2]);
    % only take translational dof and concat into a column for each mode
    u1 = vertcat(u1(:,:,1),u1(:,:,2),u1(:,:,3));
    u2 = vertcat(u2(:,:,1),u2(:,:,2),u2(:,:,3));

    % use mac values to pair shapes
    id = vibs.pair_modes_unique(u1,u2);
%     id = vibs.pair_modes_plot(u1,u2);
    % sort frequencies
    model(ii).solvers.freq = model(ii).solvers.freq(id);

    logg.done();
end


%% view nfa info
plotParaVsFreq(model,Para,unit);
savefig([plotname '.fig']);
save(plotname,'Para');

%% log shutdown
logg.finish();


end
