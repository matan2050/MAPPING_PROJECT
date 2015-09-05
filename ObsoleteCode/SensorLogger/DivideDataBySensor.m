function [ time, accel, gyro, magnet ] = DivideDataBySensor( sensorData )

time = sensorData(:,1);
accel = sensorData(:,2:4);
gyro = sensorData(:,5:7);
magnet = sensorData(:,8:10);

end