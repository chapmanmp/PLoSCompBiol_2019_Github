%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Provides a p-value for each dynamics parameter using bootstrapped parameter values
% The p-value is the outcome of a two-sided one-sample sign test: a non-parametric test for the median of a population
% For a given dynamics parameter, p<0.05 means that the bootstrapped values are significantly different from a default value
% Author: Margaret Chapman
% Date: November 19, 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clearvars; clc;

load('Results_Summer_2017\bootstrap\bootstrap_K14K19VIM_aug6.mat');
% paramB{a}(b,j) = dynamics parameter j, bootstrap interation b, agent a
% parameter 1   2     3    4   5     6   7    8    9    10   11  12   13  14    15  16    17   18  19  20  
%           p1, p12, p13, p14, p1D, p21, p2, p23, p24, p2D, p31, p32, p3, p34, p3D, p41, p42, p43, p4, p4D
% B = total number of bootstrap iterations

myDEFAULTparam = ...
            [1   0    0    0    0    0   1    0    0    0    0    0   1   0     0    0    0    0   1    0]; 
% default parameter values = no growth (rho_i = 1), no switching (rho_ij = 0), no death (rho_iD = 0)
%       chosen based on my conversation with Anil (Nov. 16, 2018)

N_PARAM = length(PARAM); % # dynamics parameters

pvals_PARAM = cell(N_AGENT,N_PARAM); %pvals_PARAM{a}{j} = p value for parameter j, agent a

rng('default'); % set random number generator to default values

for a = 1 : N_AGENT
        
    for j = 1 : N_PARAM % for each dynamics parameter
                                            % add zero mean gaussian noise to make distribution continuous
        mysamples_paramj = paramB{a}(:,j) + 10^(-7)*randn(B,1); % values of parameter j, agent a
        
        hyp_median_paramj = myDEFAULTparam(j);  % null hypothesis is that parameter j's distribution has median of hyp_median_paramj
        
        pvals_PARAM{a}{j} = signtest(mysamples_paramj,hyp_median_paramj,'Method','exact','Tail','both'); 
        % p = signtest(x,m) tests the hypothesis that data in x has a continuous distribution with median m against the alternative that the distribution does not have median m at the 5% significance level.
        % p < 0.05 means that the null hypothesis of median m is rejected
        % p >= 0.05 means that the null hypothesis of median m is not rejected
    end
    
end

figure; FigureSettings;
subplot(2,3,1); hist(paramB{2}(:,2)); title('\rho_{12}, Tram.'); ylabel('# samples');
subplot(2,3,2); hist(paramB{2}(:,4)); title('\rho_{14}, Tram.');
subplot(2,3,3); hist(paramB{1}(:,5)); title('\rho_{1D}, DMSO');
subplot(2,3,4); hist(paramB{3}(:,5)); title('\rho_{1D}, BEZ'); ylabel('# samples'); xlabel('value of sample');
subplot(2,3,5); hist(paramB{2}(:,9)); title('\rho_{24}, Tram.'); xlabel('value of sample');
subplot(2,3,6); hist(paramB{3}(:,11)); title('\rho_{31}, BEZ'); xlabel('value of sample');

% rho_1, Combo no added noise
a = 4; j = 1; 
signtest(paramB{a}(:,j),1,'Method','exact','Tail','both')
hist(paramB{a}(:,j)); title('\rho_{1}, Comb.'); xlabel('value of sample'); ylabel('# samples');


