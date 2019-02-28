%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Arranges parameters by replacing diagonals with cell division gains and transposing each column of the dynamics matrix.
%I.e., for n = 5, p1, p12, p13, p14, p1D, p21, p2, p23, p24, p2D, p31, p32, p3, p34, p3D, p41, p42, p43, p4, p4D.
%      for n = 3, p1, p12, p1D,           p21, p2, p2D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function p = StackDynamicsParametersHorizonally(A)

[n,~] = size(A);

p = zeros(1,n*(n-1));

for j = 1:n-1 %Iterate thru all columns except last.
    A(j,j) = sum(A(:,j)); %Replace diagonal term with cell division gain for phenotypic state j.
    p((j-1)*n + 1: j*n) = A(:,j)';
end

%j = 1, indices = 1:n
%j = 2, indices = n+1:2n
%j = 3, indices = 2n+1:3n
%j = 4, indices = 3n+1:4n

%VERIFICATION
%This function was tested during the week of 4/12/2016.
