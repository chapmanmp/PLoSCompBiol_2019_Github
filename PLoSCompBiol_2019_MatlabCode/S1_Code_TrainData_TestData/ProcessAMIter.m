%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Margaret P. Chapman
% Date: July 5, 2017

% PURPOSE: Display maximum # of AM iterations & how many times max is reached for each agent
% INTPUT:
    % iters{a}(c) = # AM iterations, agent a, (lambda, mu, o) combination c
    %   OR
    % iters{a}(b) = # AM iterations, agent a, bootstrap b, best (lambda, mu, o) combination
    % N_AGENT = # agents
    % AGENT{a} = name, agent a
    % TOT = # cv combinations OR # bootstrap steps, agent a
% OUTPUT: 
    % agent a: max # AM iterations = ??, hit ??x out of TOT total.
    % max_AM_i{a} = max # AM iterations, agent a
    % N_hit{a} = # of times max_iters{a} is hit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ max_AM_i, N_hit ] = ProcessAMIter( iters, N_AGENT, AGENT, TOT )

max_AM_i = cell( N_AGENT, 1 ); N_hit = cell( N_AGENT, 1 ) ;

for a = 1 : N_AGENT 
        
    max_AM_i{a} = max( iters{a} );
        
    N_hit{a} = sum( iters{a} == max_AM_i{a} );
        
    disp( [ AGENT{a}, ': max # AM iter = ', num2str( max_AM_i{a} ), ', hit ', ...
            num2str( N_hit{a} ), 'x out of ', num2str(TOT), ' total.' ]);
        
end

