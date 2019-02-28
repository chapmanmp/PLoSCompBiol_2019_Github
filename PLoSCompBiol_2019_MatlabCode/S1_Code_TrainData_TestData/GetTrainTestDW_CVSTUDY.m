%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Margaret P. Chapman
% Date: July 26, 2017

% PURPOSE: Return train test data & wells for cross-validation, agent a
         % For CV STUDY (all death options)
% INPUT:
    % DO = # death options
    % P{k}(i, w) = # phenotype i (live & dying), well w, time k, agent a
    % d{k}(w) = fraction dying, well w, time k, agent a
    % N_CV = # test wells
    % N_WELL = # wells in total
% OUTPUT:
    % Trains{o} = train data, death option o
    % Wtrain = train wells
    % Tests_e{o} = test data, earlier time pts, death option o
    % Tests_l{o} = test data, later time pts, death option o
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ Trains, Wtrain, Tests_e, Tests_l ] = GetTrainTestDW_CVSTUDY( DO, P, d, N_CV, N_WELL ) 

Wfull = GetFullWellIndices( P, d );                                             % wells with all samples available for all time

Wtest = Wfull( 1:N_CV );                                                        % test wells

Wtrain = setdiff( 1:N_WELL, Wtest );                                            % train wells

[ Trains, Tests_e, Tests_l, Tests ] = ProcessCVData_CVSTUDY( P, d, DO, Wtrain, Wtest ); % train & test data
