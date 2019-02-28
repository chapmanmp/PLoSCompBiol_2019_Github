%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Margaret P. Chapman
% Date: June 18, 2017

% PURPOSE: Split full data matrix into train & test
% INPUT: 
    % M = [ x[1,1] ... x[1,15] ... x[7,1] ... x[7,15] ]
    % Wtrain = train wells
    % Wtest = test wells
% OUTPUT:
    % Train = train data 
    % Test_e = test data, earlier time pts
    % Test_l = test data, later time pts
    % Test = test data
% NOTE: 
    % Form of Train, Test = [ x[1,W(1)] ... x[1,(end)] ... x[7,W(1)] ... x[7,W(end)]
        % For Train, W = Wtrain; for Test, W = Wtest.
    % Test_e = [ x[1,W(1)] ... x[1,(end)] ... x[6,W(1)] ... x[6,W(end)], W = Wtest
    % Test_l = [ x[2,W(1)] ... x[2,(end)] ... x[7,W(1)] ... x[7,W(end)], W = Wtest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ Train, Test_e, Test_l, Test ] = SplitIntoTrainTest( M, Wtrain, Wtest )

N_TRAN = length( Wtrain ); N_TEST = length( Wtest ); N_WELL = N_TRAN + N_TEST; 

[ n, m ] = size( M ); N_TIME = m / N_WELL;

for k = 1 : N_TIME
        
    Train( :, (k-1)*N_TRAN + 1 : k*N_TRAN ) = M( :, (k-1)*N_WELL + Wtrain );
    
    Test( :, (k-1)*N_TEST + 1 : k*N_TEST ) = M( :, (k-1)*N_WELL + Wtest );
    
end

Test_e = Test( :, 1 : end - N_TEST );

Test_l = Test( :, N_TEST + 1 : end );
