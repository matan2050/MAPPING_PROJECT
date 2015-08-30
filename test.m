%% Testing projection

% Creating augmented object
object = AugmentedObject();
object.CreateShape([20; 0; 0], 0.5);


% Creating camera model
model = CameraModel(1000, 1000, 240, 360, 0, 0, 0, 0, 0, 0, [480 720]);
model.UpdateByRotation(0, 0, 0);
K = model.K;
R = model.R;
vec = (K^-1)*(R^-1)*[240;360;1]; % checking LOS
pix = model.Point2Pixel([100;0;0]); % checking projection on camera


run_Fusion;


if (0)
  videoPath = 'C:\Users\User\Dropbox\MAPPING_PROJECT\Data\1_Jun_2015_17-08-31_GMT\video-1_Jun_2015_17-08-31_GMT.mp4';
  [mov, frameRate] = VideoToFrames(videoPath);
end
[videoPartsPath, videoPartsFile, videoPartsExt] = fileparts(videoPath);
newVideo = [FixDir(videoPartsPath) videoPartsFile '_new' videoPartsExt];
newVideoFramesPath = FixDir([FixDir(videoPartsPath) videoPartsFile '_new']);
mkDirAdapter(newVideoFramesPath);


for i = 1:size(eulerAngles,1)
  frame = [FixDir(newVideoFramesPath) 'frame' num2str(i) '.jpg'];
  angs = eulerAngles(i,:);
  angs = angs*pi/180;
  model.UpdateByRotation(angs(1), angs(2), angs(3));
  fig = imshow(mov(i).cdata);
  hold on;

  
  object.ShapeToImage(model);
  f = object.Faces
  p = object.PointsImage
  
  for j = 1:size(object.Faces, 1)
    currentSet = zeros(5,2);
    currentSet(:,1) = [p(f(j,1),1); p(f(j,2),1); p(f(j,3),1); p(f(j,4),1); p(f(j,5),1)];
    currentSet(:,2) = [p(f(j,1),2); p(f(j,2),2); p(f(j,3),2); p(f(j,4),2); p(f(j,5),2)];
    fill(currentSet(:,1), currentSet(:,2), rand);
  end
  saveas(fig, frame, 'jpeg');
  hold off;
  
  %FramesToVideo( newVideo, framesStructOrFiles, frameRate )
end
