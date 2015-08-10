function [ quatProd ] = QuaternionProduct_( quat1, quat2 )
% QUATERNIONPRODUCT returns the inner product { quatProd }
% of two quaternions { quat1 } and { quat2 }

% ### INIT ###
quatProd = zeros(1,4);

% ### QUATERNION PRODUCT DEFINITION ###
quatProd(1) = quat1(1)*quat2(1) - quat1(2)*quat2(2) -...
              quat1(3)*quat2(3) - quat1(4)*quat2(4);

quatProd(2) = quat1(1)*quat2(2) - quat1(2)*quat2(1) -...
              quat1(3)*quat2(4) - quat1(4)*quat2(3);

quatProd(3) = quat1(1)*quat2(3) - quat1(2)*quat2(4) -...
              quat1(3)*quat2(1) - quat1(4)*quat2(2);

quatProd(4) = quat1(1)*quat2(4) - quat1(2)*quat2(3) -...
              quat1(3)*quat2(2) - quat1(4)*quat2(1);

            
end

