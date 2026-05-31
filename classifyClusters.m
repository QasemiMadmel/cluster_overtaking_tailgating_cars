function objects = classifyClusters(clusters)

ids = unique(cellfun(@(x) x.id, clusters));

for n = 1:length(ids)

    currentId = ids(n);

    count = 0;
    sumLength = 0;

    direction = [];
    j = 1;

    % calculate mean cluster size
    for k = 1:length(clusters)

        if clusters{k}.id == currentId
            sumLength = sumLength + clusters{k}.length;
            count = count + 1;
        end

    end

    mean_length_cluster = sumLength / count;

    % determine direction
    for k = 1:length(clusters)-2

        if clusters{k}.id == currentId && ...
           clusters{k+2}.id == currentId

            deltaY = clusters{k+2}.meanValue.centerY - ...
                     clusters{k}.meanValue.centerY;

            if deltaY < 0
                direction(j) = 1;
            else
                direction(j) = 0;
            end

            j = j + 1;
        end

    end

    % majority vote for direction
    sumDir = sum(direction);

    if sumDir > length(direction)/4
        objects(n).approaching = true;
    else
        objects(n).approaching = false;
    end

    % store id
    objects(n).id = currentId;

    % store mean cluster size
    objects(n).mean = mean_length_cluster;

    % classify object
    if mean_length_cluster <= 10
        objects(n).class = "bicycle";

    else
        objects(n).class = "car";
    end

end

end