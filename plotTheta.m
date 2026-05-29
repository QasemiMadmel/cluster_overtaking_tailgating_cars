function plotTheta(x, y, vx, vy)

if (size(x,2)==1)
    step     = 421;
    numScans = floor(length(x) / step);
    for i = 1:numScans
    
        idx = (i-1)*step+1 : i*step;
    
        x_scan  = x(idx);
        y_scan  = y(idx);
        vx_scan = vx(idx);
        vy_scan = vy(idx);
    
        % angle of direction
        theta_v   = atan2(vy_scan, vx_scan);
        theta_deg = mod(rad2deg(theta_v), 360);
    
        % Plot
        figure(1); clf
        scatter(x_scan, y_scan, 8, theta_deg, 'filled')
        colorbar
        caxis([0 360])
        hold on
    
        % here paint th e points with the velocity pattern of car in red! 
        % 
        % idx_red = (theta_deg >= 250) & (theta_deg <= 290);
        % scatter(x_scan(idx_red), y_scan(idx_red), 15, 'r', 'filled')
    
        axis equal
        xlim([-15 15])
        ylim([-15 15])
        title(['Scan ', num2str(i)])
    
        pause(0.01)
    end
else
    numScans = size(x,1);
    for i = 1:numScans
    
        x_scan  = x(i,:);
        y_scan  = y(i,:);
        vx_scan = vx(i,:);
        vy_scan = vy(i,:);
    
        % angle of direction
        theta_v   = atan2(vy_scan, vx_scan);
        theta_deg = mod(rad2deg(theta_v), 360);
    
        % Plot
        figure(1); clf
        scatter(x_scan, y_scan, 8, theta_deg, 'filled')
        colorbar
        caxis([0 360])
        hold on
    
      
        % here paint th e points with the velocity pattern of car in red! 
        % 
        % idx_red = (theta_deg >= 250) & (theta_deg <= 290);
        % scatter(x_scan(idx_red), y_scan(idx_red), 15, 'r', 'filled')
    
        axis equal
        xlim([-20 20])
        ylim([-20 20])
        title(['Scan ', num2str(i)])
    
        pause(0.01)
    end
end
