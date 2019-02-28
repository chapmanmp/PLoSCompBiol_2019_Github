%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Margaret P. Chapman
% Date: June 13, 2017

% PURPOSE: Return train test data & wells for cross-validation, even death, agent a
% INPUT:
    % EVEN_DEATH = death option index for even death
    % P_a{k}(i, w) = # phenotype i (live & dying), well w, time k, agent a
    % d_a{k}(w) = fraction dying, well w, time k, agent a
    % N_CV = # test wells
    % N_WELL = # wells in total
    % X = NaN if function is called for model id alone
    % X = filled-in/optimized data, even death, if function is called for bootstrap
% OUTPUT:
    % Train = train data, even death
    % Wtrain = train wells
    % Test_e = test data, earlier time pts, even death
    % Test_l = test data, later time pts, even death
    % Test = test data, all time pts, even death
    % Wtest = test wells
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ Train, Wtrain, Test_e, Test_l, Test, Wtest ] = GetTrainTestDW( EVEN_DEATH, P_a, d_a, N_CV, N_WELL, X ) 

Wfull = GetFullWellIndices( P_a, d_a );                                                 % wells with all samples available for all time

Wtest = Wfull( 1:N_CV );                                                                % test wells

Wtrain = setdiff( 1:N_WELL, Wtest );                                                    % train wells

[ Train, Test_e, Test_l, Test ] = ProcessCVData( EVEN_DEATH, P_a, d_a, Wtrain, Wtest ); % train & test data, even death 

% if function is called for bootstrap, resample train & test data
if ~isnan(X), [ Train, Test_e, Test_l, Test ] = GenerateWildBootData( Train, Wtrain, Test, Wtest, X ); end




















                     