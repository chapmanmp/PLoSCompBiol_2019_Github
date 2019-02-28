%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 11, 2017

%PURPOSE: Sort raw data according to agent & time point
%INPUT:
    %FILE_NAME = data file name 
    %SHEET_NAME = sheet name
    %COL_ROW_1 = 1st col-row  (str)
    %COL_ROW_L = last col-row (str)
    %N_AGENT = # agents
    %N_TIME  = # time points
    %N_WELL  = # wells
%OUTPUT:
    % raw_agent{a}{k} : raw data matrix, agent a, time k 
    % cols : [ # K14+, # VIM+/K14-, # K19+/K14-/VIM-, # all low, NaN, # total, # dying]
    % row  1 : NaNs
    % row  2 : well 1
    % row 16 : well 15
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function raw_agent = SortRawData( FILE_NAME, SHEET_NAME, COL_ROW_1, COL_ROW_L, N_AGENT, N_TIME, N_WELL ) 

raw = xlsread( FILE_NAME, SHEET_NAME, [ COL_ROW_1 ':', COL_ROW_L ] ); %xlsread removes NaN first row
raw = [ NaN(1, 7); raw ];

%row  1 : NaNs
%row  2 to 16 : dmso, 0 h, well 1 to 15
%row 17 : NaNs
%row 18 to 32 : tram, 0 h, well 1 to 15
%row 33 : NaNs
%row 34 to 48 : bez2, 0 h, well 1 to 15
%row 49 : NaNs
%row 50 to 64 : comb, 0 h, well 1 to 15
%etc.

ROWak = N_WELL + 1;        % # rows per agent per time = 15 well rows + 1 blank row

ROWk  = ROWak * N_AGENT;   % # rows per time

raw_agent = cell( N_AGENT, N_TIME ); %raw_agent{a}{k} = raw data, agent a, time k

for k = 1 : N_TIME
    
    raw_k = raw( (k-1)*ROWk + 1 : k*ROWk, : ); %raw data, time k
    
    for a = 1 : N_AGENT
        
        raw_agent{a}{k} = raw_k( (a-1)*ROWak + 1 : a*ROWak, : ); %raw data, agent a, time k
            
    end
    
end






                