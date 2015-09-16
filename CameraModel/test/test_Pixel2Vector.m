% Defining camera model
model = CameraModel(1000,1000,1000,1000,0,0,0,0,0,0,[2000 2000]);

% First case - optical center, no rotation
pixel = [model.Cu; model.Cv];
vector1 = model.Pixel2Vector(pixel);
disp(['Should be: 0,0,1     ' num2str(vector1(1)) ',' num2str(vector1(2)) ',' num2str(vector1(3))]);

% Second case - optical center, rotation 0,-pi/2,0
model.UpdateByRotation(0,-pi/2,0);
vector2 = model.Pixel2Vector(pixel);
disp(['Should be: 1,0,0     ' num2str(vector2(1)) ',' num2str(vector2(2)) ',' num2str(vector2(3))]);

% Third case - optical center, rotation pi/2,0,0
model.UpdateByRotation(pi/2,0,0);
vector3 = model.Pixel2Vector(pixel);
disp(['Should be: 0,1,0     ' num2str(vector3(1)) ',' num2str(vector3(2)) ',' num2str(vector3(3))]);