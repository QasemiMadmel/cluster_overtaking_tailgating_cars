function [filtered_median, filtered_mean] = alphaFilter(vel_median_vector_right_area, vel_mean_vector_right_area)

    numberOfScans = length(vel_median_vector_right_area);

    median_filtered = zeros(numberOfScans,1);
    mean_filtered   = zeros(numberOfScans,1);

    
    alpha = 0.1; % weight of current median value 
    beta  = 1 - alpha; % weight of the past measured value
    
    % both mean and median velocity are computed
    % later only median is processed futher

    % set the first value 

    if isnan(vel_median_vector_right_area(1))
        median_filtered(1) = 0;
    else
        median_filtered(1) = vel_median_vector_right_area(1);
    end

    if isnan(vel_mean_vector_right_area(1))
        mean_filtered(1) = 0;
    else
        mean_filtered(1) = vel_mean_vector_right_area(1);
    end

    % go over the next scans and filter: 
    % filter value = 0.1 * current_measurment + 0.9 * last_measurement
    
    for n = 2:numberOfScans

        if isnan(vel_median_vector_right_area(n))
            median_filtered(n) = median_filtered(n-1);
        else
            median_filtered(n) = alpha * vel_median_vector_right_area(n) + ...
                                 beta  * median_filtered(n-1);
        end

        if isnan(vel_mean_vector_right_area(n))
            mean_filtered(n) = mean_filtered(n-1);
        else
            mean_filtered(n) = alpha * vel_mean_vector_right_area(n) + ...
                               beta  * mean_filtered(n-1);
        end

    end


    filtered_median = median_filtered; 
    filtered_mean = mean_filtered;

    figure;
    plot(vel_median_vector_right_area);
    hold on;
    plot(median_filtered,'LineWidth',2);
    legend('raw values right side of sensor', 'filtered values');
    title('Median Velocity for right area of scan');


    figure;
    plot(vel_mean_vector_right_area);
    hold on;
    plot(mean_filtered,'LineWidth',2);
    legend('raw values right side of the sensor', 'filtered values');
    title('Mean Velocity for right area of scan');

end