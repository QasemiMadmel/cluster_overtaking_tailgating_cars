function plotHeatmap(rssi)

imagesc(rssi);

axis xy
xlabel('Point Index');
ylabel('Scan Index');
title('RSSI Heatmap');
colormap turbo;
cb = colorbar;
ylabel(cb,'RSSI');
caxis([0 255]);

end