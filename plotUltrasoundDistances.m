function plotUltrasoundDistances(t_ultrasound, distance_ultrasound)

filtered_distances = distance_ultrasound;
MAX = length(filtered_distances);

    for i = 1: MAX
        if filtered_distances(i) > 4 
            filtered_distances(i) = 0;
        end
    end

figure('Color','w','Position',[100 100 1000 500]);

plot(t_ultrasound, filtered_distances, ...
    'LineWidth', 2, ...
    'Color', [0 0.4470 0.7410]);

hold on

scatter(t_ultrasound, filtered_distances, 15, ...
    'filled', ...
    'MarkerFaceColor', [0.8500 0.3250 0.0980], ...
    'MarkerFaceAlpha', 0.6);

grid on
grid minor

xlabel('Zeit [s]','FontSize',12)
ylabel('Distanz [m]','FontSize',12)
title('ultrasund: distance over time','FontSize',14)

set(gca,...
    'FontSize',11,...
    'LineWidth',1.2)

xlim([min(t_ultrasound) max(t_ultrasound)])


meanDist = mean(filtered_distances);

yline(meanDist,'--r', ...
    sprintf('mean value = %.3f m',meanDist), ...
    'LineWidth',1.5);

end