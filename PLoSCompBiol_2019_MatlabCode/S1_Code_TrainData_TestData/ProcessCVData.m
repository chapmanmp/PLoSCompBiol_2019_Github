%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 30, 2017

%PURPOSE: Precompute train & test matrices, even death
%INPUT:
    % EVEN_DEATH = death option index for even death
    % P_a{k}(i, w) = # phenotype i (live & dying), well w, time k, agent a
    % d_a{k}(w) = fraction dying, well w, time k, agent a
    % Wtrain = train wells
    % Wtest = test wells
%OUTPUT: 
    % Train = train matrix, even death
        %[ x[1, Wtrain(1)],..., x[1, Wtrain(10)],..., x[7, Wtrain(1)],..., x[7, Wtrain(10) ]
    % Test_e = test data earlier times (0h, ..., 60h), even death
        %[ x[1, Wtest(1)],..., x[1, Wtest(5)],..., x[6, Wtest(1)],..., x[6, Wtest(5)] ]
    % Test_l = test data later times (12h, ..., 72h), even death
        %[ x[2, Wtest(1)],..., x[2, Wtest(5)],..., x[7, Wtest(1)],..., x[7, Wtest(5)] ]
    % Test = test data all times, even death
        %[ x[1, Wtest(1)],..., x[1, Wtest(5)],..., x[7, Wtest(1)],..., x[7, Wtest(5)] ]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
function [ Train, Test_e, Test_l, Test ] = ProcessCVData( EVEN_DEATH, P_a, d_a, Wtrain, Wtest ) 

N_TEST = length( Wtest );   % # test wells

Train = GetCellCtsMATRIX( GetCellCtsCELL( P_a, d_a, EVEN_DEATH, Wtrain ), Wtrain );
    
Test = GetCellCtsMATRIX( GetCellCtsCELL( P_a, d_a, EVEN_DEATH, Wtest ), Wtest );
    
Test_e = Test( :, 1 : end - N_TEST ); % time pts  0h, 12h, ..., 60h, 'e' for earlier

Test_l = Test( :, N_TEST + 1 : end ); % time pts 12h, 24h, ..., 72h, 'l' for later
       

