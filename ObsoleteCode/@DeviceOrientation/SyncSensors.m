function [ new_time, new_accel, new_gyro, new_mag ] = SyncSensors( obj )
% SYNCACCELGYRO makes the number of measurements by the gyro, accelerometer
% and magnetometer the same by using spline interpolation to fill the gaps.
% we now get new measurement data, with a value for each time frame

%% performing spline interpolation on each reading seperately
time_accel = obj.accel_measurement_(:,1);
time_gyro = obj.gyro_measurement_(:,1);

if obj.avail_sensors_(3) == 1
  time_mag = obj.mag_measurement_(:,1);
  x = [time_accel; time_gyro; time_mag];
else
  x = [time_accel; time_gyro];
end

x_sort = unique(x);

accel_x = interpn(time_accel, obj.accel_measurement_(:,3), x_sort, 'spline');
accel_y = interpn(time_accel, obj.accel_measurement_(:,4), x_sort, 'spline');
accel_z = interpn(time_accel, obj.accel_measurement_(:,5), x_sort, 'spline');

gyro_x  = interpn(time_gyro, obj.gyro_measurement_(:,3), x_sort, 'spline');
gyro_y  = interpn(time_gyro, obj.gyro_measurement_(:,4), x_sort, 'spline');
gyro_z  = interpn(time_gyro, obj.gyro_measurement_(:,5), x_sort, 'spline');

if obj.avail_sensors_(3) == 1
  mag_x = interpn(time_mag, obj.mag_measurement_(:,3), x_sort, 'spline');
  mag_y = interpn(time_mag, obj.mag_measurement_(:,4), x_sort, 'spline');
  mag_z = interpn(time_mag, obj.mag_measurement_(:,5), x_sort, 'spline');
  new_mag = [x_sort, mag_x, mag_y, mag_z];
end
  
%% combining all interpolated readings into a matrix of {time, x, y, z}
new_accel = [x_sort, accel_x, accel_y, accel_z];
new_gyro  = [x_sort, gyro_x, gyro_y, gyro_z];
new_time  = x_sort;

end

