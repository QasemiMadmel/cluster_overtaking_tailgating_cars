function mergedSegments = mergeSegmentsToClustersPerScan(segments)

threshold_x = 0.5;
threshold_merge = 0.7; 
min_cluster_size = 10; 

mergedSegments = {};
used = false(1, length(segments)); % make a mask array to keep track of handled segments in a single scan 
j = 1;

% go over all segments
for i = 1:length(segments)

    if used(i)
        continue;
    end

    current = segments{i};
    used(i) = true;
    
    % compare each segment to all other segments within scan except the
    % segment itself
    
    for k = i+1:length(segments)

        if used(k)
            continue;
        end

        % merge only if the segments are in the same frame
        if segments{k}.numScan ~= current.numScan 
            continue;
        end

        % merge if the distances between mean values of the segments are
        % below threshold or delta x is small -> same cluster!
        deltaX = abs(segments{k}.meanValue.centerX - current.meanValue.centerX);
        deltaY = abs(segments{k}.meanValue.centerY - current.meanValue.centerY);
        distance_mean = sqrt(deltaX^2 + deltaY^2);

        if distance_mean < threshold_merge || deltaX < threshold_x

            % append the x and y arrays for same clusters
            current.x = [current.x, segments{k}.x];
            current.y = [current.y, segments{k}.y];

            % calculate a new mean nd length
            current.meanValue.centerX = mean(current.x);
            current.meanValue.centerY = mean(current.y);
            current.length = length(current.x);

            used(k) = true;
        end
    end

    % store as merged only if the size is greater than 3
    if current.length >= min_cluster_size
        mergedSegments{j} = current;
        j = j + 1;
    end
end

end