%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 12, 2017

%PURPOSE: Identify indices of wells with phenotype & death timeseries raw data fully available
%INPUT:
    % P_a{k}(i, w) = # phenotype i (live & dying), well w, time k, specific agent
        % is NaN for i=1 <-> all phenotype counts not available
    % d_a{k}(w) = fraction dying, well w, time k, specific agent
        % is NaN <-> not available
 %OUTPUT: well indices, specific agent, raw data available for all time
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Wfull_a = GetFullWellIndices( P_a, d_a ) 

N_WELL = length( d_a{1} );

N_TIME = length( d_a );

Wfull_a = 1 : N_WELL;

for w = N_WELL : -1 : 1
    
    for k = 1 : N_TIME
        
        if isnan( P_a{k}(1, w) ) || isnan( d_a{k}(w) )
            
            Wfull_a(w) = [];
            
            break;
            
        end
        
    end
    
end



