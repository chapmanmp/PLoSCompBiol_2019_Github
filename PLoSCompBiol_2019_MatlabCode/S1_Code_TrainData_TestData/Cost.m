%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 18, 2017

%PURPOSE: Define cost function for alternating minimization
%INPUT:
    %A = dynamics to be optimized
    %X = cell counts to be optimized
    %M = cell counts from empirical observations (fixed, includes NaNs)
    %Jav = indices of M's available samples
    %N_W = # wells in M
    %lambda = weight on process error
    %mu = weight on measurement error
    %f_p, f_d, f_m = normalization factors for each term
%OUTPUT: cost function expression
%NOTE: 
    %X & M share the form: [ x[1,W(1)] ... x[1,W(end)], ..., x[7,W(1)]... x[7,W(end)] ]
    %x[k, w] = cell counts(time k, well w)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function J = Cost( A, X, M, Jav, N_W, lambda, mu, f_p, f_d, f_m )

X_e = X( :, 1 : end - N_W );  % time pts  0h, 12h, ..., 60h, 'e' for earlier

X_l = X( :, N_W + 1 : end );  % time pts 12h, 24h, ..., 72h, 'l' for later

J = f_d * norm( A, 'fro' ) + lambda * f_p * norm( X_l - A * X_e, 'fro' ) + mu * f_m * norm( M( :, Jav ) - X( :, Jav ), 'fro' );




