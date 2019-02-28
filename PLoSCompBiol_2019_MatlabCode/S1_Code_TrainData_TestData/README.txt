Author: Margaret P. Chapman
Date: June 23, 2017
Purpose: Description of functions for phenotype dynamics code

AlternateMinimums.m : Executes alternating minimization to optimize dynamics with (lambda, mu, gamma), specific agent.

argmin_A_Xfix.m : Finds dynamics (A) that minimizes the cost function for fixed filled-in cell counts (X).

argmin_X_Afix.m : Finds cell count matrix (X) that minimizes the cost function for fixed dynamics (A).

CombineTrainTestData.m : Forms pre-optimization data for all (train + test) wells, death option o.

Cost.m: Defines cost function for alternating minimization.

CrossValidate.m : Gets best training parameters via cross validation.

FigureSettings.m : Sets figure settings for nice plots.

GenerateWildBootData.m : Resamples residuals via bootstrap technique proposed by Wu 1986.

GetAvailableSamples.m : Returns column indices of available samples.

GetBestReg_BYo.m : Extracts best (lambda, mu) for each death option, based on cross-validation.

GetCellCtsCELL.m : Gets cell counts for all samples given specific death allocation option & agent.

GetCellCtsMATRIX.m : Computes cell count matrix for cvx optimization, agent a.

GetCellCtsVEC.m : Gets cell count vector for one sample given live & dying phenotype tallies, fraction dying, g+, & g-.

GetCombinations.m : Sorts combinations of (lambda, mu, death option) into an easy-access matrix.

GetConfidenceIntervals.m : Computes upper and lower bounds of a 95% confidence interval for each dynamics parameter.

GetFullWellIndices.m : Identifies indices of wells with phenotype & death timeseries raw data fully available.

GetK14.m : Converts phenotypes to K14+, K14-.

GetNormFactors.m : Computes normalization factors for each term in cost function.

GetTrainTestDW.m : Returns train test data & wells for cross-validation, agent a.

GetWarmStart.m : Computes 'warm' starting condition for data in alternating minimization.

IdentifyDynamics.m : Performs all model identification computations, agent a.

Main_PhenotypeDynamics.m : Main script for phenotype dynamical model.

PlotConfidenceIntervals.m : Plots 95% confidence intervals for all dynamics parameters and all agents.

PREPSeeDynFit.m : Sorts test sample & prediction into data structures for later plotting.

ProcessCVData.m : Precomputes train & test matrices for each death option.

ReadDeathOption.m : Returns value of gamma_hi & value of gamma_lo given sample & death option.

SeeCV.m : Shows cross-validation error vs. (lambda, mu, death option), agent a.

SeeDynFit.m : Shows how well dynamics identified on 15-well data fits to 4-well data.

SeePrePostData.m : Shows distribution of post-optimization vs pre-optimization data.

SetupAM.m : Performs one-time calculations for alternating minimization.

SortBySeries.m : Separates phenotype & death timeseries.

SortRawData.m : Sort raw data according to agent & time point.

SplitIntoTrainTest.m : Split full data matrix into train & test.

StackDynamicsParametersHorizonally.m : Arranges parameters by replacing diagonals with cell division gains and transposing each column of the dynamics matrix.

Test_SetUp.m : Test script for set-up.

Timeseries_Raw_4wells.xlsx : raw 4-well phenotype & death timeseries data for testing dynamics

Timeseries_Raw_15wells.xlsx : raw 15-well phenotype & death timeseries data for identifying dynamics

---------------------------------------------------------------------------
Revisions - Fall 2018

SYS ID WITHOUT REDUNDANT SECOND LOOP
AlternateMinimums_Fall2018.m : ensures that we break out of optimization loop if it's successful
argmin_A_Xfix_Fall2018.m : redundant second loop corrected
    -specified w/ "Fall2018" so readers would have access to the original code as well
argmin_X_Afix_Fall2018.m : redundant second loop corrected
    -specified w/ "Fall2018" so readers would have access to the original code as well
IdentifyDynamics_Fall2018.m : facilitates AlternateMinimums_Fall2018.m

CONVERGENCE OF AM ALGORITHM
seeEvol_of_A_inAM.m : shows how the dynamics parameters evolve at each iteration of AM algorithm

ENSEMBLE MODELING
Script_Revisions_Fall2018_ENSEMBLEonestep.m : uses ensemble modeling to make predictions
getPredBandENSEMBLE.m : provides a band around the median of the trajectories
getPredOneStepENSEMBLE.m : returns predicted state trajectories under all bootstrap models, agent a
getPredvsSampSTAT.m : quantifies concordance/disconcordance between two time-series data sets via two-way ANOVA
plotBandENSEMBLE.m : shades the space between an upper curve and a lower curve, and plots a middle curve
plotDataSampENSEMBLE.m : plots data samples over the time horizon

P-VALUES FOR DYNAMICS PARAMETERS
Script_Revisions_Fall2018_PvalsDynParam.m : computes a p-value for each dynamics parameter using bootstrapped samples

STARTING FROM MULTIPLE INITIAL CONDITIONS
Script_Revisions_Fall2018_SysIDMULTIC.m : does sys id from multiple initial conditions
GetWarmStart_MULTIC.m : adds noise to inital cell counts matrix
AlternateMinimums_Fall2018_forMULTI.m : does alternating mimization for multiple initial conditions
IdentifyDynamics_Fall2018_forMULTIC.m : facilitates AlternateMinimums_Fall2018_forMULTI.m

COMPARE (2 phenotype)-SINGLE-MODEL ONE-STEP PREDICTION VERSUS TEST DATA (4-WELL)
Script_Revisions_Fall2018_2pMODELvsTestData.m : compares 2-phenotype best fit model to 4-well test data
getPredCellONEMODEL.m : puts model predictions to a cell for later analysis
getPredvsSampSTAT.m : computes p-values to compare model predictions and data (also used for ENSEMBLE MODELING revisions)
getPredULBandONEMODEL.m : computes max/median/min of model predictions for plotting of band
plotBandENSEMBLE.m : plots max/min band of model predictions, dotted median (also used for ENSEMBLE MODELING revisions)
plotDataSampENSEMBLE.m : plots data samples over the time horizon (also used for ENSEMBLE MODELING revisions)

IMPROVED PRESENTATION OF TRAMETINIB AND COMBINATION HYPOTHESES
try_script_hyp_imppres_fall2018rev.m : plots test data samples and prediction curves for Tram, Comb. under
    default constraints, extra constraints. 
    Contains p-values, min/max/median prediction curves (pink band), test data samples (black stars)
 
