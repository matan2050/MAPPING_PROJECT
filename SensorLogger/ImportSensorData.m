function [ data ] = ImportSensorData( sensorCsvFile )

% Check if file exists
if ~exist(sensorCsvFile, 'file')
  error('Missing file');
end


data = [];
dlm = ',';
accelerometer = zeros(1,3);
magnetometer = zeros(1,3);
gyroscope = zeros(1,3);


% Open the csv file
fid = fopen(sensorCsvFile);


% Read the first line, and disregard it
tline = fgetl(fid);
tline = fgetl(fid);

while ischar(tline)
  dlmIndices = strfind(tline, dlm);
  
  
  % Parsing accelerometer data (indices 1-3)
  accelerometer(1) = str2double(tline(1:(dlmIndices(1)-1)));
  accelerometer(2) = str2double(tline(dlmIndices(1)+1:dlmIndices(2)-1));
  accelerometer(3) = str2double(tline(dlmIndices(2)+1:dlmIndices(3)-1));
  
  
  % Parsing gyroscope data (indices 9-12)
  gyroscope(1) = str2double(tline(dlmIndices(9)+1:dlmIndices(10)-1));
  gyroscope(2) = str2double(tline(dlmIndices(10)+1:dlmIndices(11)-1));
  gyroscope(3) = str2double(tline(dlmIndices(11)+1:dlmIndices(12)-1));
  
  
  % Parsing magnetometer data (indices 13-16)
  magnetometer(1) = str2double(tline(dlmIndices(13)+1:dlmIndices(14)-1));
  magnetometer(2) = str2double(tline(dlmIndices(14)+1:dlmIndices(15)-1));
  magnetometer(3) = str2double(tline(dlmIndices(15)+1:dlmIndices(16)-1));
  
  
  % Parsing time data
  time = str2double(tline(dlmIndices(29)+1:dlmIndices(30)-1));
  time = time / 1000;
  
  % Adding parsed data to the output matrix
  data = [data;...
    time,...
    accelerometer(1), accelerometer(2), accelerometer(3),...
    gyroscope(1), gyroscope(2), gyroscope(3),...
    magnetometer(1), magnetometer(2), magnetometer(3)];
  
  
  % Reading the next line
  tline = fgetl(fid);
end


% Finally closing the csv file
fclose(fid);

end