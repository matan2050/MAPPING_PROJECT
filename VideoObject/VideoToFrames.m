function [ mov, frameRate ] = VideoToFrames( videoPath, framesDir )

% Determining input and making sure the output frames folder exists
if nargin < 2
  framesDir = [];
else
  mkDirAdapter(framesDir);
end


% Loading VideoReader object based on the video
videoObj = VideoReader(videoPath);
frameRate = videoObj.FrameRate;
numFrames = videoObj.NumberOfFrames;


% Reading frames
videoFrames = read(videoObj);


% Putting all frames into mov struct
for k = 1 : numFrames
  mov(k).cdata = videoFrames(:,:,:,k);
  mov(k).colormap = [];
  
  
  % If the user requested, writing frames to files
  if ~isempty(framesDir)
    frameNumberStr = sprintf('%07d', k);
    currentFrameFilename = ['frame_', frameNumberStr, '.jpg'];
    currentFramePath = [FixDir(framesDir), currentFrameFilename];
    
    imwrite(mov(k).cdata, currentFramePath);
  end
end


end