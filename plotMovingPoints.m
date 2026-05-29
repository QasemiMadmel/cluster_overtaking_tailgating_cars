function plotMovingPoints(data)

mask = ~isnan(data); 
sum_of_data_points = sum(mask,2); 

figure;
plot(sum_of_data_points, 'LineWidth', 1.5);
ylabel('Number of moving points');
xlabel('Scan index');
title('Number of points with a velocity within scans');
grid on;
end