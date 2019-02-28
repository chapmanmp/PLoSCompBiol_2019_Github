%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Margaret P. Chapman
% Date: May 23, 2017

% PURPOSE: Visualize cross-validation error vs. (lambda, mu, death option), agent a
% INPUT:
    % c*_a s.t. coms(c*_a, :) holds best (lambda, mu, death option) combination, agent a
    % errors_a(c) = cross-validation error, combination c, agent a
    % coms(c, :) = [ lambda value, mu value, death option ], combination c
    % lambdas = lambda vector
    % mus = mu vector
    % DO = # death options
    % agent = name of agent
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SeeCV( cStar_a, errors_a, coms, lambdas, mus, DO, agent )

N_COM = length( errors_a ); % # combinations

Xs = cell( DO, 1 );         % lambdas per death option
Ys = cell( DO, 1 );         % mus per death option
Zs = cell( DO, 1 );         % errors per death option

[ YGrid, XGrid ] = meshgrid( lambdas, mus ); 

ZGrid = cell( DO, 1 );
n = length( lambdas );    % # rows, ZGrid
m = length( mus );        % # cols, ZGrid

for o = 1 : DO
    
    rows_o = ( o : DO : N_COM )';
            
    Xs{o} = coms( rows_o, 1 );        % x coordinate : lambda 
    
    Ys{o} = coms( rows_o, 2 );        % y coordinate : mu
    
    Zs{o} = errors_a( rows_o );       % z coordinate : error
    
    for i = 1 : n                     % for each row of ZGrid{o}
        
        e_i = (i - 1)*m + 1 : i*m;      
                
        ZGrid{o}(i, :) = ( Zs{o}( e_i ) )';
        
    end
    
end

figure

FigureSettings
    
for o = 1 : DO
        
    subplot( 1, 3, o );
    
    % plot surface defined by the 3D pts
    surf( XGrid, YGrid, ZGrid{o}, 'FaceColor', 'interp' ); hold on;
    
    % plot 3D pts
    %plot3( Xs{o}, Ys{o}, Zs{o}, 'ok' ); hold on;
    
    % project 3D point onto lambda-mu plane for easy visualization
    %for j = 1 : length(rows_o), plot3( [ Xs{o}(j); Xs{o}(j) ], [ Ys{o}(j); Ys{o}(j)], [ Zs{o}(j); 0 ], 'k:', 'linewidth', 1 ); hold on; end 
        
    % if o is best, star best (lambda, mu, error) point
    % if o == coms( cStar_a, end ), plot3( coms(cStar_a, 1), coms(cStar_a, 2), errors_a(cStar_a), '*r' ); end
        
    set(gca,'xscale','log','yscale','log'); % credit: Damian T. Packer, 18 Nov 1999, 'Loglog plot in 3d?', MATLAB Newsgroup.
                                                        % https://www.mathworks.com/matlabcentral/newsreader/view_thread/13415
                                                        % accessed on 6/7/2017
                
    xlabel( '\lambda' ); ylabel( '\mu' ); zlabel( 'cv error' ); title( [agent, ', death option ', num2str(o)] );
        
    grid on;
        
end

        



    