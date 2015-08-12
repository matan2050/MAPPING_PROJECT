classdef OrientationFusion < handle
  
  
  % -----------------------
  % OrientationFusion class
  % -----------------------
  %
  % Performs fusion of Accelerometer, Gyroscope and Magnetometer readings
  % into 3-Euler angles and rotation matrix (R)
  %
  % Based on "An Efficient orientation filter for inertial and
  % inertial/magnetic sensor arrays", Sebastian O.H. Madgwick, April 2010
  
  
  properties (Access = private)
    SampleTime = [];                % Gap between measurements
    CurrentQuaternion = [];         % Current pose quaternion
    FilterGain = [];                % Gyroscope bias gain
  end
  
  
  methods
    
    % -----------------
    % OrientationFusion
    % -----------------
    %
    % Constructor, initializes a new instance according to time constant
    % and gain
    function [ obj ] = OrientationFusion( time, gain )
      obj.SampleTime = time;
      obj.FilterGain = gain;
      obj.CurrentQuaternion = Quaternion([1 0 0 0]);
    end
    
    
    
    % -------
    % Process
    % -------
    %
    % Process performs the fusion for one reading of (3 axis) accelerometer,
    % gyroscope magnetometer and timestamp. Output is the updated
    % quaternion
    function [ obj ] = Process( obj, accel, gyro, magnet )
      
      currQuat = obj.GetCurrentQuaternion();
      
      
      % Normalizing accelerometer reading, algorithm is not scale-dependent
      if norm(accel) == 0
        error('Accelerometer reading error');
      else
        accel = accel/norm(accel);
      end
      
      
      % Normalizing magnetometer reading, algorithm is not scale-dependent
      if norm(magnet) == 0
        error('Magnetometer reading error');
      else
        magnet = magnet/norm(magnet);
      end
      
      
      % Calculating magnetic direction and rotating device quaternion
      % accordingly
      magneticFieldQuaternion = Quaternion([0, magnet(1:3)]);
      currQuatCojugate = Quaternion(currQuat.conjugate);
      magneticDirection = magneticFieldQuaternion.QuaternionProduct(currQuatCojugate);
      h = currQuat.QuaternionProduct(magneticDirection);
    
      
      % Compensating for magnetic distotion
      b = [0, sqrt(h.base(2)^2 + h.base(3)^2), 0, h.base(4)]; 
      
      
      % F vector (for Gradient Descent)
      Fg(1) = (2*(currQuat.base(2)*currQuat.base(4) - currQuat.base(1)*currQuat.base(3)) - accel(1)); 
      Fg(2) = (2*(currQuat.base(1)*currQuat.base(2) + currQuat.base(3)*currQuat.base(4)) - accel(2));
      Fg(3) = (2*(1/2 - currQuat.base(2)^2 - currQuat.base(3)^2) - accel(3));
      
      Fb(1) = (2*b(2)*(1/2 - currQuat.base(3)^2 - currQuat.base(4)^2)                         + 2*b(4)*(currQuat.base(2)*currQuat.base(4) - currQuat.base(1)*currQuat.base(3))  - magnet(1));
      Fb(2) = (2*b(2)*(currQuat.base(2)*currQuat.base(3) - currQuat.base(1)*currQuat.base(4)) + 2*b(4)*(currQuat.base(1)*currQuat.base(2) + currQuat.base(3)*currQuat.base(4))  - magnet(2));
      Fb(3) = (2*b(2)*(currQuat.base(1)*currQuat.base(3) + currQuat.base(2)*currQuat.base(4)) + 2*b(4)*(1/2 - currQuat.base(2)^2 - currQuat.base(3)^2)                          - magnet(3));
    
      F = [Fg, Fb]';
      
    
      % Jacobian matrix (for Gradient Descent)
      Jg(1,:) = 2*[-currQuat.base(3),	currQuat.base(4),  -currQuat.base(1),   currQuat.base(2)];
      Jg(2,:) = 2*[currQuat.base(2),	currQuat.base(1),  currQuat.base(4),    currQuat.base(3)];
      Jg(3,:) = 4*[0,                 -currQuat.base(2), -currQuat.base(3),   0];
    
      Jb(1,:) = 2*[-b(4)*currQuat.base(3),                          b(4)*currQuat.base(4),                            -2*b(2)*currQuat.base(3) - b(4)*currQuat.base(1),   -2*b(2)*currQuat.base(4) + b(4)*currQuat.base(2)];
      Jb(2,:) = 2*[-b(2)*currQuat.base(4) + b(4)*currQuat.base(2),  b(2)*currQuat.base(3) + b(4)*currQuat.base(1),    b(2)*currQuat.base(2) + b(4)*currQuat.base(4),      -b(2)*currQuat.base(1) + b(4)*currQuat.base(3)];
      Jb(3,:) = 2*[b(2)*currQuat.base(3),                           b(2)*currQuat.base(4) - 2*b(4)*currQuat.base(2),  b(2)*currQuat.base(1) - 2*b(4)*currQuat.base(3),    b(2)*currQuat.base(2)];

      J = [Jg; Jb]';
      
      
      % Calculating gradient descent step
      x = J*F;
      x = x/norm(x);
      
      
      % Calculating correction to gyroscope reading according to x
      gyroQuaternion = Quaternion([0 gyro(1) gyro(2) gyro(3)]);
      gyroCorrection = obj.FilterGain * x;
      currQuatCorrectRotation = currQuat.QuaternionProduct(gyroQuaternion);
      currQuatCorrection = (1/2) * currQuatCorrectRotation.base - gyroCorrection';
      
      
      % Corrected quaternion
      newCurrQuat = currQuat.base + currQuatCorrection * obj.SampleTime;
      newCurrQuatNorm = Quaternion(newCurrQuat/norm(newCurrQuat));
      
      
      % Normalizing pose quaternion
      obj.CurrentQuaternion = newCurrQuatNorm;
    end
    
    
    
    % --------------------
    % GetCurrentQuaternion
    % --------------------
    %
    % Get function for the current quaternion field in the class.
    % represents the current orientation during the fusion
    function [ quat ] = GetCurrentQuaternion( obj )
      quat = obj.CurrentQuaternion;
    end
  end
  
end

