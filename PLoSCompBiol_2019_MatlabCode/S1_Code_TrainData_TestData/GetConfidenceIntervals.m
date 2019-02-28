%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Computes upper and lower bounds of a 95% confidence interval for each dynamics parameter.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%X-axis key: 1 = p1, 2 = p12, 3 = p13, 4 = p14, 5 = p1D, 6 = p21, 7 = p2, 8 = p23, 9 = p24, 10 = p2D, 11 = p31, 12 = p32, 13 = p3, 14 = p34, 15 = p3D, 16 = p41, 17 = p42, 18 = p43, 19 = p4, 20 = p4D

function B = GetConfidenceIntervals(ParameterSet)

[NBoot,NUMParam] = size(ParameterSet);

f = 0.95;

B = zeros(2,NUMParam);

for j = 1:NUMParam
    sj = sort(ParameterSet(:,j),'descend'); %Sorts values of parameter j in descending order: top = largest, bottom = smallest.
    NToShaveEachEnd = floor(NBoot*(1-f)/2); %Round DOWN to nearest int. Remove LESS numbers from top and bottom. More conservative CI.
    uCI = sj(NToShaveEachEnd+1); %Upper bound
    lCI = sj(NBoot-NToShaveEachEnd); %Lower bound
    B(:,j) = [uCI; lCI];
end

%TestScript_GetConfidenceIntervals.m 4/21/2016








