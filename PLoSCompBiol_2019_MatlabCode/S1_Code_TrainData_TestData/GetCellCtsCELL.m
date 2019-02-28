%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 15, 2017

%PURPOSE: Get cell counts for all samples given specific death allocation option & agent
%INPUT:
    % P_a{k}(i, w) = # phenotype i (live & dying), well w, time k, agent a
        % phenotype 1 = K14+
    % d_a{k}(w) = fraction dying, well w, time k, agent a
    % o = death option
    % W(j) = jth well
%OUTPUT:
    % C_a{k}{W(j)} = cell cts col vec, agent a, time k, well W(j)
        % is NaN vector if data not available
        % entry 1 = # K14+ live cells
        % if 4 phenotypes,                   if 2 phenotypes,
            % entry 2 = # VIM+/K14- live         entry 2 = # K14- live
            % entry 3 = # K19+/VIM-/K14- live    entry 3 = # dying
            % entry 4 = # all low live
            % entry 5 = # dying
    % C_a{k}{w} is empty if w is not in W
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function C_a = GetCellCtsCELL( P_a, d_a, o, W )

N_TIME = length( P_a ); [ N_P, N_WELL ] = size( P_a{1} ); n = N_P + 1; % # states (i.e., cell types) 

C_a = cell( N_TIME, N_WELL );

for k = 1 : N_TIME
    
    j = 1;
    
    for w = 1 : N_WELL
        
        if j <= length( W ) && w == W(j)
            
            fr_dy = d_a{k}( w );                     % fraction dying
            
            k14hi = P_a{k}( 1, w );                  % # K14+ live & dying
            
            if ( isnan( fr_dy ) || isnan( k14hi ) )  % if sample is not available,
                
                cts = NaN( n, 1 );                   % set cts to NaNs
                
            else                                                                              
                
                k14lo = sum( P_a{k}( 2:end, w ) );   % # K14- live & dying
                                
                [ ghi, glo ] = ReadDeathOption( k14hi, k14lo, fr_dy, o ); % gamma+, gamma-; function of death option & sample
                
                cts = GetCellCtsVEC( n, k14hi, k14lo, P_a{k}( 2:end, w ), fr_dy, ghi, glo ); % cell counts, function of death option & sample
                
            end                                                                                 
        
            C_a{k}{w} = cts;
            
            j = j + 1;
            
        else
            
             C_a{k}{w} = [];
             
        end 
        
    end 
    
end
            
            
        
        
        



