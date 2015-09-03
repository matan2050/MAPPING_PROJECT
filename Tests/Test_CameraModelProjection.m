% CameraC: [0 0 0]
% Point: [100 100 100]
% CameraAngs: [pi/2 pi/2 pi/2]
fu = 1000; fv = 1000;
cu = 1000; cv = 1000;
omega = pi/2;% - 0.01*rand(1);
phi = pi/2;% - 0.01*rand(1);
kappa = pi/2;% - 0.01*rand(1);
x0 = 0; y0 = 0; z0 = 0;
imSize = [2000 2000];

model = CameraModel(fu, fv, cu, cv, omega, phi, kappa, x0, y0,z0, imSize);
point = [100;100;100];
projPoint = model.Point2Pixel(point)

pm1 = model.K^-1;
centerVec = pm1*[cu;cv;1]
startVec = pm1*[0;0;1]
endVec = pm1*[cu*2;cv*2;1]