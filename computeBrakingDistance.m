function braking_distance = computeBrakingDistance(velocity, acceleration)
braking_distance = abs(velocity^2 / 2 * acceleration); 
end