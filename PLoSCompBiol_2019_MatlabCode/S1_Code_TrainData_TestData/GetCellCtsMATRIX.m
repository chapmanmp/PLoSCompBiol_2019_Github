%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 16, 2017

%PURPOSE: Compute cell count matrix for cvx optimization, agent a
%INPUT: C_a = 7x15 cell, W = vector of well indices
    % C_a{k}{W(j)} = cell count vector, agent a, time k, well W(j)
        % is NaN vector if data not available
        % entry 1 = # K14+ live cells
        % if 4 phenotypes,                          if 2 phenotypes,
            % entry 2 = # VIM+/K14- live cells          entry 2 = # K14- live cells
            % entry 3 = # K19+/VIM-/K14- live cells     entry 3 = # dying/dead cells
            % entry 4 = # all low live cells
            % entry 5 = # dying/dead cells
    % C_a{k}{w} is empty if w is not in W
%OUTPUT: matrix #phenotypes+1 x 7*|W|
    % M_a = [ x[1,W(1)] ... X[1,W(end)], ..., x[7,W(1)] ... x[7,W(end)] ]
    % if 4 phenotypes,
        % x[k,w] = [# K14+ live; # VIM+/K14- live; # K19+/VIM-/K14- live; # all low live; # dying/dead], time k, well w
    % if 2 phenotypes,
        % x[k,w] = [# K14+ live; # K14- live; # dying/dead], time k, well w
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function M_a = GetCellCtsMATRIX( C_a, W )

n = length( C_a{1}{W(1)} ); %number of cell types

N_TIME = size( C_a, 1 );

N_W = length( W );

m = N_TIME * N_W; %number of samples

M_a = zeros( n, m );

for k = 1 : N_TIME
    
    for j = 1 : N_W
        
        M_a( :, (k-1)*N_W + j ) = C_a{k}{W(j)}; %cell count vector
        
    end
    
end

