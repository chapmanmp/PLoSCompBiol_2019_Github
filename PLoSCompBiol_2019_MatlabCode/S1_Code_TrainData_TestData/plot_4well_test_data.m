% plot 4 well test data

SHEET_NAME = 'Summary';                         % missing data marked with 'na' for 'not available'
COL_ROW_1 = 'E5';                               % 1st col-row
N_AGENT = 4;                                    % # agents
N_T = 6;                                        % # time points (0 h, 12 h, ..., 60 h)
TIME = 0:12:60;
N_P = 4;                                        % # phenotypic states

% Phenotype & death timeseries 4-well raw data for each agent
N_W = 4; [ P4W, d4W ] = SortBySeries( SortRawData( 'Timeseries_Raw_4wells.xlsx', SHEET_NAME, COL_ROW_1, 'K124', N_AGENT, N_T, N_W ) );

% P{a}{k} : phenotype counts (live & dead), agent a, time k
    % (row i, col w) : # phenotype i, well w

all_agents_prop = cell( N_AGENT, N_T );

for a = 1 : N_AGENT % DMSO, Tram., BEZ, Comb.
    
    for k = 1 : N_T, prop = zeros( N_P, N_W );
    
        for w = 1 : N_W, prop( :, w ) = P4W{a}{k}( :, w ) / sum( P4W{a}{k}( :, w ) ); end
    
        all_agents_prop{a}{k} = prop; % dmso_prop{a}{k}(i, w) = proportion phenotype i at time k, well w, agent a
        
    end  
    
end
                                            % green     red        blue     gray
fold_change_mean = cell( N_AGENT, N_P ); COLOR = {[0 0.5 0], [1 0 0], [0 0 1], [0.5, 0.5, 0.5]}; TITLE = { 'Tram. vs. DMSO', 'BEZ235 vs. DMSO', 'Comb. vs. DMSO' };
fold_change_std = cell( N_AGENT, N_P );
figure; FigureSettings;

for a = 2 : N_AGENT % Tram., BEZ, Comb.
    
    for i = 1 : N_P

        for k = 1 : N_T    
                          % agent a, time k, phenotype i all wells /  avg(dmso, time k, phenotype i all wells)
            fold_change_aik = all_agents_prop{a}{k}( i, : ) / mean( all_agents_prop{1}{k}( i, : ) );
            
            fold_change_mean{a}{i}(k) = mean( fold_change_aik ); 
            
            fold_change_std{a}{i}(k) = std( fold_change_aik );
                                    
        end
        
        subplot( 1, 3, a-1 );
        
        errorbar( TIME, fold_change_mean{a}{i}, fold_change_std{a}{i}, 'Color', COLOR{i}, 'linewidth', 2 ); hold on;
                
    end
    
    plot( TIME, ones( size(TIME) ), ':k', 'linewidth', 2 );
    
    title( TITLE{a-1} ); xlabel('time (h)'); if a == 2, ylabel('Fold change'); end
    
    if a == 4, legend('K14^{hi}', 'VIM^{hi}K14^{low}', 'K19^{hi}VIM^{low}K14^{low}', 'K19^{low}VIM^{low}K14^{low}'); end
    
end

