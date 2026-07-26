function clustersWithId = trackClustersBetweenScans(cluster)
    
% classify based on the scannumber 
% clusters in subsequent frames get the same id number (max number of gaps: 3 frames)

threshold = 0.8; % for an object moving 50 km/h (14 m/s) -> 14/15 = 0,93 is a good threshold 
idNumber = 1;
cluster{1}.id = idNumber; 
    
    for i = 1:length(cluster)-1

        % now calculate the distance between the meanpoints in
        % subsequent clusters; if the distance is below the defind
        % threshold, the current cluster is marked with the same id as the
        % previous one
        
        % subsequent scan is available: 
        if (cluster{i}.numScan) +1 == cluster{i+1}.numScan  

            % compute mean distance in between 
            deltaX = cluster{i+1}.meanValue.centerX - cluster{i}.meanValue.centerX;
            deltaY = cluster{i+1}.meanValue.centerY - cluster{i}.meanValue.centerY;
            distance_between_mean_values = sqrt((deltaX)^2 + ...
                                               (deltaY)^2);
            % check
            if distance_between_mean_values < threshold 
                
                % store the same id number in order to distinguish between
                % clusters
    
                cluster{i}.id = idNumber;
                cluster{i+1}.id = idNumber;
            else
                % otherwise just go to next cluster
                idNumber = idNumber+1;  
                cluster{i+1}.id = idNumber;  
            end

        % apply the same logic but allow a larger gap between two scans with clusters 
        elseif (cluster{i}.numScan +2) == cluster{i+1}.numScan 

            deltaX = cluster{i+1}.meanValue.centerX - cluster{i}.meanValue.centerX;
            deltaY = cluster{i+1}.meanValue.centerY - cluster{i}.meanValue.centerY;
            distance_between_mean_values = sqrt((deltaX)^2 + ...
                                               (deltaY)^2);
            
            if distance_between_mean_values < threshold 
                cluster{i}.id = idNumber;
                cluster{i+1}.id = idNumber;
            else
                idNumber = idNumber+1;  
                cluster{i+1}.id = idNumber; 
            end

        % gap of 3 frames 
        elseif (cluster{i}.numScan +3) == cluster{i+1}.numScan  
            
            deltaX = cluster{i+1}.meanValue.centerX - cluster{i}.meanValue.centerX;
            deltaY = cluster{i+1}.meanValue.centerY - cluster{i}.meanValue.centerY;
            distance_between_mean_values = sqrt((deltaX)^2 + ...
                                               (deltaY)^2);
            if distance_between_mean_values < threshold 
                cluster{i}.id = idNumber;
                cluster{i+1}.id = idNumber;
            else
                idNumber = idNumber+1;  
                cluster{i+1}.id = idNumber; 
            end
        
        else
            idNumber = idNumber+1;  
            cluster{i+1}.id = idNumber;  
        end
    
    end

    clustersWithId = cluster; 
end