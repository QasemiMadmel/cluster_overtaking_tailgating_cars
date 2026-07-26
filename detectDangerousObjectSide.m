function all_dangerous_clusters_side = detectDangerousObjectSide(all_clusters, object_properties, ego_velocity_mean)

all_dangerous_clusters_side = [];

% danger = [scannumber, cluster id, mean_to_origin]
danger.scannumber = [];
danger.x = [];
danger.y = [];
danger.clusterId = [];
danger.meanToOrigin = [];
danger.egoVelocity = [];
threshold_distance_to_sensor = 1.5; 
threshold_ego_velocity = 0.6; % ~ 2 km/h
j = 1; 

% go over all clusters
for i = 1:length(all_clusters)-1
    
    % get their center
    x_mean = all_clusters{i}.meanValue.centerX;
    y_mean = all_clusters{i}.meanValue.centerY;
    
    % get the corner of the cluster
    [y_min_corner, index_y_min_corner] = min(all_clusters{i}.y); 
    x_corresponding_to_y_min = all_clusters{i}.x(index_y_min_corner); 

    [x_min_corner, index_x_min_corner] = min(all_clusters{i}.x); 
 
    % calculate all distances: 
 
    % mean_to-origin
    distance_cluster_to_origin = sqrt(x_mean^2 +y_mean^2);
    % min(y) lateral distance
    lateral_distance_y_min = x_corresponding_to_y_min; 
    % min(x) lateral distance 
    lateral_distance_x_min = x_min_corner; 

    
    % get the ID 
    currentId = all_clusters{i}.id; 
   
    % get the index of current cluster
    objectIndex = find([object_properties.id] == currentId, 1); % 1 means to return the first object found
    
    if ~isempty(objectIndex)
        
        % Is objects center distance too close? Is it moving toward sensor? Is the bicycle sationary or moving? 
        if (lateral_distance_y_min < threshold_distance_to_sensor || lateral_distance_x_min < threshold_distance_to_sensor)&& ...
            object_properties(objectIndex).approaching && ...
            ego_velocity_mean(all_clusters{i}.numScan) > threshold_ego_velocity  % ~ > 2 km/h  
                % mark as dangerous 
                danger.scannumber = all_clusters{i}.numScan; 
                danger.clusterId = currentId;
                danger.x = all_clusters{i}.x;
                danger.y = all_clusters{i}.y; 
                danger.meanToOrigin = distance_cluster_to_origin;
                danger.egoVelocity = ego_velocity_mean(i); 
                all_dangerous_clusters_side{j}= danger; 
                j = j+1; 
        end 
        danger.scannumber = [];
        danger.clusterId = [];
        danger.x = [];
        danger.y = []; 
        danger.meanToOrigin = [];
        danger.egoVelocity = [];

    end
end
end