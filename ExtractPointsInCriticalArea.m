function [scan_current_x_close, scan_current_y_close, scan_current_x_sensor_back, scan_current_y_sensor_back] = ExtractPointsInCriticalArea(scan_x_values, scan_y_values)
 
numScans = size(scan_x_values, 1); % number of rows -> scanNumber
numPoints = 421; 

% threshlods for area on the left side of sensor (where cars usually overtake)
threshold_x_max = 5;
threshold_x_min = 0.2;
threshold_y_max = 2;
threshold_y_min = 0.2;

% thresholds for the area directly in fornt of the sensor (rear of bicycle)
threshold_x_back_max = 1.2; 
threshold_x_back_min = -1; 
threshold_y_back_max = 8; 
threshold_y_back_min = 0.2; 

% mark points that enter these areas

% go over all scans
for i = 1 : numScans

    % store the current scan (one row)
    scan_current_x = scan_x_values(i,:);
    scan_current_y = scan_y_values(i,:);
    
    % in each scan go over all points and check wethear they within the
    % desired thresholds -> store if yes, if not set the value to NaN

    for n = 1: numPoints
        if scan_current_x(n) > threshold_x_min && scan_current_x(n) < threshold_x_max
            if scan_current_y(n) > threshold_y_min && scan_current_y(n) < threshold_y_max
               scan_current_x_close(i,n) = scan_current_x(n);
               scan_current_y_close(i,n) = scan_current_y(n);
            end
        else 
            scan_current_x_close(i,n) = NaN; 
            scan_current_y_close(i,n) = NaN; 
        end
    end

    for n = 1 : numPoints
        if scan_current_x(n) > threshold_x_back_min && scan_current_x(n) < threshold_x_back_max
            if scan_current_y(n) > threshold_y_back_min && scan_current_y(n) < threshold_y_back_max
                scan_current_x_sensor_back(i,n) = scan_current_x(n);
                scan_current_y_sensor_back(i,n) = scan_current_y(n);
            end
        else
            scan_current_x_sensor_back(i,n) = NaN; 
            scan_current_y_sensor_back(i,n) = NaN; 
        end
    end

end

end