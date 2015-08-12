function [ figureHandles ] = PlotValuesIMU( accel, gyro, magnet, time )

% Init 
figureHandles = [];


% Accelerometer
figureHandles.accel = figure;
hold on;
plot(time, accel(:,1), 'r');
plot(time, accel(:,2), 'g');
plot(time, accel(:,3), 'b');
legend('x', 'y', 'z');
xlabel('time [sec]');
ylabel('Acceleration [g]');
title('3-Axis Accelerometer');
hold off;


% Gyroscope
figureHandles.gyro = figure;
hold on;
plot(time, gyro(:,1), 'r');
plot(time, gyro(:,2), 'g');
plot(time, gyro(:,3), 'b');
legend('x', 'y', 'z');
xlabel('time [sec]');
ylabel('Ang. Velocity [rad/sec]');
title('3-Axis Gyroscope');
hold off;


% Magnetometer
figureHandles.magnet = figure;
hold on;
plot(time, magnet(:,1), 'r');
plot(time, magnet(:,2), 'g');
plot(time, magnet(:,3), 'b');
legend('x', 'y', 'z');
xlabel('time [sec]');
ylabel('Mag. Field [gauss]');
title('3-Axis  Magnetometer');
hold off;

end