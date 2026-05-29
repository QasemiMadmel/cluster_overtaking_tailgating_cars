function [x_out, y_out, vx_out, vy_out, t_out, r_out] = computeVelocity(x_all, y_all, t_xy, scanPoints)

% ===== parameter ===== %
r_min = 0.6; % 30 cm cutoff

% ===== number of Scans ===== %
numScans = floor(length(x_all) / scanPoints);

% ===== for storage ===== %
x_out = [];
y_out = [];
vx_out = [];
vy_out = [];
t_out = [];
r_out = [];

% ===== loop ===== %
for i = 2:numScans
    
    % indicies of current and previous scans
    idx_curr = (i-1)*scanPoints + (1:scanPoints);
    idx_prev = (i-2)*scanPoints + (1:scanPoints);
    
    x_curr = x_all(idx_curr);
    y_curr = y_all(idx_curr);
    
    x_prev = x_all(idx_prev);
    y_prev = y_all(idx_prev);
    
    t_curr = t_xy(idx_curr);
    t_prev = t_xy(idx_prev);
    
    % ===== delta t ===== %
    dt = mean(t_curr - t_prev);
    
    if dt <= 0
        continue
    end
    
    % ===== velocity ===== %
    vx = (x_curr - x_prev) / dt;
    vy = (y_curr - y_prev) / dt;
    
    % ===== distance vector ===== %
    r = sqrt(x_curr.^2 + y_curr.^2);
    
    % ===== cut off ===== %
    mask_valid = r > r_min;
    
    vx(~mask_valid) = NaN;
    vy(~mask_valid) = NaN;
    
    % ===== store ===== %
    x_out = [x_out; x_curr];
    y_out = [y_out; y_curr];
    vx_out = [vx_out; vx];
    vy_out = [vy_out; vy];
    t_out = [t_out; t_curr];
    r_out = [r_out; r];
end

end