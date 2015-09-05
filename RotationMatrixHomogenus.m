function [ matrix ] = RotationMatrixHomogenus( omega, phi, kappa )
% omega, phi, kappa given in radians

R1 = [1 0 0 0; 0 cos(omega) -sin(omega) 0; 0 sin(omega) cos(omega) 0; 0 0 0 1];
R2 = [cos(phi) 0 sin(phi) 0; 0 1 0 0; -sin(phi) 0 cos(phi) 0; 0 0 0 1];
R3 = [cos(kappa) -sin(kappa) 0 0; sin(kappa) cos(kappa) 0 0; 0 0 1 0; 0 0 0 1];

matrix = R1*R2*R3;

end

