%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: June 2, 2017

%PURPOSE: Returns value of gamma_hi & value of gamma_lo given sample & death option
%INPUT: 
    % k14hi = # K14+ live & dying cells, one sample
    % k14lo = # K14- live & dying cells, one sample
    % fr_dy = fraction dying, one sample
    % o = death option = 1, 2, or 3
%OUTPUT: gamma_hi & gamma_lo
%NOTE:
    % option 1 = minimial death allocated to K14+, maximal death allocated to K14-
    % option 2 = death allocated equally between K14+ & K14-
    % option 3 = maximal death allocated to K14+, minimal death allocated to K14-
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ ghi, glo ] = ReadDeathOption( k14hi, k14lo, fr_dy, o )

if o == 1
    
    z = k14hi/k14lo + 1;
    
    glo = min( z, 1/fr_dy );
    
    ghi = (glo == z)*0 + (glo ~= z)*(k14lo/k14hi*(1 - glo) + 1);
    % used b/c when glo = k14hi/k14lo + 1, ghi was very small but not exactly 0 in test
                                                                   
elseif o == 2
    
    glo = 1;
    
    ghi = glo;
    
elseif o == 3
    
    z = k14lo/k14hi + 1;
    
    ghi = min( z, 1/fr_dy );
    
    glo = (ghi == z)*0 + (ghi ~= z)*(k14hi/k14lo*(1 - ghi) + 1);
    % used to ensure that glo is exactly 0 when ghi = k14lo/k14hi + 1
    
end
