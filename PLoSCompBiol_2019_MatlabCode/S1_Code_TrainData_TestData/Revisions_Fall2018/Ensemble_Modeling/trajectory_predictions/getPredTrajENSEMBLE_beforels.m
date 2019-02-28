%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Returns predicted state trajectories for all initial conditions and bootstrap models, agent a
% INPUT:
    % A_BOOTa{b} = bootstrap dynamics model, iteration b, agent a
    % N_TIME = # time points in predicted trajectory
    % Maic(:,ic) = state time 0, well ic (icth initial condition)
    % N_W = # initial conditions
    % B = # boostrap parameter sets
    % N_STATE = # states
% OUTPUT:
    % predStatea{i}{k}((b-1)N_W + ic) = # cells, state i, time k under initial condition ic, boostrap dynamics model A_BOOTa{b}
    % k = 1  2   3  4   5   6   7 
    %    0h 12h 24h 36h 48h 60h 72h 
    % ic 1, ic 2, ic 3, ic 4 ... ic 1, ic 2, ic 3, ic 4
    % |------A_BOOTa{1}-----|... |------A_BOOTa{B}-----|
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function predStatea = getPredTrajENSEMBLE( A_BOOTa, N_TIME, Maic, N_W, B, N_STATE )

predStatea = cell(N_STATE, N_TIME);

for b = 1 : B                       % for each bootstap model
    
    %xk = getBestIC( Ma, N_W, N_TIME-1, A_BOOTa{b} ); 
    
    for ic = 1 : N_W                % for each initial condition
        
        storeInd = (b-1)*N_W + ic;  % compute storage index
        
        xk = Maic(:,ic);            % get initial condition
                                    % store initial condition
        for i = 1 : N_STATE, predStatea{i}{1}(storeInd) = xk(i); end
        
        for k = 1 : N_TIME-1
            
            xkPLUS1 = A_BOOTa{b} * xk; % compute next state
                                       % store next state
            for i = 1 : N_STATE, predStatea{i}{k+1}(storeInd) = xkPLUS1(i); end
            
            xk = xkPLUS1;              % get ready for next iteration
            
        end
        
    end
    
end
            
        
