% CONSTRUCT A NEW QUATERNION OBJECT
axis1 = [0,0,-1];
theta1 = pi/3;
q1 = Quaternion(axis1, theta1);

% CONSTRUCT A SECOND QUATERNION
axis2 = [1,2,3];
theta2 = pi/6;
q2 = Quaternion(axis2, theta2);

% PRODUCT OF THE TWO QUATERNIONS
q3 = q1.QuaternionProduct(q2);

% ROTATING [1,2,0] USING Q1
rotVec = q1.Rotate([1,2,0])