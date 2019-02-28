%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: June 2, 2017

%PURPOSE: Get cell count vector for one sample given live & dying phenotype tallies, fraction dying, g+, & g-
%INPUT:
    % n = # states (i.e., cell types)
    % k14hi = # K14+ live & dying
    % k14lo = # K14- live & dying
    % k14los = column vector
    % if 4 phenotypes,                             if 2 phenotypes,
        % k14los = [ # VIM+/K14- live & dying;          k14los = # K14- live & dying;
        %            # K19+/VIM-/K14- live & dying; 
        %            # all low live & dying ]
    % fr_dy = fraction dying
    % ghi = gamma_hi
    % glo = gamma_lo
%OUTPUT: cts = column vector
    % cts(1) = # K14+ live
    % if 4 phenotypes,                      if 2 phenotypes,
        % cts(2) = # VIM+/K14- live             cts(2) = # K14- live
        % cts(3) = # K19+/VIM-/K14- live        cts(3) = # dying
        % cts(4) = # all low live
        % cts(5) = # dying
%NOTE: For each available sample i, 
    % [ # K14+ dying ]i := [ # K14+ live & dying ]i * [ fraction dying ]i * gamma_hi
    % [ # K14- dying ]i := [ # K14- live & dying ]i * [ fraction dying ]i * gamma_lo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cts = GetCellCtsVEC( n, k14hi, k14lo, k14los, fr_dy, ghi, glo )

cts = zeros( n, 1 );
                
cts( 1 )        = k14hi  * (1 - fr_dy * ghi);   % # K14+ live

cts( 2: end-1 ) = k14los * (1 - fr_dy * glo);   % # K14-(s) live

cts( end ) = ( k14hi + k14lo ) * fr_dy;         % # dying
                
                
                
                
                
                
                
                
                