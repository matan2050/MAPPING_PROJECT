classdef CameraModel < handle
  % CAMERAMODEL represents a camera model, using the focal length,
  % calibration matrix (K), orientation (C vector and R matrix) and the
  % projective transformation matrix P
  
  properties (Access = public)
    % Intirinsic Parameters
    Fu                                      % focal length u-axis
    Fv                                      % focal length v-axis
    Cu                                      % optical center u-axis
    Cv                                      % optical center v-axis
    ImageSize                               % image size in pixels
    K                                       % callibration matrix
    
    
    % Extrinsic Parameters
    Omega                                   % rotation about x-axis
    Phi                                     % rotation about y-axis
    Kappa                                   % rotation about z-axis
    X0                                      % position x-axis 
    Y0                                      % position y-axis
    Z0                                      % position z-axis
    R                                       % rotation matrix
    C                                       % position vector
    
    
    % Processed Parameters
    P                                       % projection matrix
  end
  
  methods    
    
    % -----------
    % CameraModel
    % -----------
    %
    % Constructor,
    % takes all intrinsic and extrinsic parameters and initializes the relevant
    % matrices to allow method Point2Pixel
    function obj = CameraModel(obj, fu, fv, cu, cv, omega, phi, kappa, x0, y0, z0, imageSize)
      
      % Updating intrinsic parameters
      obj.Fu = fu;
      obj.Fv = fv;
      obj.ImageSize = imageSize;
      obj.Cu = cu;
      obj.Cv = cv;
      
      
      % Updating extrinsic paramters
      obj.Omega = omega;
      obj.Phi = phi;
      obj.Kappa = kappa;
      obj.X0 = x0;
      obj.Y0 = y0;
      obj.Z0 = z0;
      
      
      % Constructing relevant matrices and updating the camera model
      obj.RebuildModel();
    end
    
    
    
    % --------
    % RebuildK
    % --------
    %
    % Rebuilds K (calibration) matrix according to intrinsic parameters in
    % the model object
    function [ K ] = RebuildK( obj )
      K = zeros(3,3);
      K(1,1) = obj.Fu;
      K(2,2) = obj.Fv;
      K(1,3) = obj.Cu;
      K(2,3) = obj.Cv;
      K(3,3) = 1;
    end
    
    
    
    % --------
    % RebuildR
    % --------
    %
    % Rebuilds R (rotation) matrix according to the extrinsic parameters in
    % the model object
    function [ R ] = RebuildR( obj )
      R = RotationMatrix(obj.Omega, obj.Phi, obj.Kappa);
    end
    
    
    
    % --------
    % RebuildC
    % --------
    %
    % Rebuilds C (position) matrix according to the extrinsic parameters in
    % the model object
    function [ C ] = RebuildC( obj )
      C = [obj.X0; obj.Y0; obj.Z0];
    end
    
    
    
    % --------
    % RebuildP
    % --------
    %
    % Rebuilds P (projection) matrix according to the K, R matrices and C
    % vector
    function [ P ] = RebuildP( obj )
      P = obj.K*obj.R*[eye(3,3), -obj.C];
    end
    
    
    
    % ------------
    % RebuildModel
    % ------------
    %
    % Rebuilds all of the camera matrices according to the intrinsic and
    % extrinsic parameters
    function RebuildModel( obj )
      obj.K = obj.RebuildK();
      obj.R = obj.RebuildR();
      obj.C = obj.RebuildC();
      obj.P = obj.RebuildP();
    end
    
    
    
    % ------------
    % Points2Pixel
    % ------------
    %
    % Projects a points in 3D space [x y z]' to pixel position in model (if
    % within image limits) [i j]'
    function [ pixel ] = Point2Pixel( obj, point )
      
      % Transforming points to homogenous coordinates
      pointHomogenous = [point; 1];
      
      % Projecting to image
      pixelScaled = obj.P*pointHomogenous;
      
      % Scaling back according to third element in pixel
      pixel = pixelScaled / pixelScaled(3);
      
      % Returining only the two ij elements
      pixel = pixel(1:2);
    end
    
    
    
    % ----------------
    % UpdateByRotation
    % ----------------
    %
    % Updates the rotation matrix (R), and orientation angles and rebuilds the
    % relevant matrices
    function [ obj ] = UpdateByRotation( obj, omega, phi, kappa )
      obj.Omega = omega;
      obj.Phi = phi;
      obj.Kappa = kappa;
      
      obj.R = obj.RebuildR();
      obj.P = obj.RebuildP();
    end
    
    
    
    % ----------------
    % UpdateByPosition
    % ----------------
    %
    % Updates the position vector (C) and position values and rebuilds the 
    % relevant matrices 
    function [ obj ] = UpdateByPosition( obj, x0, y0, z0 )
      obj.X0 = x0;
      obj.Y0 = y0;
      obj.Z0 = z0;
      
      obj.C = obj.RebuildC();
      obj.P = obj.RebuildP();
    end
    
    
    
    % -------------------
    % UpdateByCalibration
    % -------------------
    %
    % Updates the calibration matrix and intrinsic parameters and rebuilds
    % the relevant matrices
    function [ obj ] = UpdateByCalibration( obj, fu, fv, cu, cv )
      obj.Fu = fu;
      obj.Fv = fv;
      obj.Cu = cu;
      obj.Cv = cv;
      
      obj.K = obj.RebuildK();
      obj.P = obj.RebuildP();
    end
  end
  
end

