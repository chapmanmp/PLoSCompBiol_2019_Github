%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: July 19, 2017

%PURPOSE: Sorts combinations of (lambda, mu, death option) into an easy-access matrix
%ASSUMES: Death option = 2 (even allocation), mu = lambda.
%INPUT: lambdas(i) = ith lambda value
%OUTPUT: coms(c, :) = [ lambda value, mu value, death option index ], combination c
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function coms = GetCombinations( lambdas )

DEATH_OPTION = 2; % even death allocation

LA = length( lambdas );   

coms = zeros( LA, 3 );                                           

for j = 1 : LA, coms(j, :) = [ lambdas(j) lambdas(j) DEATH_OPTION ]; end
 