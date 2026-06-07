function trimLidarData(filepath_xy, filepath_r, filepath_v, scanStart, scanEnd)

clc;

% ===== Parameter =====
scanPoints   = 421;  % XY / R / V
medianPoints = 4;    % Median-Datei

% ===== Load =====
xy = readmatrix(filepath_xy);       % [t x y]
r  = readmatrix(filepath_r);        % [t idx r]
v  = readmatrix(filepath_v);        % [t vx vy v]

% ===== Extract =====
t_xy = xy(:,1); x = xy(:,2); y = xy(:,3);
t_r  = r(:,1);  idx = r(:,2); rval = r(:,3);
t_v  = v(:,1);  vx = v(:,2); vy = v(:,3); vabs = v(:,4);

% ===== Scan counts =====
numScans_xy = floor(length(x)/scanPoints);
numScans_v  = floor(length(vx)/scanPoints);

fprintf('Scans XY  (raw): %d\n', numScans_xy);
fprintf('Scans V   (raw): %d\n', numScans_v);

diffScans = numScans_xy - numScans_v;

% =====================================================
% 1. ALIGNMENT (XY, R, RSSI!)
% =====================================================

if diffScans > 0
    fprintf('Aligning: removing first %d scan(s) from XY + R\n', diffScans);
    
    shift = diffScans * scanPoints;
    
    t_xy = t_xy(shift+1:end);
    x    = x(shift+1:end);
    y    = y(shift+1:end);
    
    t_r  = t_r(shift+1:end);
    idx  = idx(shift+1:end);
    rval = rval(shift+1:end);

end

% ===== Neue Scananzahlen =====
numScans_xy = floor(length(x)/scanPoints);
numScans_v  = floor(length(vx)/scanPoints);

fprintf('After alignment:\n');
fprintf('XY scans: %d\n', numScans_xy);
fprintf('V  scans: %d\n', numScans_v);

% gemeinsame Basis !!!
numScans = min([numScans_xy, numScans_v]);

% =====================================================
% Parameter Handling
% =====================================================
if scanStart == 0
    scanStart = 1;
end

if scanEnd == 0
    scanEnd = numScans;
end

if scanEnd > numScans
    warning('scanEnd reduziert auf %d', numScans);
    scanEnd = numScans;
end

if scanStart < 1 || scanStart > numScans
    error('scanStart ungültig');
end

if scanEnd < scanStart
    error('scanEnd < scanStart');
end

fprintf('Final scan range: %d → %d\n', scanStart, scanEnd);

% =====================================================
% 2. HINTEN ABSCHNEIDEN
% =====================================================

endIdx = scanEnd * scanPoints;
endIdx_m = scanEnd * medianPoints;

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
% 3. VORNE ABSCHNEIDEN
% =====================================================
startIdx = (scanStart-1)*scanPoints + 1;
startIdx_m = (scanStart-1)*medianPoints + 1;

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
% FINAL CHECK
% =====================================================
fprintf('--- FINAL CHECK ---\n');
fprintf('XY scans: %d\n', floor(length(x)/scanPoints));
fprintf('V  scans: %d\n', floor(length(vx)/scanPoints));

% =====================================================
% SAVE
% =====================================================
[folder, name_xy, ~] = fileparts(filepath_xy);
[~, name_r, ~]       = fileparts(filepath_r);
[~, name_v, ~]       = fileparts(filepath_v);

writematrix([t_xy x y], ...
    fullfile(folder, [name_xy '_TRIMMED.csv']));

writematrix([t_r idx rval], ...
    fullfile(folder, [name_r '_TRIMMED.csv']));

writematrix([t_v vx vy vabs], ...
    fullfile(folder, [name_v '_TRIMMED.csv']));


fprintf('DONE. Alle Dateien korrekt geschnitten.\n');

end

%[appendix]{"version":"1.0"}
%---
