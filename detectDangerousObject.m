function [danger] = detectDangerousObject(v_med, median_indicies, rssi, r, median_filtered)

% danger:  
% col 1: scan number
% col 2: point index within scan

scanNumber = length(median_indicies)
threshold_velocity = median_filtered; % the value for ego velocity
threshold_rssi = 0;
threshold_distance_max = 3;
threshold_distance_min = 0.5;
danger= []; 

for n = 1:scanNumber
    if v_med(n) > threshold_velocity(n)
        if rssi(n,median_indicies(n,1)) >= threshold_rssi
            if (r(n,median_indicies(n,1)) < threshold_distance_max) && (r(n,median_indicies(n,1)) > threshold_distance_min)
                danger(end+1,1) = n; %scan number
                danger(end,2) = median_indicies(n,1); 
            end
        end
    end
end

if isempty(danger) 
    danger = [0, 0]; 
end

end