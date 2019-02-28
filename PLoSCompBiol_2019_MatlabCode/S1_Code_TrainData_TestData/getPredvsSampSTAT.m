%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Quantifies concordance/disconcordance between two time-series data sets
% INPUT:
    % predStatea{i}{k} = row vector of predictions for # cells, state i, time k
    %                                              k = 1  2 ... N_Tpred
    % Ma = data sample matrix, all states (may have nan's)
    %   well 1, well 2, ... , well N_W ... well 1, well 2, ..., well N_W
    %   |---------k=1-----------------|...|---------k=N_T--------------|
    % N_W = # wells in Ma
    % N_T = # time points in Ma
    % N_STATE = # states
    % K0 = initial time point for p-value calculation
% OUTPUT:
    % pvalsa{i} = p-value, predictions versus data samples (state i, agent a) over time horizon via 2-way analysis of variance
    %             time horizon is K0 to N_T (we have N_T<=N_Tpred) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pvalsa = getPredvsSampSTAT( predStatea, Ma, N_W, N_T, N_STATE, K0 )

pvalsa = cell(N_STATE,1);

y = cell(N_STATE,1); g1 = cell(N_STATE,1); g2 = cell(N_STATE,1);
% for state i,
% y{i}  = column vector of values
% g1{i} = row vector of associated time points
% g2{i} = cell of labels (S for data sample or P for prediction)

for i = 1 : N_STATE
    
    y{i} = []; g1{i} = []; g2{i} = {};   % initialize empty cell 
    
    for k = K0 : N_T
        
        cols_k = (k-1)*N_W + 1 : k*N_W;  % cols for samples(time k)
        
        sams_ik = Ma( i, cols_k );       % samples(state i, time k), wells 1 to N_W
                                         
        % store data samples (may have nan's)
        for w = 1 : N_W, if ~isnan(sams_ik(w)), y{i} = [y{i}; sams_ik(w)]; g1{i} = [ g1{i} k ]; g2{i} = [ g2{i}; {'S'} ]; end; end 
        
        % store predictions  (no nan's)
        for b = 1 : length(predStatea{i}{k}), y{i} = [y{i}; predStatea{i}{k}(b)]; g1{i} = [ g1{i} k ]; g2{i} = [ g2{i}; {'P'} ]; end
        
    end
    
    pvalsa{i} = anovan(y{i}, {g1{i}, g2{i}}, 'display', 'off'); %N-way analysis of variance (ANOVA)

    pvalsa{i} = pvalsa{i}(2); % extract p value corresponding to the factor g2{i} which has the levels S and P
                              % p value < 0.05 means that the samples and the predictions *are* significantly different    
end



 