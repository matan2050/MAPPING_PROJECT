function [ omega, phi, kappa ] = R2Euler( R )
% R2EULER finds the euler angles
% { omega, phi, kappa } from a rotation matrix { R }

phi     = asin(R(3,1));
omega   = acos(R(3,3)/cos(phi));
kappa   = acos(R(1,1)/cos(phi));

% TODO - POSSIBLE SWITCH BETWEEN KAPPA AND PHI
end

