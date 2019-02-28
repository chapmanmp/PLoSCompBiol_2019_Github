%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Margaret P. Chapman
% Date: Nov. 7, 2017

% PURPOSE: Find dynamics (A) that minimizes the cost function for fixed filled-in cell counts (X)

% Apply additional constraints on A to examine
    % Role of ?12-decrease and ?31-increase in Trametinib-induced K14hi enrichment, or
    % Role of ?12-decrease and ?32-increase in Comb.-induced VIMhiK14low de-enrichment

% See notes for argmin_A_Xfix.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function A = try_argmin_A_Xfix( X, M, Jav, N_W, lambda, mu, f_p, f_d, f_m, n, idx )

for j = 1 : 2

    cvx_begin quiet

        variable A(n, n) nonnegative;               % positive system
    
        minimize( Cost( A, X, M, Jav, N_W, lambda, mu, f_p, f_d, f_m ) )
    
        subject to
    
            A(:, n) == [ zeros( n-1, 1 ); 1 ];      % col n = [0; ...; 0; 1]
        
            sum( A(:, 2:n-1) ) == sum( A(:, 1) );   % equal cell div gains
            
            A( idx ) <= 1;                          % off-diagonals are proportions
                
            sum( A ) >= 1;                          % cell div gain >= 1, A(n,n) = 1
            
            A(n, 2:n-1) == A(n, 1);                 % equal death gains 
            
            % For "Role of rho12-decrease and rho31-increase in Trametinib-induced K14hi enrichment"
            A(2,1) >= 0.5854;                       % rho12 >= rho12_dmso = 0.5854
            A(1,3) <= 0.1904;                       % rho31 <= rho31_dmso = 0.1904
            
            % For "Role of rho12-decrease and rho32-decrease in Comb.-induced VIMhiK14low de-enrichment"
            % A(2,1) >= 0.5854;                       % rho12 >= rho12_dmso = 0.5854
            % A(2,3) >= 0.6261;                       % rho32 >= rho32_dmso = 0.6261
      
    cvx_end

    if ~strcmpi(cvx_status, 'Solved') %if cvx did not solve the program,
        
        if j == 1, cvx_solver sedumi;
            
        elseif j == 2, error('argmin_A_Xfix.m: CVX not solved.');
            
        end
        
    elseif j == 2, cvx_solver sdpt3; % if cvx solved program on 2nd try, change solver back
        
    end
    
end