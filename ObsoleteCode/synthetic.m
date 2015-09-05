% SYNTHETIC MEASUREMENTS
Accelerometer = [9.81*ones(10000, 1), 0.1*rand(10000, 2)];
Gyroscope = [0.001*rand(10000, 3)];
Magnetometer = [0.001*rand(10000, 3)];
time = 0.001:0.001:100;
time = time(1:10000)';


