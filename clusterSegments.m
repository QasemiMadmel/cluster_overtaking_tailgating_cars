function arrayOfSegments = clusterSegements(x_scan_points, y_scan_points)
    
    % arrayOfSegments: (1.segment, 2.segment ...) 
    % clusteredObject: (1.Scannumber, 2.x_value, 3.y_value); 

    clusteredSegement.numScan = []; 
    clusteredSegement.x = [];
    clusteredSegement.y = []; 
    meanValue.centerX = [];
    meanValue.centerY = [];
    clusteredSegement.meanValue = [];
    clusteredSegement.length = [];

    numScans = size(x_scan_points, 1); 
    numPoints = 421;
    
    upper_threshold = 0.5; 
    lower_threshold = 0.005; 
    
    segmentStarted = false; 
    lengthOfSegement = 1; 
    
    i = 1; m = 2; count = 0; 
     
    for n = 1:numScans
        segmentStarted= false;
        for m = 2:numPoints
    
            if isnan(x_scan_points(n,m-1)) || isnan(x_scan_points(n,m))
                continue;
            end
        
            dx = x_scan_points(n,m) - x_scan_points(n,m-1);
            dy = y_scan_points(n,m) - y_scan_points(n,m-1);
       
            distance = sqrt(dx^2 + dy^2);
        
            if distance < upper_threshold && distance > lower_threshold
                segmentStarted = true; 
                count = count+1; 
                clusteredSegement.numScan = n; 
                clusteredSegement.x(end+1) = x_scan_points(n,m-1);
                clusteredSegement.y(end+1) = y_scan_points(n,m-1);
                
            else
                if segmentStarted
                    
                    center_x = mean(clusteredSegement.x);
                    center_y = mean(clusteredSegement.y);
                    clusteredSegement.meanValue.centerX = center_x;
                    clusteredSegement.meanValue.centerY = center_y;

                    lengthOfSegement = length(clusteredSegement.x);
                    clusteredSegement.length = lengthOfSegement;
                    
                    arrayOfSegments{i} = clusteredSegement; 
                    i = i+1; 
                    segmentStarted=false;
                    clusteredSegement.numScan = []; 
                    clusteredSegement.x = [];
                    clusteredSegement.y =[]; 
                    clusteredSegement.meanValue.centerX =[]; 
                    clusteredSegement.meanValue.centerY =[]; 
                    clusteredSegement.length = [];
    
                end
            end
        end
        if m == numPoints
                if segmentStarted
                    center_x = mean(clusteredSegement.x);
                    center_y = mean(clusteredSegement.y);
                    clusteredSegement.meanValue.centerX = center_x;
                    clusteredSegement.meanValue.centerY = center_y;
                    lengthOfSegement = length(clusteredSegement.x);
                    clusteredSegement.length = lengthOfSegement;
                    arrayOfSegments{i} = clusteredSegement; 
                end
        end
    end
end