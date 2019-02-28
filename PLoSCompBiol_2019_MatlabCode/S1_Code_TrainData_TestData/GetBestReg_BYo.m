%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Margaret P. Chapman
% Date: June 14, 2017

% PURPOSE: Extract best (lambda, mu) for each death option, based on cross-validation
% INPUT: 
    % cvres_BYo = cv results categorized by death option
        % cvres_BYo{o}(i, :) = [ lambda, mu, error(lambda, mu, o) ], option o's ith combination
        % cvres_BYo{o} is empty if option o is not evaluated
    % DO = # death options
% OUTPUT: regSTAR_BYo{o'} = [ lambda*, mu* ] s.t. (lambda*, mu*) = argmin{ error(lambda, mu, o) : o = o' }
%         regSTAR_BYo{o'} is empty if option o' is not evaluated
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function regSTAR_BYo = GetBestReg_BYo( cvres_BYo, DO )

regSTAR_BYo = cell( DO, 1 );

for o = 1 : DO
    
    if ~isempty( cvres_BYo{o} )
    
        [ ~, iSTAR ] = min( cvres_BYo{o}(:, end) );     % last col : err
    
        regSTAR_BYo{o} = cvres_BYo{o}( iSTAR, 1 : 2 );  % (col 1, col 2) : (lambda, mu)
        
    end
    
end

