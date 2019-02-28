%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Returns predicted state trajectories under all bootstrap models, agent a
    % For each bootstrap model A, provides trajectory prediction (x0, A*x0, A*A*x0, ...), 
    % where x0 is optimized to fit the data samples Ma well
% INPUT:
    % A_BOOTa{b} = bootstrap dynamics model, iteration b, agent a
    % N_TIME = # time points in predicted trajectory
    % Ma = data sample matrix, all states (may have nan's)
    %       well 1, well 2, ... , well N_W ... well 1, well 2, ..., well N_W
    %       |---------k=1-----------------|...|---------k=N_T---------------|
    % N_W = # wells in data sample matrix 
    % N_T = length of time horizon for data sample matrix Ma 
    % B = # boostrap parameter sets
    % N_STATE = # states
% OUTPUT:
    % predStatea{i}{k}(b) = # cells, state i, time k under boostrap dynamics model A_BOOTa{b}
    % k = 1  2   3  4   5   6   7   (N_TIME = 7) 
    %    0h 12h 24h 36h 48h 60h 72h 
% Author: Margaret Chapman
% Date: November 10, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function predStatea = getPredTrajENSEMBLE( A_BOOTa, N_TIME, Ma, N_W, N_T, B, N_STATE )

predStatea = cell(N_STATE, N_TIME); 

for b = 1 : B                       % for each bootstap model
    
    xk = getBestIC_Fall2018( Ma, N_W, N_T, A_BOOTa{b}, N_STATE ); % get best initial condition for boostrap model b
    
    for i = 1 : N_STATE, predStatea{i}{1}(b) = xk(i); end         % store initial condition
        
    for k = 1 : N_TIME-1
            
        xkPLUS1 = A_BOOTa{b} * xk; % compute next state
                                       
        for i = 1 : N_STATE, predStatea{i}{k+1}(b) = xkPLUS1(i); end; % store next state
            
        xk = xkPLUS1;              % get ready for next iteration
            
    end
    
end
            
        
