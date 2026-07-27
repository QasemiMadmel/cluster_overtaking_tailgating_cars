function plotObjects(x_all, y_all, clusters, objects, dangerousObject) % dangerousObject_back

numScans = size(x_all,1);

colors = lines(50); % (50 x 3 cols -> red, green, blue) returns 50 colors 

% remove color red from all possible colors for normal clusters 
colors(all(colors(:,1) > 0.8 & colors(:,2) < 0.3,2),:) = []; % 2 is from left to right in each row, 1 would be an up-down verification  

for n = 1:numScans

    x_scan = x_all(n,:);
    y_scan = y_all(n,:);

    clf; % clear figure 

    scatter(x_scan, y_scan, 8, 'blue', 'filled'); % scatter plots points (8 is marker size, )
    hold on;

    grid on;
    grid minor;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot normal clusters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for k = 1:length(clusters)

        if clusters{k}.numScan == n

            clusterId = clusters{k}.id;

            % cyclic repeatition of colors of the id increase above the amount of colors available
            colorIndex = mod(clusterId - 1, size(colors,1)) + 1; 

            % paint over the scatter of all coordinates
            scatter( ...
                clusters{k}.x, ...
                clusters{k}.y, ...
                20, ...
                colors(colorIndex,:), ...
                'filled');

            centerX = clusters{k}.meanValue.centerX;
            centerY = clusters{k}.meanValue.centerY;

            objectIndex = find([objects.id] == clusterId,1); % 1 means to return the first valid value

            if ~isempty(objectIndex)

                if objects(objectIndex).approaching % moves toward sensor 
                    % quiver paints the direction arrow (x,y,u,v,scale,
                    % ...) coordinates, u: length of arrow in x direction,
                    % v : length of arrow in y direction which is negative
                    % here. scale: 0 means do not scale. the length stays 0.3 
                    
                    quiver( ...
                        centerX, ...
                        centerY, ...
                        0, ...
                        -0.5, ...
                        0, ...
                        'Color','r', ...
                        'LineWidth',2, ...
                        'MaxHeadSize',5);

                else % moves away from sensor 

                    quiver( ...
                        centerX, ...
                        centerY, ...
                        0, ...
                        0.5, ...
                        0, ...
                        'Color','g', ...
                        'LineWidth',2, ...
                        'MaxHeadSize',5);

                end
            end

            text( ...
                centerX + 0.1, ...
                centerY, ...
                sprintf('ID %d', clusterId), ...
                'Color','w', ...
                'FontSize',8);

        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % paint danger in red
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for d = 1:length(dangerousObject)
    
            if dangerousObject{d}.scannumber == n
    
                scatter( ...
                    dangerousObject{d}.x, ...
                    dangerousObject{d}.y, ...
                    25, ...
                    colors(colorIndex,:), ...
                    'filled');
    
                text( ...
                    mean(dangerousObject{d}.x)+1, ...
                    mean(dangerousObject{d}.y)-1, ...
                    sprintf('danger ID %d', ...
                    dangerousObject{d}.clusterId), ...
                    'Color','r', ...
                    'FontWeight','bold', ...
                    'FontSize',10);
            end
        end
   

    axis equal;

    title(['Scan ' num2str(n)]);

    xlim([-8 8]);
    ylim([-8 8]);
    
    % draw and pause for animation effect
    drawnow;  
    pause(0.01);

end

end