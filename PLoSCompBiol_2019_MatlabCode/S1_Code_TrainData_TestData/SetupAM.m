%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 22, 2017

%PURPOSE: Perform one-time calculations for alternating minimization
%INPUT:
    % P_a{k}(i, w) = # phenotype i (live & dying), well w, time k, agent a
    % d_a{k}( w ) = fraction dying, well w, time k, agent a
    % W(j) = jth well for model id
%OUTPUT: 
    % Jav = indices of available samples (form: [ x[1,W(1)] ... x[1,W(end)], ..., x[7,W(1)] ... x[7,W(end)] ])
    % f_p, f_d, f_m = normalization factors
    % n = # states = ( # phenotypes live + # dying )
    % m = # samples = |W| * N_TIME
    % idx = logical array to locate non-diagonal entries of nxn matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ Jav, n, m, f_p, f_d, f_m, idx ] = SetupAM( P_a, d_a, W )

Jav = GetAvailableSamples( P_a, d_a, W );

n = size( P_a{1}, 1 ) + 1;                                          % n = # phenotypes live + 1                                      

N_W = length( W );                                                  % # wells of interest

m = length( d_a ) * N_W;                                            % m = # samples = # time points * # wells

[ f_p, f_d, f_m ] = GetNormFactors( n, m, N_W, length( Jav ) );     % normalization factors in Cost

idx = ~eye(n); % Nathan Greco, 28 Jul 2011, 'How do I access and modify only the non diagonal entries in a matrix?'
               % https://www.mathworks.com/matlabcentral/answers/12619-how-do-i-access-and-modify-only-the-non-diagonal-entries-in-a-matrix
               % accessed on 6/12/2017

