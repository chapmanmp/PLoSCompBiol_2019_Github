%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 11, 2017

%PURPOSE: Separates phenotype & death timeseries
%INPUT:
    % rawdata{a}{k} : raw data matrix, agent a, time k 
    % cols : [ # K14+, # VIM+/K14-, # K19+/K14-/VIM-, # all low, NaN, # total, # dying]
    % row  1 : NaNs
    % row  2 : well 1
    % row 16 : well 15
%OUTPUT:
    % P{a}{k} : phenotype counts (live & dead), agent a, time k
        % (row i, col w) : # phenotype i, well w
    % d{a}{k} : fraction dying, agent a, time k
        % col w : # dying / # total, well w 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ P, d ] = SortBySeries( rawdata )

[ N_AGENT, N_TIME ] = size( rawdata );

P = cell( N_AGENT, N_TIME );

d = cell( N_AGENT, N_TIME );

for a = 1 : N_AGENT
    
    for k = 1 : N_TIME
        
        raw_ak = rawdata{a}{k};
        
        raw_ak(1, :) = [];                              %remove NaN row
        
        p_ak = raw_ak( :, 1:4 );                        %col i : phenotype i, row w : well w
        
        d_ak = raw_ak( :, end ) ./ raw_ak( :, end-1 );  % # dying / # total,  row w : well w
        
        P{a}{k} = transpose( p_ak );              %row i : phenotype i; col w : well w
        
        d{a}{k} = transpose( d_ak );              %col w : well w
        
    end
    
end