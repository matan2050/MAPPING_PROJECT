% INIT
frameRate = 30;
videoPath = 'C:\Users\User\Dropbox\MAPPING_PROJECT\data\NewData\video-1441490475_1.mp4';


% Creating camera model
model = CameraModel(1372, 1372, 640, 360, 0, 0, 0, 0, 0, 0, [1280 720]);


% Run Madgwick algorithm
run_Fusion;


% Create orientation angles for every frame, not just sample rate
[newRs, eulerNew] = SamplingRotationToFramerate(Rs, eulerAngles, 0.1, frameRate);


% Pick original position for cube, after the original angles are stable
stablePosition = length(Rs)/8;
stablePosition = floor(stablePosition);
angs = eulerNew(stablePosition,:)*pi/180;
model.UpdateByRotation(angs(1), angs(2), angs(3));


% Creating augmented object
object = AugmentedObject();
object.CreateShapeByModelOrientation(model, 10, 0.5);

[videoPartsPath, videoPartsFile, videoPartsExt] = fileparts(videoPath);
newVideo = [FixDir(videoPartsPath) videoPartsFile '_new' videoPartsExt];
newVideoFramesPath = FixDir([FixDir(videoPartsPath) videoPartsFile '_new']);
mkDirAdapter(newVideoFramesPath);


% Outputting all frames
for i = 1:size(eulerNew,1)
  frame = [FixDir(newVideoFramesPath) 'frame' num2str(i) '.jpg'];
  angs = eulerNew(i,:);
  angs = angs*pi/180;
  model.UpdateByRotation(angs(1), angs(2), angs(3));
  img = 255*ones(1280, 720, 3);
  fig = imshow(img);
  hold on;

   
  object.ShapeToImage(model);
  f = object.Faces;
  p = object.PointsImage;
  
  
  % Plotting all the faces in the cube
  for j = 1:size(object.Faces, 1)
    currentSet = zeros(5,2);
    currentSet(:,1) = [p(f(j,1),1); p(f(j,2),1); p(f(j,3),1); p(f(j,4),1); p(f(j,5),1)];
    currentSet(:,2) = [p(f(j,1),2); p(f(j,2),2); p(f(j,3),2); p(f(j,4),2); p(f(j,5),2)];
    fill(currentSet(:,1), currentSet(:,2), rand);
  end
  saveas(fig, frame, 'jpeg');
  hold off;
end

% Creating the movie
FramesToVideo( newVideo, newVideoFramesPath, frameRate )