classdef DeviceOrientation < handle
    %DEVICEORIENTATION represents the smartphone or tablet with sensor
    %measurements (accelerometer, gyro, magnetometer)
    
    properties (Access = public)
      %% PATHS
      % paths to the original data files
      working_dir         = [];           % input data directory
      acc_file            = [];           % accelerometer input file
      gyro_file           = [];           % gyro input file
      mag_file            = [];           % magnetometer input file
      
      
      %% RAW MEASUREMENTS
      % Raw as outputted from the android API
      acc_original        = [];           % accelerometer
      gyro_original       = [];           % gyroscope
      mag_original        = [];           % magnetometer
      
      
      %% WORKING MEASUREMENTS
      % after equalising number of measurements between all sensors
      acc_measurements  = [];           % accelerometer
      gyro_measurements   = [];           % gyroscope
      mag_measurements    = [];           % magnetometer
      
      %%
%       curr_orientation_   = [];           % current calculated orientation
%       init_orientation_   = [];           % initial orientation (R_0)
%       avail_sensors_      = [0,0,0];      % flag for {accel., gyro., mag.}
    end
    
    
    methods
      %% CONSTRUCTOR
      % INPUT:  {1} INPUT_DIR - THE MEASUREMENT FILES FOLDER
      % OUTPUT: {1} OBJ - THE INITIALISED DEVICE ORIENTATION OBJECT
      function obj = DeviceOrientation( input_dir )
        obj.working_dir       = FixDir(input_dir);
        measurement_files     = dir(obj.working_dir);
        
        % ### FINDING THE RELEVANT DATA FILES IN FOLDER ###
        for i = 1:length(measurement_files)
          
          accel = strfind(measurement_files(i).name, '3-axis_Accelerometer');
          gyro  = strfind(measurement_files(i).name, 'Gyroscope_sensor');
          mag   = strfind(measurement_files(i).name, 'Magnetic_Sensor');
          
          % ### LOAD DATA IF FILES WERE FOUND ###
          if ~isempty(accel)
            obj.acc_file      = [obj.working_dir measurement_files(i).name];
            obj.acc_original  = csvread(obj.acc_file);
            
          elseif ~isempty(gyro)
            obj.gyro_file     = [obj.working_dir measurement_files(i).name];
            obj.gyro_original = csvread(obj.gyro_file);
            
          elseif ~isempty(mag)
            obj.mag_file      = [obj.working_dir measurement_files(i).name];
            obj.mag_original  = csvread(obj.mag_file);
          end % if
        end % for
      end % constructor
      
      
      %% SYNCSENSOROBSERVATIONSSPLINE
      % INPUT:  {1} OBJ - THE DEVICEORIENTATION OBJECT
      % OUTPUT: {1} OBJ - THE DEVICEORIENTATION OBJECT
      function obj = SyncSensorObservationsSpline( obj )
        
        % ### GET ALL TIMESTAMPS FROM EACH SENSOR ###
        time_acc    = obj.acc_original(:,1);
        time_gyro   = obj.gyro_original(:,1);
        time_mag    = obj.mag_original(:,1);
        
        
        % ### GATHER AND SYNC ALL SENSORS TIMESTAMPS ###
        x = [time_acc; time_gyro; time_mag];
        x_sort = unique(x);
        
        
        % ### SPLINE INTERPOLATE NEW MEASUREMENTS FOR ALL TIMESTAMPS ###
        accel_x     = interpn(time_acc, obj.acc_original(:,3), x_sort, 'spline');
        accel_y     = interpn(time_acc, obj.acc_original(:,4), x_sort, 'spline');
        accel_z     = interpn(time_acc, obj.acc_original(:,5), x_sort, 'spline');
        new_accel   = [x_sort, accel_x, accel_y, accel_z];

        gyro_x      = interpn(time_gyro, obj.gyro_original(:,3), x_sort, 'spline');
        gyro_y      = interpn(time_gyro, obj.gyro_original(:,4), x_sort, 'spline');
        gyro_z      = interpn(time_gyro, obj.gyro_original(:,5), x_sort, 'spline');
        new_gyro    = [x_sort, gyro_x*180/pi, gyro_y*180/pi, gyro_z*180/pi];

        mag_x       = interpn(time_mag, obj.mag_original(:,3), x_sort, 'spline');
        mag_y       = interpn(time_mag, obj.mag_original(:,4), x_sort, 'spline');
        mag_z       = interpn(time_mag, obj.mag_original(:,5), x_sort, 'spline');
        new_mag     = [x_sort, mag_x, mag_y, mag_z];
        
        new_time    = x_sort;
        
        
        % ### NORMALISING ACCELEROMETER AND MAGNETOMETER READINGS ###
        for i = 1:length(new_accel)
          norm_acc = norm( new_accel(i,2:4) );
          %norm_mag = norm( new_mag(i,2:4) );
          
          new_accel(i,2:4)  = new_accel(i,2:4) / norm_acc;
          new_mag(i,2:4)    = new_mag(i,2:4) / 100;
        end
        
        
        % ### SAVE NEW MEASUREMENTS INTO OBJECT ###
        obj.acc_measurements    = new_accel;
        obj.gyro_measurements   = new_gyro;
        obj.mag_measurements    = new_mag;
      end % SyncSensorObservationsSpline
      
      
      %% SYNCSENSOROBSERVATIONSCONST
      % INPUT:  {1} OBJ - THE DEVICEORIENTATION OBJECT
      % OUTPUT: {1} OBJ - THE DEVICEORIENTATION OBJECT
      function obj = SyncSensorObservationsConst( obj )
        
        % ### GET ALL TIMESTAMPS FROM EACH SENSOR ###
        time_acc  = obj.acc_original(:,1);
        time_gyro = obj.gyro_original(:,1);
        time_mag  = obj.mag_original(:,1);
        
        
        % ### GATHER AND SYNC ALL SENSORS TIMESTAMPS ###
        x = [time_acc; time_gyro; time_mag];
        x_sort = unique(x);
        updated_sensors = zeros(length(x_sort), 10);
        updated_sensors(:,1) = x_sort;
        
        
        % ### FOR EACH TIMESTAMP GET READING FOR EVERY SENSOR ###
        for i = 1:length(x_sort)
          curr_time = x_sort(i);
          
          time_index_acc  = find(time_acc == curr_time);
          time_index_gyro = find(time_gyro == curr_time);
          time_index_mag  = find(time_mag == curr_time);
          
          if ~isempty(time_index_acc)
            norm_acc = norm(obj.acc_original(time_index_acc, 3:5));
            updated_sensors(i, 2:4) = obj.acc_original(time_index_acc, 3:5) / norm_acc;
          end % if
          
          if ~isempty(time_index_gyro)
            updated_sensors(i, 5:7) = obj.gyro_original(time_index_gyro, 3:5)*180/pi;
          end
          
          if ~isempty(time_index_mag)
            norm_mag = norm(obj.mag_original(time_index_mag, 3:5));
            updated_sensors(i, 8:10) = obj.mag_original(time_index_mag, 3:5) / norm_mag;
          end
        end % for
        
        
        % ### FILLING THE GAPS ###
        empty_acc  = find(updated_sensors(:,2) == 0 & updated_sensors(:,3) == 0 & updated_sensors(:,4) == 0);
        empty_gyro = find(updated_sensors(:,5) == 0 & updated_sensors(:,6) == 0 & updated_sensors(:,7) == 0);
        empty_mag  = find(updated_sensors(:,8) == 0 & updated_sensors(:,9) == 0 & updated_sensors(:,10) == 0);
        
        % ### FORWARD FROM LAST RECORDED MEASUREMENT ###
        for i = 2:length(empty_acc)
          updated_sensors(empty_acc(i), 2:4) = updated_sensors(empty_acc(i) - 1, 2:4);
        end % for
        
        for i = 2:length(empty_gyro)
          updated_sensors(empty_gyro(i), 5:7) = updated_sensors(empty_gyro(i) - 1, 5:7);
        end % for
        
        for i = 2:length(empty_mag)
          updated_sensors(empty_mag(i), 8:10) = updated_sensors(empty_mag(i) - 1, 8:10);
        end % for
        
        
        % ### BACKWARDS FROM THE FIRST RECORDED MEASUREMENT ###
        try
        updated_sensors(empty_acc(1), 2:4)   = updated_sensors(empty_acc(1) + 1, 2:4);
        updated_sensors(empty_gyro(1), 5:7)  = updated_sensors(empty_gyro(1) + 1, 5:7);
        updated_sensors(empty_mag(1), 8:10)  = updated_sensors(empty_mag(1) + 1, 8:10);
        catch
        end
        
        
        % ### SAVE PROCESSED MEASUREMENTS BACK INTO THE OBJECT ###
        obj.acc_measurements  = updated_sensors(:,1:4);
        obj.gyro_measurements = [updated_sensors(:,1), updated_sensors(:,5:7)];
        obj.mag_measurements  = [updated_sensors(:,1), updated_sensors(:,8:10)];
      end % SyncSensorObservationsConst
    end % methods
    
end % class

