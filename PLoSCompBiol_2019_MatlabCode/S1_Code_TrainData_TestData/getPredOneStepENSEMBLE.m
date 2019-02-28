%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Returns predicted state trajectories under all bootstrap models, agent a
    % For each bootstrap model A and each data sample trajectory ( x0, x1, x2, x3, ... )
        % provides ONE-STEP prediction (x0, A*x0, A*x1, A*x2, ... )
% INPUT:
    % A_BOOTa{b} = bth bootstrap dynamics model, agent a
    % N_TIME = # time points in predicted trajectory
    % Ma = data sample matrix, all states (may have nan's)
    %       well 1, well 2, ... , well N_W ... well 1, well 2, ..., well N_W
    %       |---------k=1-----------------|...|---------k=N_T---------------|
    % N_W = # wells in data sample matrix 
    % B = # boostrap parameter sets
    % N_STATE = # states
% OUTPUT:
    % predStatea{i}{k} = row vector of one-step predictions of # cells(state i, time k) via boostrapped models
        % nan's have been removed
    % k = 1  2   3  4   5   6   7   (N_TIME = 7) 
    %    0h 12h 24h 36h 48h 60h 72h 
% Author: Margaret Chapman
% Date: November 15, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function predStatea = getPredOneStepENSEMBLE( A_BOOTa, N_TIME, Ma, N_W, B, N_STATE )

predStatea = cell(N_STATE, N_TIME); MaHAT = cell(B,1);

for b = 1 : B  % for each bootstap model, get one-step predictions in each well assuming shared initial conditions
    
  % k = 2, ..., N_T+1       k = 1, ..., N_T
    MaHAT{b} = A_BOOTa{b} * Ma;
    
  % k = 1, 2, ..., N_T+1 (=N_TIME) 
    MaHAT{b} = [ Ma(:,1:N_W), MaHAT{b} ]; % shared initial conditions
    
end

for i = 1 : N_STATE
    
    for k = 1 : N_TIME
        
        predStatea{i}{k} = [];
        
        for b = 1 : B
        
            MaHAT_bik = MaHAT{b}( i, (k-1)*N_W + 1 : k*N_W ); % one-step predictions in wells 1 to N_W, bootstrap model b, state i, time k
        
            for w = 1 : N_W, if ~isnan(MaHAT_bik(w)), predStatea{i}{k} = [ predStatea{i}{k}, MaHAT_bik(w) ]; end; end;
            
        end
        
    end
    
end