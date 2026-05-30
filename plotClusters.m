function plotClusters(x_all, y_all, x_critical, y_critical, objects)

numScans = size(x_all,1);

colors = lines(50);

for n = 1:numScans

    x_scan = x_all(n,:);
    y_scan = y_all(n,:);

    x_red = x_critical(n,:);
    y_red = y_critical(n,:);

    clf;

    % kompletter Scan
    scatter(x_scan, y_scan, 8, 'b', 'filled');
    hold on;
    grid on;
    grid minor;

    % kritischer Bereich
    scatter(x_red, y_red, 12, 'r', 'filled');

    % Cluster dieses Scans
    for k = 1:length(objects)

        if objects{k}.numScan == n

            colorIndex = mod(objects{k}.id-1,size(colors,1))+1;

            scatter(objects{k}.x,...
                    objects{k}.y,...
                    20,...
                    colors(colorIndex,:),...
                    'filled');

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