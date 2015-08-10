function [ invQuat ] = QuaternionInv( quat )
% QUATERNIONINV returns the conjugate { invQuat }
% of the quaternion { quat }

% ### INIT ###
invQuat = zeros(1,4);

% ### QUATERNION CONJUGATE DEFINITION ###
invQuat(1) = quat(1);
invQuat(2) = -quat(2);
invQuat(3) = -quat(3);
invQuat(4) = -quat(4);

end

