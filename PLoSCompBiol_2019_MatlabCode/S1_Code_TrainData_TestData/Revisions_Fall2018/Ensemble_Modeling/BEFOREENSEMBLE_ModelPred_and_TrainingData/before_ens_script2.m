%% COMPARE MODEL PREDICTION AND TRAINING DATA (15-WELL)

close all; clearvars; clc;

load('Results_Summer_2017\model_id\model_id_K14VIMK19_july31.mat');

M = cell( N_AGENT, 1 ); M_HAT = cell( N_AGENT, 1 );
for a = 1 : N_AGENT
    
    % 15-well data for training, even death ( 0h, ..., 72h )
    M{a} = GetCellCtsMATRIX( GetCellCtsCELL( P{a}, d{a}, EVEN_DEATH, 1:N_WELL ), 1:N_WELL ); % all 15 wells
    
    % prediction using A*(15-well), ( 12h, ..., 84h )
    M_HAT{a} = A_STAR{a} * M{a};
    
end
STATE = {'K14^{hi} live', {'VIM^{hi}K14^{low} live'}, {'K19^{hi}VIM^{low}K14^{low} live'}, {'K19^{low}VIM^{low}K14^{low} live'}, 'dying/dead'};

%SeeDynFit( M, M_HAT, N_WELL, AGENT, STATE );

pvals = cell(N_AGENT,1); % pvals{a}{i} = p value to compare observations and predictions, state i, agent a
                         % p value < 0.05 means that the observations and the predictions *are* significantly different

for a = 1 : N_AGENT, pvals{a} = getOBSvsPREDstats( M{a}, M_HAT{a}, N_WELL ); end

%% COMPARE MODEL PREDICTION AND TEST DATA (4-WELL)

close all; clearvars; clc;

load('Results_Summer_2017\test_dyn\K14VIMK19\test_dyn_K14VIMK19_july31.mat');

%M{a} = 4-well data for testing, even death, ( 0h, ..., 60h ), agent a
%M_HAT{a} = prediction using A*(15-well), ( 12h, ..., 72h), agent a

pvals_TEST = cell(N_AGENT,1); % pvals{a}{i} = p value to compare observations and predictions, state i, agent a
                         % p value < 0.05 means that the observations and the predictions *are* significantly different

                                                                  % 4 wells
for a = 1 : N_AGENT, pvals_TEST{a} = getOBSvsPREDstats( M{a}, M_HAT{a}, N_W ); end