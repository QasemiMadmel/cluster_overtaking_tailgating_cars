function all_dangerous_clusters = detectDangerousObject(all_clusters, object_properties,ego_velocity_mean)

% danger = [scannumber, cluster id, mean_to_origin]
danger.scannumber = [];
danger.clusterId = [];
danger.meanToOrigin = [];
danger.egoVelocity = [];
threshold_distance_to_sensor = 2; 
j = 1; 

for i = 1:length(all_clusters)-1
    
    x_mean = all_clusters{i}.meanValue.centerX;
    y_mean = all_clusters{i}.meanValue.centerY;

    distance_cluster_to_origin = sqrt(x_mean^2 +y_mean^2);
    currentId = all_clusters{i}.id; 
    

    objectIndex = find([object_properties.id] == currentId, 1);
    
    if ~isempty(objectIndex)
        if distance_cluster_to_origin < threshold_distance_to_sensor && ...
            object_properties(objectIndex).approaching && ...
            ego_velocity_mean(all_clusters{i}.numScan) > 0.6  % ~ > 2km/h  
                danger.scannumber = all_clusters{i}.numScan; 
                danger.clusterId = currentId;
                danger.meanToOrigin = distance_cluster_to_origin;
                danger.egoVelocity = ego_velocity_mean(i); 
                all_dangerous_clusters{j}= danger; 
                j = j+1; 
        end 
        danger.scannumber = [];
        danger.clusterId = [];
        danger.meanToOrigin = [];
        danger.egoVelocity = [];

    end
end
end