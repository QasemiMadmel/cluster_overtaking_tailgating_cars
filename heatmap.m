function heatmap(data)
    
    % heatmap for plotting velocities
    figure;
    imagesc(data*3.6); % [km/h]
    
    axis xy
    xlabel('Point Index');
    ylabel('Scan Index');
    title('Velocity Heatmap');
    
    cb = colorbar;
    ylabel(cb, 'Velocity [km/h]');
    
    colormap turbo;
    caxis([0 30]);

end