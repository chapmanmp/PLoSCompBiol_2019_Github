%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Finds the best initial condition (in a weighted least-square sense) for a given dynamics matrix
% INPUT:
    % Ma = data sample matrix, all states (may have nan's)
    %       well 1, well 2, ... , well N_W ... well 1, well 2, ..., well N_W
    %       |---------k=1-----------------|...|---------k=N_T---------------|
    % N_W = # wells in data sample matrix 
    % N_T = # time points for data sample matrix
    % A = dynamics matrix that we would like to find the best initial condition for
% OUTPUT:
    % x0 = solution to a weighted least-squares problem
    % is chosen so that     x0 is close to data samples at time 0h  (k=1)
    %                     A*x0 is close to data samples at time 12h (k=2)
    %                   A*A*x0 is close to data samples at time 24h (k=3), etc.
% Author: Margaret Chapman
% Date: November 14, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x0Star = getBestIC_Fall2018( Ma, N_W, N_T, A, N_STATE )

% want to put in bigA * x0 - y form

y = []; bigA = []; A_k = eye(N_STATE);

for k = 1 : N_T
    
    cols_k = (k-1)*N_W + 1 : k*N_W; % cols of samples at time k, wells 1 to N_W
    
    Ma_k = Ma(:, cols_k);           % samples at time k, wells 1 to N_W
    
    % for each sample at time k, if not nan, store sample & dynamics matrix A^(k-1)
    for w = 1 : N_W, if ~isnan(Ma_k(1,w)), y = [ y; Ma_k(:,w) ]; bigA = [ bigA; A_k ]; end; end
 
    A_k = A_k * A;                  % k = 1, A_k = I 
                                    % k = 2, A_k = A
                                    % k = 3, A_k = A*A
end

%myweights = sqrt(y); % what happens if I chose this to be the weights? - similar to unweighted case

% extrafactor = repmat([1; 10; 10; 10; 1], N_W*N_T, 1); 
% try putting lots of weight on red -- does this improve anything: the fit gets much much better, but i think that this is overfitting
% Instead, lets put slightly more weight on the K14low cells because these fit not so well
    % this says that we want to penalize error in K14low cells more than K14hi
    % cells b/c we already know that there will be error in the latter due to differences in the experiments

% extrafactor = repmat([1; sqrt(10); sqrt(10); sqrt(10); 1], N_W*N_T, 1);
% get very large spread in K14hi for BEZ, time 0

myweights = 1./sqrt(y);             % 1/sqrt(#cells) for each element

bigA = diag(myweights) * bigA;

y = diag(myweights) * y;            % weighted least squares (looks better than unweighted least squares)
                                    % Ref: https://en.wikipedia.org/wiki/Weighted_least_squares
cvx_begin quiet

    cvx_solver mosek;
    
    variable x0(N_STATE,1) nonnegative
    
    minimize( norm( bigA*x0 - y, 2 ) )

cvx_end

if ~strcmp( cvx_status, 'Solved' ), error('getBestIC_Fall2018 cvx not solved'); end;
                                    
x0Star = x0;    

% unconstrained least squares sometimes produces negative numbers which is not reasonable.
% x0 = (bigA'*bigA)\(bigA'*y);    % A\b for inv(A)*b
                                  % weighted least squares solution
% this is why we use constrained least squares

% for N_W = 4, N_T = 6;
% bigA = [ I ;
%          I ;
%          I ;
%          I ;
%          A ;
%          A ;
%          A ;
%          A ;
%        A*A ;
%        A*A ;
%        A*A ;
%        A*A ;
%         :  ;
%        A^5 ;
%        A^5 ;
%        A^5 ;
%        A^5 ];

%y = Ma(:); Ak = eye(N_STATE); bigA = [];
%for k = 1 : N_T, bigA = [ bigA; repmat( Ak, N_W, 1 ) ]; Ak = Ak * A; end
