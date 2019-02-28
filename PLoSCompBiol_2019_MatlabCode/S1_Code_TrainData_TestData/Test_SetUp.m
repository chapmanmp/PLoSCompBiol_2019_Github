% Test script for SET-UP section

function Test_SetUp( P, d )

err = 0;

% Tram, 0 h, well 4
if ~isequal( P{2}{1}(:, 4), [ 225; 560; 31; 59 ] )
    disp( 'Test 1 failed' );
    err = err + 1;
end

% DMSO, 12 h, well 6
if ~( isnan( P{1}{2}(1, 6) ) && isnan( P{1}{2}(2, 6) ) && isnan( P{1}{2}(3, 6) ) && isnan( P{1}{2}(4, 6) ) )
    disp( 'Test 2 failed' );
    err = err + 1;
end

% Comb, 60 h, well 9
if ~isequal( P{4}{6}(:, 9), [ 121; 219; 260; 102 ] )
    disp( 'Test 3 failed' );
    err = err + 1;
end

% Tram, 36 h, well 1
if ~isnan( d{2}{4}(1) )
    disp( 'Test 4 failed' );
    err = err + 1;
end

% BEZ, 48 h, well 14
if d{3}{5}(14) ~= 41/717
    disp( 'Test 5 failed' );
    err = err + 1;
end

% Comb, 72 hr, well 15
if d{4}{7}(15) ~= 198/483
    disp( 'Test 6 failed' )
    err = err + 1;
end

if err == 0, disp( 'SET-UP: Great! All tests passed!' ); end
    