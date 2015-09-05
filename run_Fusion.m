load('MatanData4.mat');

% Plotting IMU data
figImu = PlotValuesIMU(Accelerometer, Gyroscope, Magnetometer, time);

[m,n] = size(time);

Orientation = OrientationFusion(0.1, 0.15);
quaternions = zeros(m,4);
Rs = cell(m,1);
eulerAngles = zeros(m,3);


for i = 1:m
  accel = Accelerometer(i,:);
  gyro = Gyroscope(i,:);
  magnet = Magnetometer(i,:);
  
  Orientation.Process(accel, gyro, magnet);
  currQuat = Orientation.GetCurrentQuaternion();
  quaternions(i,:) = currQuat.base;
  Rs{i} = currQuat.QuaternionToRotationMatrix();
  eulerAngles(i,:) = currQuat.QuaternionToEuler() * (180/pi);
end

figEuler = PlotValuesEuler(eulerAngles, time);


% Updating creating camera model for each timeframe
% model = CameraModel(1000, 1000, 500, 500, 0, 0, 0, 0, 0, 0, [1000 1000]);
% 
% for i = 1:size(eulerAngles, 1)
%   currEuler = eulerAngles(i,:);
%   currOmega = currEuler(1);
%   currPhi = currEuler(2);
%   currKappa = currEuler(3);
%   model = model.UpdateByRotation(currOmega, currPhi, currKappa);
% end