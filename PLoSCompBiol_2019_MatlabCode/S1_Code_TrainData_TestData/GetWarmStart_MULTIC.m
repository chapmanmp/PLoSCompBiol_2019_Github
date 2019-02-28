%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: November 6, 2018

%PURPOSE: Compute 'warm' starting condition for data in alternating minimization
%INPUT:
    %M = [ x[1,W(1)] ... x[1,W(end)], ..., x[7,W(1)] ... x[7,W(end)] ], cell count matrix
        % first entry of x is NaN \iff x is not available
    %Jav = col indices of M's available samples
    %N_W = # wells in M
%OUTPUT: Cell count matrix, same format as INPUT, missing samples at time k
%replaced with averaged available samples at time k + guassian noise
%NOTE: Assumes there is at least one available sample per time pt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function X = GetWarmStart_MULTIC( M, Jav, N_W )

m = size( M, 2 );                       % # samples

N_TIME = m / N_W;                       % # time points = # samples / # wells in M

Jna = setdiff( 1:m, Jav );              % col indices of M's not available samples

X = M;

for k = 1 : N_TIME
    
    J_k = (k-1)*N_W + 1 : k*N_W;                            % indices of samples(k)
    
    Jna_k = intersect( Jna, J_k );                          % indices of samples(not available, k)
    
    if ~isempty( Jna_k )                                    % if there is at least one sample(not available, k)
    
        Jav_k = intersect( Jav, J_k );                      % indices of samples(available, k)
    
        x_k = mean( M( :, Jav_k ), 2 );                     % average samples(available, k)
        
        avail_samples_k = [];                               % format available samples, time k for covariance computation
        for j = 1:length(Jav_k)                      % jth available sample at time k
            avail_samples_k = [avail_samples_k; M(:, Jav_k(j))']; % transpose observation vector, then stack row-by-row
        end
        sample_cov_k = cov(avail_samples_k);            % covariance matrix of available samples at time k
        
        for s = 1:length(Jna_k)           % row vec  
            noisy_na_k_sampleEst = mvnrnd( x_k', sample_cov_k ); % multivariate normal distribution sample with mean xk' and covariance sample_cov_k, returns row vector 
            X( :, Jna_k(s) ) = noisy_na_k_sampleEst';            % fill in jth sample(not available, k) with noisy estimate
        end
        %X( :, Jna_k ) = repmat( x_k, size(Jna_k) );         % fill in samples(not available, k)
    end 
    
end
                
                
    
    
    
    