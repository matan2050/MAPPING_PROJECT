classdef Quaternion < handle

%*************************************************************************/
%                                                                                                                                                                                                                                                                                     
%   Project Name     :  Mapping Project                                                                                                               
%   File Creator     :  Matan Weissbuch
%   Creation Date    :  19.05.2015                                                                                                       
%                                                                                                                                                         
%   Discription      :  Class that represents a quaternion for spatial
%                       orientation purposes.
%
%*************************************************************************/

  
  properties (Access = public)
    base
    conjugate
  end
  
  methods
    
    %% CONSTRUCTOR
    % INPUT:  {1} AXIS - VECTOR OR QUATERNION (FOR COPY CTOR)
    %         {2} ANGLE - ANGLE TO ROTATE AROUND AXIS
    % OUTPUT: {1} OBJ - THE QUATERNION OBJECT
    function [ obj ] = Quaternion(axis, angle)
      
      % ### IF FIRST INPUT IS QUATERNION, THAN COPY CONSTRUCTOR ###
      m = size(axis);
      
      if max(m) > 3
        obj.base = axis;
        obj.conjugate = [axis(1), -axis(2), -axis(3), -axis(4)];
        
      else
        
        % ### NORMALIZING AXIS ###
        axis_norm = norm(axis);
        axis = axis/axis_norm;
        

        % ### THE ACTUAL QUATERNION ###
        obj.base = [cos(angle/2),...
                    axis(1)*sin(angle/2),...
                    axis(2)*sin(angle/2),...
                    axis(3)*sin(angle/2)];

        % ### THE QUATERNION CONJUGATE ###
        obj.conjugate = -obj.base;
        obj.conjugate(1) = -obj.conjugate(1);
      end
    end
    
    
    %% ROTATE
    % INPUT:  {1} OBJ - THE QUATERNION OBJECT
    %         {2} VECTOR - THE VECTOR TO ROTATE USING THE QUATERNION
    % OUTPUT: {1} ROTATED_VECTOR - THE VECTOR AFTER ROTATION
    function [ rotated_vector ] = Rotate( obj, vector )
      
      vector = [0, vector];
      
      % using: vec_b = q(a,b) (*) vec_a (*) q(b,a)
      rotated_vector = QuaternionProduct(obj.QuaternionProduct(vector), obj.conjugate);
      
      rotated_vector = rotated_vector.base(2:4);
    end
    
    
    %% QUATERNIONPRODUCT
    % INPUT:  {1} OBJ - THE QUATERNION OBJECT
    %         {2} ANOTHER_QUATERNION - THE OTHER QUATERNION IN THE PRODUCT
    % OUTPUT: {1} PRODUCT - THE COMPOUND QUATERNION AS A NEW OBJECT
    function [ product ] = QuaternionProduct( obj, another_quaternion )
      q_prod = zeros(1,4);
      q1 = obj.base;
      
      if isa(another_quaternion, 'Quaternion')
        q2 = another_quaternion.base;
      else
        q2 = another_quaternion;
      end
      
      q_prod(1) = q1(1)*q2(1) - q1(2)*q2(2) - q1(3)*q2(3) - q1(4)*q2(4);
      q_prod(2) = q1(1)*q2(2) + q1(2)*q2(1) + q1(3)*q2(4) - q1(4)*q2(3);
      q_prod(3) = q1(1)*q2(3) - q1(2)*q2(4) + q1(3)*q2(1) + q1(4)*q2(2);
      q_prod(4) = q1(1)*q2(4) + q1(2)*q2(3) - q1(3)*q2(2) + q1(4)*q2(1);
      
      product = Quaternion(q_prod);
    end
    
    
    %% MAGNITUDE
    % INPUT:  {1} OBJ - THE QUATERNION OBJECT
    % OUTPUT: {1} MAG - THE NORM OF THE QUATERNION
    function [ mag ] = Magnitude( obj )
      mag = norm(obj.base);
    end
    
    
    %% QUATERNIONTOROTATIONMATRIX
    % INPUT:  {1} OBJ - THE QUATERNION OBJECT
    % OUTPUT: {1} R - THE 3x3 ROTATION MATRIX
    function [ R ] = QuaternionToRotationMatrix( obj )
      q = obj.base;
      R = zeros(3,3);
      
      R(1,1) = 2*(q(1)^2) - 1 + 2*(q(2)^2);
      R(1,2) = 2*( q(2)*q(3) + q(1)*q(4) );
      R(1,3) = 2*( q(2)*q(4) - q(1)*q(3) );
      
      R(2,1) = 2*( q(2)*q(3) - q(1)*q(4) );
      R(2,2) = 2*(q(1)^2) - 1 + 2*(q(3)^2);
      R(2,3) = 2*( q(3)*q(4) + q(1)*q(2) );
      
      R(3,1) = 2*( q(2)*q(4) + q(1)*q(3) );
      R(3,2) = 2*( q(3)*q(4) - q(1)*q(2) );
      R(3,3) = 2*(q(1)^2) - 1 + 2*(q(4)^2);
    end
    
    
    %% QUATERNIONTOEULER
    % INPUT:  {1} OBJ - THE QUATERNION OBJECT
    % OUTPUT: {1} EULER - 3-ELEMENT VECTOR [ROT_X, ROT_Y, ROT_Z] IN RADIANS
    function [ euler ] = QuaternionToEuler( obj )
      q = obj.conjugate;
      
      rot_x = atan2( 2*q(2)*q(3) - 2*q(1)*q(4), 2*(q(1)^2) + 2*(q(2)^2) - 1 );
      rot_y = -asin( 2*q(2)*q(4) + 2*q(1)*q(3) );
      rot_z = atan2( 2*q(3)*q(4) - 2*q(1)*q(2), 2*(q(1)^2) + 2*(q(4)^2) - 1 );
       
      euler = [rot_x, rot_y, rot_z];
    end
  end
  
end

