%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 30, 2017

%PURPOSE: Precompute train & test matrices for each death option, for CV STUDY
%INPUT:
    % P_a{k}(i, w) = # phenotype i (live & dying), well w, time k, agent a
    % d_a{k}(w) = fraction dying, well w, time k, agent a
    % DO = # death options
    % Wtrain = train wells
    % Wtest = test wells
%OUTPUT: 
    % Trains{o} = train matrix, function of death option o
        %[ x[1, Wtrain(1)],..., x[1, Wtrain(10)],..., x[7, Wtrain(1)],..., x[7, Wtrain(10) ]
    % Tests_e{o} = test data earlier times (0h, ..., 60h), function of death option o
        %[ x[1, Wtest(1)],..., x[1, Wtest(5)],..., x[6, Wtest(1)],..., x[6, Wtest(5)] ]
    % Tests_l{o} = test data later times (12h, ..., 72h), function of death option o 
        %[ x[2, Wtest(1)],..., x[2, Wtest(5)],..., x[7, Wtest(1)],..., x[7, Wtest(5)] ]
    % Tests{o} = test data all times, function of death option o
        %[ x[1, Wtest(1)],..., x[1, Wtest(5)],..., x[7, Wtest(1)],..., x[7, Wtest(5)] ]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ Trains, Tests_e, Tests_l, Tests ] = ProcessCVData_CVSTUDY( P_a, d_a, DO, Wtrain, Wtest ) 

N_TEST = length( Wtest );   % # test wells

Trains = cell( DO, 1 ); 
Tests_e = cell( DO, 1 ); 
Tests_l = cell( DO, 1 ); 
Tests = cell( DO, 1 );

for o = 1 : DO %for each death option: 1, 2, or 3
        
    Trains{o} = GetCellCtsMATRIX( GetCellCtsCELL( P_a, d_a, o, Wtrain ), Wtrain );
    
    Tests{o} = GetCellCtsMATRIX( GetCellCtsCELL( P_a, d_a, o, Wtest ), Wtest );
    
    Tests_e{o} = Tests{o}( :, 1 : end - N_TEST );         % time pts  0h, 12h, ..., 60h, 'e' for earlier

    Tests_l{o} = Tests{o}( :, N_TEST + 1 : end );         % time pts 12h, 24h, ..., 72h, 'l' for later
       
end
