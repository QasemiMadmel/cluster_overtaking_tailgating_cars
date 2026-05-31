function [v_mean, v_median, point_index_median] = ...
    computeMeanMedianVelocity(v, r, numberOfPointsPerScan)
 

    numberOfScans = size(v,1); % number of rows
    middle_of_scan = floor(numberOfPointsPerScan/2);  
    start = 1; 
    end_of_scan = numberOfPointsPerScan;

    % v_mean and v_median:
    % 1: mean value for right area, 
    % 2: mean values for left area of scan, 
    % 3: mean values for the whole scan 
    % each row (n) is one scan 

    for n = 1:numberOfScans
        v_scan = v(n,:); 
        r_scan = r(n,:);
        
        % right area 

        r_temp = r_scan(start:middle_of_scan);
        v_temp = v_scan(start:middle_of_scan); 
        v_mean(n,1) = mean(v_temp, 'omitnan')*3.6;
        
        % look for the median in the right area of scan 
        v_med(n,1) = median(v_temp, 'omitnan');
        [~, idx_med] = min(abs(v_temp - v_med(n,1))); % find the index of the median value
        v_median(n,1) = v_med(n,1)*3.6; % in [km/h]
        r_at_median(n,1) = r_temp(idx_med); % find the corresponding distance
        point_index_median(n,1) = idx_med; % store the median index for later to find car_overtaking_events

        % whole scan 
        v_mean(n,2) = mean(v_scan, 'omitnan')*3.6;
        v_median(n,2) = (median(v_scan, 'omitnan'))*3.6;

    end

    % plot v_mean and v_median
    figure;
    plot(v_mean(:,1)); hold on; 
    plot(v_mean(:,2)); 
    legend('right area', 'whole scan');
    title('mean values per scan');
    xlabel('number of scans')
    ylabel('velocity mean [km/h]')
    
    
    figure; 
    plot(v_median(:,1)); hold on; 
    plot(v_median(:,2)); 
    legend('right area', 'whole scan');
    title('median values per scan');
    xlabel('number of scans')
    ylabel('velocity median [km/h]')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 
    % v_right = v_median(:,1);
    % r_right = r_at_median(:,1);
    % 
    % threshold = 5; % arbitary value of 20 km/H -> can be adapted later
    % 
    % idx_event = v_right > threshold;
    % 
    % figure;
    % 
    % plot(v_right, 'LineWidth',1.5);
    % hold on;
    % grid on;
    % 
    % % display threshold 
    % yline(threshold, '--r', 'threshold');
    % 
    % % mark peaks
    % plot(find(idx_event), v_right(idx_event), ...
    %     'ro', 'MarkerSize',7, 'LineWidth',1.5);
    % 
    % % write down the distances
    % for k = find(idx_event)'
    % 
    %     text(k, ...
    %          v_right(k)+1, ...
    %          sprintf('%.2f m', r_right(k)), ...
    %          'FontSize',10, ...
    %          'Color','red'); 
    % end
    % 
    % xlabel('scan number');
    % ylabel('velocity mean [km/h]');
    % title('Velocity peaks and their corresponding distances');
    % legend('velocity', 'threshold', 'events');

end