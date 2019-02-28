%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Shows how the dynamics parameters evolve at each iteration of the Alternating minimums algorithm
% INPUT:
    % myAs{i} = dynamics matrix at iteration i of the AM algorithm for a given agent (e.g., DMSO)
    % PARAM{i} = name of ith dynamics parameter
    % AGENT = name of agent, a string
% OUTPUT: plots of dynamics parameter value versus iteration of algorithm
% Author: Margaret Chapman
% Date: November 1, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function seeEvol_of_A_inAM( myAs, PARAM, AGENT )

n = size( myAs{1}, 1 );   % dimension of dynamics matrix

Niter = length(myAs);     % number of iterations of AM algorithm

Nparam = length( PARAM ); % number of dynamics parameters

dyn_params = zeros( Niter, Nparam ); 
%dyn_params(i,j) = value of parameter j at iteration i
%parameter j 1   2    3    4    5    6   7    8    9    10  11    12  13  14    15   16   17   18  19  20 
%           p1, p12, p13, p14, p1D, p21, p2, p23, p24, p2D, p31, p32, p3, p34, p3D, p41, p42, p43, p4, p4D.
%based on StackDynamicsParametersHorizonally.m output

for i = 1 : Niter
    
    A_i = myAs{i}; % dynamics matrix at iteration i
    
    dyn_params(i,:) = StackDynamicsParametersHorizonally(A_i); % extract dynamics parameters at iteration i
    
end

figure; FigureSettings;

for j = 1 : Nparam
    
    subplot( n-1, n, j );
    
    plot( 1:Niter, dyn_params(:,j), '-b', 'linewidth', 2 ); xlim([1 Niter]); 
    title([PARAM{j},', ', AGENT]); xlabel('AM iteration');
    
end
    
    