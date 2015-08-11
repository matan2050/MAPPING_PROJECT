function [ euler3Vec ] = R2Euler( R )
% R2EULER finds the euler angles
% { omega, phi, kappa } from a rotation matrix { R }
% 
% phi     = asin(R(3,1));
% omega   = acos(R(3,3)/cos(phi));
% kappa   = acos(R(1,1)/cos(phi));

omega = atan2(R(3,2), R(3,3));
phi = -atan(R(3,1) / sqrt(1 - R(3,1)^2));
kappa = atan2(R(2,1), R(1,1));

euler3Vec = [omega, phi, kappa];

% TODO - POSSIBLE SWITCH BETWEEN KAPPA AND PHI
end