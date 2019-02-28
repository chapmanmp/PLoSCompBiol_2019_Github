%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 23, 2017

%PURPOSE: Sorts combinations of (lambda, mu, death option) into an easy-access matrix, for CV STUDY (all death options)
%INPUT: 
    % lambdas(i) = ith lambda value
    % mus(i) = ith mu value
    % dOpts(i) = ith death option
%OUTPUT: coms(c, :) = [ lambda value, mu value, death option index ], combination c
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function coms = GetCombinations_CVSTUDY( lambdas, mus, dOpts )

LA = length( lambdas ); MU = length( mus ); DO = length( dOpts ); N_COM = LA * MU * DO;   
                                                                  % # combinations
coms = zeros( N_COM, 3 );                                           
    
c = 1;

for l = 1 : LA
    
    for m = 1 : MU
        
        for o = 1 : DO
                
            coms(c, :) = [ lambdas(l) mus(m) o ];
            
            c = c + 1;
                
        end
            
    end
        
end
 
   



