function [t_r_, r_all_, t_xy_, x_all_, y_all_, t_velocity, vx_all, vy_all, v, t_rssi, rssi] = loadData(filepath_xy_scan, filepath_r_scan, filepath_vx_vy, filepath_rssi)

xy_data = readmatrix(filepath_xy_scan);
r_data = readmatrix(filepath_r_scan);
v_data = readmatrix(filepath_vx_vy);
rssi_data = readmatrix(filepath_rssi);

t_r_ = r_data(:,1);
r_all_ = r_data(:,3);

t_xy_ = xy_data(:,1); 
x_all_ = xy_data(:, 2);
y_all_ = xy_data(:, 3);

t_velocity = v_data(:,1);
vx_all= v_data(:,2); 
vy_all = v_data(:,3);  
v = v_data(:,4);

t_rssi = rssi_data(:,1); 
rssi = rssi_data(:,2);

end