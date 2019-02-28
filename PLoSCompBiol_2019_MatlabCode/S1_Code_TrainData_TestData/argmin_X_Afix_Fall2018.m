%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 19, 2017

%PURPOSE: Find cell count matrix (X) that minimizes the cost function for fixed dynamics (A)
%INPUT:
    %A = dynamics
    %M = cell count matrix from empirical observations
        %M = [ x[1,W(1)] ... x[1,W(end)], ..., x[7,W(1)] ... x[7,W(end)] ] counts
    %Jav = indices of M's available samples
    %N_W = # wells in M
    %lambda, mu = regularization parameters
    %f_p, f_d, f_m = normalization factors
    %n = # cell types = # phenotypes live + dying = # rows in M
    %m = # samples = # cols in M
%OUTPUT: optimized filled-in cell cts, same form as M above
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function XStar = argmin_X_Afix_Fall2018( A, M, Jav, N_W, lambda, mu, f_p, f_d, f_m, n, m )
cvx_solver sdpt3;
for j = 1 : 2

    cvx_begin quiet

        variable X(n, m) nonnegative; % each entry >= 0
    
        minimize( Cost( A, X, M, Jav, N_W, lambda, mu, f_p, f_d, f_m ) )
    
    cvx_end
    
    if strcmpi(cvx_status, 'Solved')
        XStar = X; break;
    elseif j == 1 
        cvx_solver sedumi;
    else
        error('argmin_X_Afix.m: CVX not solved.');
    end                                 
    
end


