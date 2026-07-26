function trimLidarData(filepath_xy, filepath_r, filepath_v, scanStart, scanEnd)

clc;
% ===== parameter =====
scanPoints   = 421;  % XY / R / V

% ===== Load =====
xy = readmatrix(filepath_xy);       % [t x y]
r  = readmatrix(filepath_r);        % [t idx r]
v  = readmatrix(filepath_v);        % [t vx vy v]

% ===== extract data =====
t_xy = xy(:,1); x = xy(:,2); y = xy(:,3);
t_r  = r(:,1);  idx = r(:,2); rval = r(:,3);
t_v  = v(:,1);  vx = v(:,2); vy = v(:,3); vabs = v(:,4);

% ===== scan counts =====
numScans_xy = floor(length(x)/scanPoints);
numScans_v  = floor(length(vx)/scanPoints);

fprintf('Scans XY  (raw): %d\n', numScans_xy);
fprintf('Scans V   (raw): %d\n', numScans_v);

diffScans = numScans_xy - numScans_v; 
% scannumber can be higher then the computed velocities because 
% velocities are normally calculated between two subsequent scans 

% =====================================================
% 1. Alighning the files based on their scan numbers (XY, R, RSSI!)
% delete scans from the beginning of the recording
% =====================================================
if diffScans > 0
    fprintf('Aligning: removing first %d scan(s) from XY and R\n', diffScans);
    
    shift = diffScans * scanPoints; 
    
    t_xy = t_xy(shift+1:end);
    x    = x(shift+1:end);
    y    = y(shift+1:end);
    
    t_r  = t_r(shift+1:end);
    idx  = idx(shift+1:end);
    rval = rval(shift+1:end);
end

% ===== update the scannumber after the shift =====
numScans_xy = floor(length(x)/scanPoints);
numScans_v  = floor(length(vx)/scanPoints);

fprintf('After alignment:\n');
fprintf('XY scans: %d\n', numScans_xy);
fprintf('V  scans: %d\n', numScans_v);

% take the lowst scannumber as basic scan number for both files 
numScans = min([numScans_xy, numScans_v]);

% =====================================================
% handling parameters
% =====================================================
if scanStart == 0
    scanStart = 1;
end

if scanEnd == 0
    scanEnd = numScans;
end

if scanEnd > numScans
    warning('scanEnd reduced to %d', numScans);
    scanEnd = numScans;
end

if scanStart < 1 || scanStart > numScans
    error('scanStart not varrified');
end

if scanEnd < scanStart
    error('scanEnd < scanStart');
end

fprintf('Final scan range: %d → %d\n', scanStart, scanEnd);

% =====================================================
% 2. cutting the scans at the end of the files; 
% example file: (------scanStart-----------scanEnd-----)
% =====================================================

endIdx = scanEnd * scanPoints;

t_xy = t_xy(1:endIdx);
x    = x(1:endIdx);
y    = y(1:endIdx);

t_r  = t_r(1:endIdx);
idx  = idx(1:endIdx);
rval = rval(1:endIdx);

t_v   = t_v(1:endIdx);
vx    = vx(1:endIdx);
vy    = vy(1:endIdx);
vabs  = vabs(1:endIdx);

% =====================================================
% 3. cutting the first scans based on given function parameter
% =====================================================
startIdx = (scanStart-1)*scanPoints + 1;
% example first two scans should be deleted (scanStart: 3)
% (3-1)*numberOfPoints = number of Points to delete!
% Index to Start the scans = numberOfPointsToDelete + 1

t_xy = t_xy(startIdx:end);
x    = x(startIdx:end);
y    = y(startIdx:end);

t_r  = t_r(startIdx:end);
idx  = idx(startIdx:end);
rval = rval(startIdx:end);

t_v   = t_v(startIdx:end);
vx    = vx(startIdx:end);
vy    = vy(startIdx:end);
vabs  = vabs(startIdx:end);

% =====================================================
% print the final scan number 
% =====================================================
fprintf('--- FINAL CHECK ---\n');
fprintf('XY scans: %d\n', floor(length(x)/scanPoints));
fprintf('V  scans: %d\n', floor(length(vx)/scanPoints));

% =====================================================
% store in new files with _TRIMMED as suffix 
% =====================================================
% fileparts deliver : (folder: the path for the folder data is stored in,
% name_... the name of file
% ~ the ending .csv

[folder, name_xy, ~] = fileparts(filepath_xy);
[~, name_r, ~]       = fileparts(filepath_r);
[~, name_v, ~]       = fileparts(filepath_v);

% fullfile: creares a file in the folder with the given name
% writematrix: writes the vectors in the given files

writematrix([t_xy x y], ...
    fullfile(folder, [name_xy '_TRIMMED.csv']));

writematrix([t_r idx rval], ...
    fullfile(folder, [name_r '_TRIMMED.csv']));

writematrix([t_v vx vy vabs], ...
    fullfile(folder, [name_v '_TRIMMED.csv']));

fprintf('DONE. all files are trimmed.\n');

end

%[appendix]{"version":"1.0"}
%---
