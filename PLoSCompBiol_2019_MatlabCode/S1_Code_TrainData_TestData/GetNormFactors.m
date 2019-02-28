%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 18, 2017

%PURPOSE: Compute normalization factors for each term in cost function
%INPUT:
    % n = # rows (all terms)
    % m = # cols in cell proportion matrix, M
    % N_W = # wells in M
    % m_av = # available samples in M
%OUTPUT: 
    %f_p = 1 / sqrt( #entries( X_l - AX_e ) )
    %f_d = 1 / sqrt( #entries( A ) )
    %f_m = 1 / sqrt( #entries( M(:, Jav) - X(:, Jav) ) )
%NOTE: M = [ x[1,W(1)] ... x[1,W(end)], ..., x[7,W(1)] ... x[7,W(end)] ] proportions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ f_p, f_d, f_m ] = GetNormFactors( n, m, N_W, m_av )

f_p = 1 / sqrt( n * ( m - N_W ) );  % norm. factor, process term

f_d = 1 / n;                        % norm. factor, dynamics term

f_m = 1 / sqrt( n * m_av );         % norm. factor, measurement term