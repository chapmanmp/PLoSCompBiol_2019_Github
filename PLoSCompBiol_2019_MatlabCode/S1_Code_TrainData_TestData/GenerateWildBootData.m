%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Margaret P. Chapman
% Date: June 16, 2017

% PURPOSE: Resample residuals via bootstrap technique proposed by Wu 1986
            % EVEN DEATH holds for all data
% INPUT: 
    % Train = train data
    % Wtrain = train wells
    % Test = test data, all time pts
    % Wtest = test wells
    % X = post-optimization data
% OUTPUT: 
    % TrainR = train data RESAMPLE
    % Test_eR = test data RESAMPLE, earlier time pts
    % Test_lR = test data RESAMPLE, later time pts
    % TestR = test data RESAMPLE, all time pts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ TrainR, Test_eR, Test_lR, TestR ] = GenerateWildBootData( Train, Wtrain, Test, Wtest, X )
                                                 
N_WELL = length( [ Wtrain, Wtest ] ); [ n, m ] = size( X ); N_TIME = m / N_WELL;  
        
M = CombineTrainTestData( Train, Wtrain, Test, Wtest, N_WELL ); 
    
MR = zeros( size(M) );
    
R = M - X; % residuals = [pre-opt] - [post-opt]

for k = 1 : N_TIME
                    
    for w = 1 : N_WELL
            
        j = (k-1)*N_WELL + w;
                                                                                  
        for i = 1 : n 
                
            v = randn(1); % instance of standard normal random variable
                
            s = (v >= 0) - (v < 0); % =1 w/ prob. 1/2; =-1 w/ prob. 1/2
                                                
            MR( i, j ) = X( i, j ) + R( i, j ) * s;
                
        end
            
    end
        
end
    
[ TrainR, Test_eR, Test_lR, TestR ] = SplitIntoTrainTest( MR, Wtrain, Wtest );
    
    
    

            
            
            

