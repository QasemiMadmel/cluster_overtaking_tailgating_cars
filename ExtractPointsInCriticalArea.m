function  [scan_current_x_close, scan_current_y_close] = ExtractPointsInCriticalArea(scan_x_values, scan_y_values)
 
numScans = size(scan_x_values, 1);
numPoints = 421; 
threshold_x_max = 3;
threshold_x_min = 0.2;
threshold_y_max = 2;
threshold_y_min = 0.2;

% mark points that enter this area
% area: (x < 3 ; y < 2) 

for i = 1 : numScans
    scan_current_x = scan_x_values(i,:);
    scan_current_y = scan_y_values(i,:);
    
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

end

end