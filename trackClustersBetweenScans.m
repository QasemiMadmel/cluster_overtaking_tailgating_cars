function clustersWithId = trackClustersBetweenScans(cluster)

    dt = 1/15; % Time between scans at 15 Hz

    % Allowed distance depending on scan gap
    distanceThresholds = [0.8, 1.0, 1.0];

    numberOfClusters = length(cluster);

    if numberOfClusters == 0
        clustersWithId = cluster;
        return;
    end

    % Marks clusters that have already been assigned as successors
    used = false(1, numberOfClusters);

    nextId = 1;

    % Initialize fields
    for i = 1:numberOfClusters
        cluster{i}.id = [];
        cluster{i}.speed = 0;
    end

    % Go over all clusters
    for i = 1:numberOfClusters

        % If cluster i has no ID yet, it represents a new object
        if isempty(cluster{i}.id)

            cluster{i}.id = nextId;
            cluster{i}.speed = 0;

            nextId = nextId + 1;
        end

        % First search scan +1, then scan +2 and scan +3
        for scanGap = 1:3

            smallestDistance = inf;
            bestIndex = [];
            bestDeltaY = [];

            % Compare cluster i with all later clusters
            for k = i+1:numberOfClusters

                actualScanGap = ...
                    cluster{k}.numScan - cluster{i}.numScan;

                % The candidate belongs to an earlier scan gap
                if actualScanGap < scanGap
                    continue;
                end

                % The candidate is already beyond the investigated scan
                if actualScanGap > scanGap
                    break;
                end

                % Cluster k was already assigned to another predecessor
                if used(k)
                    continue;
                end

                deltaX = ...
                    cluster{k}.meanValue.centerX - ...
                    cluster{i}.meanValue.centerX;

                deltaY = ...
                    cluster{k}.meanValue.centerY - ...
                    cluster{i}.meanValue.centerY;

                distanceBetweenCenters = ...
                    sqrt(deltaX^2 + deltaY^2);

                % Store the closest cluster in the investigated scan
                if distanceBetweenCenters < smallestDistance

                    smallestDistance = distanceBetweenCenters;
                    bestIndex = k;
                    bestDeltaY = deltaY;
                end
            end

            % Assign the closest suitable cluster
            if ~isempty(bestIndex) && ...
               smallestDistance < distanceThresholds(scanGap)

                % Transfer the existing ID
                cluster{bestIndex}.id = cluster{i}.id;

                % Calculate longitudinal cluster speed
                cluster{bestIndex}.speed = ...
                    computeClusterSpeed( ...
                        bestDeltaY, ...
                        dt * scanGap);

                % Prevent another assignment of this successor
                used(bestIndex) = true;

                % A matching cluster was found,
                % so scan +2 or scan +3 does not need to be checked
                break;
            end
        end
    end

    clustersWithId = cluster;

end