%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Shades the space between an upper curve and a lower curve, and plots a middle curve
% INPUT:
    % curveUPai = upper curve, row vector
    % curveMIai = middle curve, row vector
    % curveLOai = lower curve, row vector
    % time_horizon = x-axis, row vector
    % myColor = color of shading
% OUTPUT: plots in existing figure
% NOTE: Code to shade the space between upper and lower curves is from MathWorks help/stack exchange
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plotBandENSEMBLE( curveUPai, curveMIai, curveLOai, time_horizon, myColor )

x_axis_for_fill = [ time_horizon, fliplr(time_horizon) ]; % fill in-between upper and lower curves
inBetween = [ curveLOai, fliplr(curveUPai) ];
fill( x_axis_for_fill, inBetween, myColor ); hold on;

plot( time_horizon, curveMIai, ':k', 'linewidth', 1 );  hold on; % plot middle curve after fill so it shows
                                                          
                                                                 % cover upper and lower lines left by fill
plot( time_horizon, curveUPai, 'Color', myColor, 'linewidth', 1 ); hold on; 

plot( time_horizon, curveLOai, 'Color', myColor, 'linewidth', 1 ); hold on;

% % Code from MathWorks help
% x = 1 : 300;
% curve1 = log(x);   % LOWER
% curve2 = 2*log(x); % UPPER
% plot(x, curve1, 'r', 'LineWidth', 2);
% hold on;
% plot(x, curve2, 'b', 'LineWidth', 2);
% x2 = [x, fliplr(x)];
% inBetween = [curve1, fliplr(curve2)];
% fill(x2, inBetween, 'g');
