function all_dangerous_clusters_side = detectDangerousObjectSide(all_clusters, object_properties, ego_velocity_mean)

all_dangerous_clusters_side = [];

% danger = [scannumber, cluster id, mean_to_origin]
danger.scannumber = [];
danger.x = [];
danger.y = [];
danger.clusterId = [];
danger.meanToOrigin = [];
danger.egoVelocity = [];
threshold_distance_to_sensor = 2; 
threshold_ego_velocity = 0.6; % ~ 2 km/h
j = 1; 

% go over all clusters
for i = 1:length(all_clusters)-1
    
    % get their center
    x_mean = all_clusters{i}.meanValue.centerX;
    y_mean = all_clusters{i}.meanValue.centerY;

    % calculate thier distance 
    distance_cluster_to_origin = sqrt(x_mean^2 +y_mean^2);
    currentId = all_clusters{i}.id; 
   
    % get the index of current cluster
    objectIndex = find([object_properties.id] == currentId, 1); % 1 means to return the first object found
    
    if ~isempty(objectIndex)
        
        % Is objects center distance too close? Is it moving toward sensor? Is the bicycle sationary or moving? 
        if distance_cluster_to_origin < threshold_distance_to_sensor && ...
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