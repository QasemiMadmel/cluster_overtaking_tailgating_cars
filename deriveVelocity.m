function acceleration = deriveVelocity(t, v)

t = t(:);
v = v(:); 
v = v ./ 3.6; 
scanNummer = length(v); 
N = (1:1:scanNummer-1);
N = N .'; 

interval = diff(t); 
acceleration = diff(v) ./interval; 

time(1) = 0; 
for n =  1 : numel(interval)-1
    time(n+1) = time(n)+interval(n);
end


figure; 
plot(N, acceleration); 
grid on; 
xlabel('time/s');
ylabel('acceleration/ m/s^2'); 

end