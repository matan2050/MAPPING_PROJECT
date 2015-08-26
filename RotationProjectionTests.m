camPos = [0,0,0];
camPose = [0,0,0];

fu = 5000;
fv = 5000;
cu = 1000;
cv = 1000;

model = CameraModel(fu, fv, cu, cv, camPose(1), camPose(2), camPose(3), camPos(1), camPos(2), camPos(3), [2000 2000]);
invK = model.K^-1;

%% Checking LOS created by K matrix
invK*[cu;cv;1] % camera center
invK*[0;0;1] % top left corner
invK*[2000;2000;1] % bottom right corner

model.Point2Pixel([0;0;10])
model.Point2Pixel([0;0;100])
model.Point2Pixel([0;0;1000])

model.Point2Pixel([50;50;1000])

%% Now with R
model.UpdateByRotation(pi/2,pi/2,0);
invKR = (model.R^-1)*(model.K^-1);

R = RotationMatrix(0,0,0);
invKR = (R^-1)*(model.K^-1);

invKR*[cu;cv;1]
invKR*[0;0;1]
invKR*[2000;2000;1]


model.Point2Pixel([10;0;0])
model.Point2Pixel([0;10;0])
model.Point2Pixel([0;0;10])