function plotPointsWithDangerousVelocity(x, y, danger)

numScans = size(x,1);

for i = 1:numScans

    x_scan = x(i,:);
    y_scan = y(i,:);

    figure(1); clf

    % normal points
    scatter(x_scan, y_scan, 8, 'b', 'filled')
    hold on
    grid on
    grid minor

    % check if current scan contains dangerous points
    if ismember(i, danger(:,1))

        % rows that belong to current scan
        idx = danger(:,1) == i;

        % dangerous point index
        p = danger(idx,2);

        % color neighbour points too
        idx_red = max(1,p-4):min(length(x_scan),p+4);

        % dangerous points in red
        scatter(x_scan(idx_red), ...
                y_scan(idx_red), ...
                20, 'r', 'filled')

    end

    axis equal
    xlim([-5 5])
    ylim([-5 5])

    title(['Scan ', num2str(i)])

    pause(0.05)

end

end