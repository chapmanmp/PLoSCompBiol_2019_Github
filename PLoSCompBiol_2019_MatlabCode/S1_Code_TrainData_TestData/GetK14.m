%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 12, 2017

%PURPOSE: Converts phenotypes to K14+, K14-
%INPUT:
    % P_a{k} = phenotype timeseries raw data, agent a, time k
        %P_a{k}(i, w) = # phenotype i (live & dying), well w
            % phenotype 1 = K14+
            % phenotype 2 = VIM+/K14-
            % phenotype 3 = K19+/K14-/VIM-
            % phenotype 4 = all low
%OUTPUT:
    % P_a{k} = phenotype timeseries raw data, agent a, time k
    % P_a{k}(i, w) = # phenotype i (live & dying), well w
            % phenotype 1 = K14+
            % phenotype 2 = K14-
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function P_a = GetK14( P_a )

N_TIME = length( P_a );

for k = 1 : N_TIME
    
    P_k = P_a{k};
    
    K14hi_k = P_k( 1, : );
    
    K14lo_k = sum( P_k( 2:end, : ) );
    
    P_a{k} = [ K14hi_k; K14lo_k ];
    
end
