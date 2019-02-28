%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 17, 2017

%PURPOSE: Returns column indices of available samples, assuming data form:
    % [ x[1, W(1)], ..., x[1, W(end)], ..., x[7, W(1)], ..., x[7, W(end)] ], where
    % last element of x is a measure of dying cells, first elements of x are measures of phenotype live cells
%INPUT: 
    %P_a{k}(i, W(j)) = # phenotype i (live & dying), well W(j), time k, agent a
        % is NaN for i=1 <-> all phenotype counts not available
    % d_a{k}(W(j)) = fraction dying, well W(j), time k, agent a
        %is NaN <-> not available
    % W(j) = jth well of interest
%OUTPUT: Jav = row vector of available sample indices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Jav = GetAvailableSamples( P_a, d_a, W )

N_TIME = length( P_a );

N_W = length( W ); 

m = N_TIME * N_W; %# samples

J = zeros( m, 1 );

for k = 1 : N_TIME
    
    for j = 1 : N_W
        
        if ~( isnan( P_a{k}(1, W(j)) ) || isnan( d_a{k}(W(j)) ) )
            
            sample_index = (k - 1)*N_W + j;
            
            J( sample_index ) = sample_index;
            
        end
        
    end
    
end

Jav = nonzeros( J ); %full column vector of J's nonzero elements

Jav = transpose( Jav ); %return row vector
