csvFilePath = 'C:\Users\matan\Dropbox\MAPPING_PROJECT\Data\Sensor_record_20150810_082745_AndroSensor.csv';
sensorData = ImportSensorData(csvFilePath);
[time, accelerometer, gyro, magnetometer] = DivideDataBySensor(sensorData);