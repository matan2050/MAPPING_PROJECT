%% Testing projection

% Creating camera model
model = CameraModel(4241, 4241, 184, 328, 0, 0, 0, 0, 0, 0, [368 656]);
model.UpdateByRotation(0, pi/2, pi);
K = model.K;
R = model.R;
vec = (K^-1)*(R^-1)*[240;360;1]; % checking LOS
pix = model.Point2Pixel([100;0;0]); % checking projection on camera

run_Fusion;

angs = eulerAngles(50,:)*pi/180;
model.UpdateByRotation(angs(1), angs(2), angs(3));
% Creating augmented object
object = AugmentedObject();
object.CreateShapeByModelOrientation(model, 100, 5);
if (0)
  %videoPath = 'C:\Users\User\Dropbox\MAPPING_PROJECT\Data\1_Jun_2015_17-08-31_GMT\video-1_Jun_2015_17-08-31_GMT.mp4';
  videoPath = 'C:\Users\User\Dropbox\MAPPING_PROJECT\data\NewData\video-1441490475.mp4.mp4';
  [mov, frameRate] = VideoToFrames(videoPath);
end
[videoPartsPath, videoPartsFile, videoPartsExt] = fileparts(videoPath);
newVideo = [FixDir(videoPartsPath) videoPartsFile '_new' videoPartsExt];
newVideoFramesPath = FixDir([FixDir(videoPartsPath) videoPartsFile '_new']);
mkDirAdapter(newVideoFramesPath);


for i = 50:size(eulerAngles,1)
  frame = [FixDir(newVideoFramesPath) 'frame' num2str(i) '.jpg'];
  angs = eulerAngles(i,:);
  angs = angs*pi/180;
  model.UpdateByRotation(angs(1), angs(2), angs(3));
  fig = imshow(mov(i).cdata);
%   img = 255*ones(1920, 1080, 3);
%   fig = imshow(img);
  hold on;

   
  object.ShapeToImage(model);
  f = object.Faces;
  p = object.PointsImage;
  
  for j = 1:size(object.Faces, 1)
    currentSet = zeros(5,2);
    currentSet(:,1) = [p(f(j,1),1); p(f(j,2),1); p(f(j,3),1); p(f(j,4),1); p(f(j,5),1)];
    currentSet(:,2) = [p(f(j,1),2); p(f(j,2),2); p(f(j,3),2); p(f(j,4),2); p(f(j,5),2)];
    fill(currentSet(:,1), currentSet(:,2), rand);
  end
  saveas(fig, frame, 'jpeg');
  hold off;
end

FramesToVideo( newVideo, newVideoFramesPath, frameRate )

