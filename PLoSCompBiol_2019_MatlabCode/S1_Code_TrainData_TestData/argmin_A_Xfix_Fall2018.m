%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 19, 2017

%PURPOSE: Find dynamics (A) that minimizes the cost function for fixed filled-in cell counts (X)
%INPUT:
    %X = filled-in cell counts
    %M = cell count matrix from empirical observations
    %Jav = indices of M's available samples
    %N_W = # wells in M
    %lambda, mu = regularization parameters
    %f_p, f_d, f_m = normalization factors
    %n = # cell types = # phenotypes live + dying = # rows in M
    %idx = logical array to locate non-diagonal entries of nxn matrix
%OUTPUT: optimized dynamics
%NOTE: M & X share the form: [ x[1,W(1)] ... x[1,W(end)], ..., x[7,W(1)]... x[7,W(end)] ] counts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function AStar = argmin_A_Xfix_Fall2018( X, M, Jav, N_W, lambda, mu, f_p, f_d, f_m, n, idx )
cvx_solver sdpt3;
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
                        
    cvx_end
    
    if strcmpi(cvx_status, 'Solved')
        AStar = A; break;
    elseif j == 1 
        cvx_solver sedumi;
    else
        error('argmin_A_Xfix.m: CVX not solved.');
    end
    
end