%Plots 95% confidence intervals for all dynamics parameters and all conditions.

function PlotConfidenceIntervals( ciBounds, AGENT, PARAM )

N_AGENT = length( ciBounds );

N_DP = length( PARAM ); % # dynamics parameters

figure
FigureSettings;

%YMIN = -0.05; YMAX = max( max( [ ciBounds{1} ciBounds{2} ciBounds{3} ciBounds{4} ] ) ) + 0.05;

XMIN = 1; XMAX = 4;

for j = 1 : N_DP
    
    subplot( 4, 5, j );
    
    for a = 1 : N_AGENT
        
        xj = [ a; a ]; %parameter j for agent a
        
        yj = ciBounds{a}( :, j ); %[ upper; lower ] ci bound, parameter j
        
        plot( xj, yj, '*-k', 'linewidth', 2); hold on
        
    end
    
    grid on; 
    YMAX = max( max( [ ciBounds{1}( :, j ) ciBounds{2}( :, j ) ciBounds{3}( :, j ) ciBounds{4}( :, j ) ] ) ) + 0.05;
    YMIN = min( min( [ ciBounds{1}( :, j ) ciBounds{2}( :, j ) ciBounds{3}( :, j ) ciBounds{4}( :, j ) ] ) ) - 0.05;
    
    ylabel('95% ci'); title( PARAM{j} ); axis([ XMIN XMAX YMIN YMAX ]);
    
    xticks( XMIN:XMAX ); xticklabels( AGENT );
      
end

%VERIFICATION
%This function was tested during the week of 4/12/2016.


