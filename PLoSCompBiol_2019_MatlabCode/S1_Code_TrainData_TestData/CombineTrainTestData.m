%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Margaret P. Chapman
% Date: June 14, 2017

% PURPOSE: Form pre-optimization data for all (train + test) wells, death option o
% INPUT:
    % Tran = train data, death option o
    % Wtran = train wells
    % Test = test data, death option o
    % Wtest = test wells
    % N_WELL = # wells in total
% OUTPUT: M = pre-optimization data, all wells, death option o
% NOTE: 
    % M, Train share form: [ x[1,W(1)] ... X[1,W(end)], ..., x[7,W(1)] ... x[7,W(end)] ]
        % M : W = 1 : N_WELL
        % Train: W = Wtrain
    % Test_e form: [ x[1,W(1)] ... X[1,W(end)], ..., x[6,W(1)] ... x[6,W(end)] ], W = Wtest
    % Test_l form: [ x[2,W(1)] ... X[2,W(end)], ..., x[7,W(1)] ... x[7,W(end)] ], W = Wtest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function M = CombineTrainTestData( Tran, Wtran, Test, Wtest, N_WELL ) 

N_TEST = length( Wtest ); N_TRAN = length( Wtran );

[ n, m ] = size( Test ); N_TIME = m / N_TEST; % # time pts = # test samples / # test wells

M = zeros( n, N_WELL * N_TIME );

for k = 1 : N_TIME
    
    M( :, (k-1)*N_WELL + Wtran ) = Tran( :, (k-1)*N_TRAN + 1 : k*N_TRAN ); % train samples, time k
    
    M( :, (k-1)*N_WELL + Wtest ) = Test( :, (k-1)*N_TEST + 1 : k*N_TEST ); % test samples, time k
    
end













