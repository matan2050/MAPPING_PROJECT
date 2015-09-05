function [ sensorValStruct ] = GenerateSensorData( keyPoints, timeConstant )
% keyPoints: a matrix of Nx4: {time, omega, phi, kappa}


numPoses = length(keyPoints);

% Sort the struct cell array
sortedKeyPoints = zeros(size(keyPoints));
sortedTimeStamp = sort(keyPoints(:,1));
for i = 1:numPoses
  index = find(keyPoints(:,1) == sortedTimeStamp(i));
  sortedKeyPoints(i,:) = keyPoints(index,:);
end

numSensorValues = (sortedKeyPoints(end,1) - sortedKeyPoints(1,1)) / timeConstant;

% sensorValStruct starts with {timestamp, o_x, o_y, o_z, p_x, p_y, p_z,
% k_x, k_y, k_z}
sensorValStruct = [];

numMeasurements = sortedKeyPoints(end,1) / timeConstant;
allTime = zeros(numMeasurements,1);
allGyro = nan(numMeasurements,3);
allAccelerometer = zeros(numMeasurements,3);
allMagnetometer = zeros(numMeasurements,3);

for i = 1:length(allTime)
  allTime(i) = sortedKeyPoints(1,1) + (i-1)*timeConstant;
end

allTimeGyro = [allTime, allGyro];

for i = 1:length(allTimeGyro)
  isTime = find(allTimeGyro(i,1) == sortedKeyPoints);
  
  if isempty(isTime)
    continue;
  else
    relevantRow = sortedKeyPoints(find(sortedKeyPoints(:,1) == allTimeGyro(i,1)),:);
    allTimeGyro(i,2:4) = relevantRow(2:4);
  end
end

allGyro = allTimeGyro(:,2:4);
allGyroFix = InterpolateNan(allGyro);



end