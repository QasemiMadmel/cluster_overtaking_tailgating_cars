function [] = plotDirectionalField(x, y, vx, vy)
if(size(x,2)==1)
    scanSize = 421;
    numScans = length(vx)/ scanSize;
    stride   = 10;  % every 10th point has an arrow
    
    figure
    
    for i = 1:numScans
    
        idx = ((i-1)*scanSize+1 : i*scanSize);
        x_scan  = x(idx);
        y_scan  = y(idx);
        vx_scan = vx(idx);
        vy_scan = vy(idx);
    
        clf
    
        % environment
        scatter(x_scan, y_scan, 5, [0.8 0.8 0.8])
        hold on
    
        % arrows (downsampeld)
        sub = 1:stride:length(x_scan);
        quiver(x_scan(sub), y_scan(sub), vx_scan(sub), vy_scan(sub), 0, 'r')
    
        axis equal
        xlim([-20 20])
        ylim([-20 20])
        title(['Scan ', num2str(i)])
    
        pause(0.1)
    end
else
    stride   = 1; 
    figure
    numScans = size(x,1);
    
    for i = 1:numScans
   
        x_scan  = x(i,:);
        y_scan  = y(i,:);
        vx_scan = vx(i,:);
        vy_scan = vy(i,:);
    
        clf
    
        % environment
        scatter(x_scan, y_scan, 5, [0.8 0.8 0.8])
        hold on
    
        % arrows (downsampeld)
        sub = 1:stride:length(x_scan);
        quiver(x_scan(sub), y_scan(sub), vx_scan(sub), vy_scan(sub), 0, 'r')
    
        axis equal
        xlim([-20 20])
        ylim([-20 20])
        title(['Scan ', num2str(i)])
    
        pause(0.1)
    end

end
