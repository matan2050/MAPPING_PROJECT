function [ figureHandle ] = PlotValuesIMU( accel, gyro, magnet, time )

% Init 
figureHandle = figure;


% Accelerometer
axis(1) = subplot(3,1,1);
hold on;
plot(time, accel(:,1), 'r');
plot(time, accel(:,2), 'g');
plot(time, accel(:,3), 'b');
legend('x', 'y', 'z');
xlabel('time [sec]');
ylabel('Acceleration [g]');
title('Accelerometer Readings');
hold off;


% Gyroscope
axis(2) = subplot(3,1,2);
hold on;
plot(time, gyro(:,1), 'r');
plot(time, gyro(:,2), 'g');
plot(time, gyro(:,3), 'b');
legend('x', 'y', 'z');
xlabel('time [sec]');
ylabel('angular velocity [rad/sec]');
title('Gyroscope Readings');
hold off;


% Magnetometer
axis(3) = subplot(3,1,3);
hold on;
plot(time, magnet(:,1), 'r');
plot(time, magnet(:,2), 'g');
plot(time, magnet(:,3), 'b');
legend('x', 'y', 'z');
xlabel('time [sec]');
ylabel('magnetic field [gauss]');
title('Magnetometer Readings');
hold off;

end