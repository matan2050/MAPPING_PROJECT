% Getting frames from video
if (0)
  videoPath = 'C:\Users\User\Dropbox\MAPPING_PROJECT\Data\1_Jun_2015_17-08-31_GMT\video-1_Jun_2015_17-08-31_GMT.mp4';
  [mov, frameRate] = VideoToFrames(videoPath);
end

% Defining shape and camera model
testObj = AugmentedObject();
testObj.CreateShape([5;0;0], 1);
model = CameraModel(1000, 1000, 240, 360, pi/2, 0, 0, 0, 0, 0, [480 720])
for i = 1:20 % length(mov)
%   model.UpdateByRotation(0, 0 ,0);
  fig = imshow(mov(i).cdata);
  hold on;
  testObj.ShapeToImage(model);
  testObj.VisualizeFaces2D(fig);
  hold off;
end
