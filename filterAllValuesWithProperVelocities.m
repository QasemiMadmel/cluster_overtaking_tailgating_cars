function [x_filtered, y_filtered, vx_filtered, vy_filtered, v_filtered, rssi_filterd, r_filtered] = filterAllValuesWithProperVelocities(x, y, vx, vy, v, rssi, r, numberOfPointsPerScan)
 
numberOfScans = floor(length(v)/numberOfPointsPerScan); 

x_filtered = zeros(numberOfScans, numberOfPointsPerScan); 
y_filtered = zeros(numberOfScans, numberOfPointsPerScan);
vx_filtered = zeros(numberOfScans, numberOfPointsPerScan);
vy_filtered = zeros(numberOfScans, numberOfPointsPerScan);
v_filtered = zeros(numberOfScans, numberOfPointsPerScan);
rssi_filterd = zeros(numberOfScans, numberOfPointsPerScan);
r_filtered = zeros(numberOfScans, numberOfPointsPerScan);

mask_for_valid_values = zeros(1, numberOfPointsPerScan); 

idx_point_in_file = 1; 

for i = 1:numberOfScans
    
    % save the current scan
    v_scan = v(idx_point_in_file : idx_point_in_file + numberOfPointsPerScan-1);
    x_scan = x(idx_point_in_file : idx_point_in_file + numberOfPointsPerScan-1);
    y_scan = y(idx_point_in_file : idx_point_in_file + numberOfPointsPerScan-1);
    vx_scan = vx(idx_point_in_file : idx_point_in_file + numberOfPointsPerScan-1);
    vy_scan = vy(idx_point_in_file : idx_point_in_file + numberOfPointsPerScan-1);
    rssi_scan = rssi(idx_point_in_file : idx_point_in_file + numberOfPointsPerScan-1);
    r_scan = r(idx_point_in_file : idx_point_in_file + numberOfPointsPerScan-1);

    % mask the proper values
    mask_for_valid_values = (v_scan<20 & v_scan>0); 

    % set everything else to NaN
    v_scan(~mask_for_valid_values) = NaN; 
    x_scan(~mask_for_valid_values) = NaN; 
    y_scan(~mask_for_valid_values) = NaN; 
    vx_scan(~mask_for_valid_values) = NaN; 
    vy_scan(~mask_for_valid_values) = NaN; 
    rssi_scan(~mask_for_valid_values) = NaN; 
    r_scan(~mask_for_valid_values) = NaN; 

    % filter all files based on proper velocity values
    v_filtered(i,:) = v_scan; 
    x_filtered(i,:) = x_scan;
    y_filtered(i,:) = y_scan; 
    vx_filtered(i,:) = vx_scan; 
    vy_filtered(i,:) = vy_scan; 
    rssi_filterd(i,:) = rssi_scan;
    r_filtered(i,:) = r_scan; 

    % get ready for the next scan
    idx_point_in_file = idx_point_in_file + numberOfPointsPerScan; 
    
end
end