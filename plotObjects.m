function plotObjects(x_all, y_all, clusters, objects)

numScans = size(x_all,1);
colors = lines(50);

for n = 1:numScans

    x_scan = x_all(n,:);
    y_scan = y_all(n,:);

    clf;

    scatter(x_scan, y_scan, 8, 'b', 'filled');
    hold on;
    grid on;
    grid minor;

    for k = 1:length(clusters)

        if clusters{k}.numScan == n

            colorIndex = mod(clusters{k}.id-1,size(colors,1))+1;

            scatter(clusters{k}.x, ...
                    clusters{k}.y, ...
                    20, ...
                    colors(colorIndex,:), ...
                    'filled');

            centerX = clusters{k}.meanValue.centerX;
            centerY = clusters{k}.meanValue.centerY;

            % find Objekt matching the Cluster-ID 
            objectIndex = find([objects.id] == clusters{k}.id, 1);

            if ~isempty(objectIndex)

                if objects(objectIndex).approaching
                    % arrow pointing toward sensor
                    quiver(centerX, centerY, ...
                           0, -0.3, ...
                           0, ...
                           'Color','r', ...
                           'LineWidth',2, ...
                           'MaxHeadSize',4);
                else
                    % arrow pointing away from sensor
                    quiver(centerX, centerY, ...
                           0, 0.3, ...
                           0, ...
                           'Color','g', ...
                           'LineWidth',2, ...
                           'MaxHeadSize',4);
                end

                % optional: ID + Klasse anzeigen
                text(centerX + 0.1, centerY, ...
                     sprintf('ID %d %s', clusters{k}.id, objects(objectIndex).class), ...
                     'Color','w', ...
                     'FontSize',8);

            end
        end
    end

    axis equal;
    title(['Scan ' num2str(n)]);

    xlim([-5 5]);
    ylim([-5 5]);

    drawnow;
    pause(0.01);

end

end