%% Get dynamics with extra constraints

close all; clearvars; clc;

load('Results_Summer_2017\model_id\model_id_K14VIMK19_july31.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK constraints in try_argmin_A_Xfix.m

% For "Role of ?12-decrease and ?31-increase in Trametinib-induced K14hi enrichment" (Tram. hyp.)
drug = 2;                                % Drug of interest is Trametinib
mystate = 1;                             % State of interest is K14hi live
mytitle = 'Tram., K14^{hi} live';

% For "Role of ?12-decrease and ?32-decrease in Comb.-induced VIMhiK14low de-enrichment" (Comb. hyp.)
% drug = 4;                                  % Drug of interest is Combination
% mystate = 2;                               % State of interest is VIMhiK14low live
% mytitle = 'Comb., VIM^{hi}K14^{low} live';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ A_extracon, ~, ~, ~ ] = try_IdentifyDynamics( lambdas, epsilon, EVEN_DEATH, P{drug}, d{drug}, N_CV, N_WELL, NaN ); 

%% Test new model with extra constraints. 
% For Tram. hyp., can it replicate K14hi enrichment observed in 4-well test data?
% For Comb. hyp., can it replicate VIMhiK14low de-enrichment observed in 4-well test data?

N_W = 4; TIME = 0: 12: 60; M_byWell = zeros( N_W, length(TIME) ); MHAT_byWell = M_byWell; 

% Phenotype & death timeseries 4-well raw data for each agent
[ P4W, d4W ] = SortBySeries( SortRawData( 'Timeseries_Raw_4wells.xlsx', SHEET_NAME, COL_ROW_1, 'K124', N_AGENT, N_TIME-1, N_W ) );

% All 4 wells, test data, drug of interest, (0h, ..., 60h)
M = GetCellCtsMATRIX( GetCellCtsCELL( P4W{drug}, d4W{drug}, EVEN_DEATH, 1:N_W ), 1:N_W );

% Prediction using A*(15-well, w/ extra constraints), ( 12h, ..., 72h )
MHAT = A_extracon * M;

        % 0h           12h, ..., 60h
MHAT = [ M( :, 1:N_W ) MHAT( :, 1:end-N_W ) ]; 

for w = 1 : N_W 
    
    M_byWell( w, : ) = M( mystate, w: N_W: end ); % #live of particular phenotype, well w, (0h, 12h, ..., 60h)  
    
    MHAT_byWell( w, : ) = MHAT( mystate, w: N_W: end ); 

end
    
% errorbar(X,Y,E) plots Y versus X with symmetric vertical error bars 2*E(i) long

figure; FigureSettings; errorbar( TIME, mean( M_byWell ),       std( M_byWell ),    'k', 'linewidth', 2 ); hold on;
                        
                        errorbar( TIME, mean( MHAT_byWell ),    std( MHAT_byWell ), ':r', 'linewidth', 2 ); 

legend('test sample', 'prediction (extra constraints)'); title( mytitle ); ylabel('cell count'); xlabel('time (h)'); 


