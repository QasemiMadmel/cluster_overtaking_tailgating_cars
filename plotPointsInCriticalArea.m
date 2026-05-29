function plotPointsInCriticalArea(x_all, y_all, x, y)

numScans = size(x_all,1); % number of rows corresponds to number of scans

for n = 1:numScans
    x_scan = x_all(n,:); 
    y_scan = y_all(n,:); 

    x_critical = x(n,:); 
    y_critical = y(n,:); 

    clf; % clear the plot first 

    scatter(x_scan, y_scan, 8, 'b', 'filled');
    grid on; 
    grid minor; 
    hold on; 

    % Plot the critical point
    scatter(x_critical, y_critical, 12, 'r', 'filled');

    axis equal;

    title('scan ', num2str(n))
    xlim([-5 5]);
    ylim([-5 5]);

    pause(0.01);

end
    
end