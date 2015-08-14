function [ mov, frameRate ] = VideoToFrames( videoPath, framesDir )

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
end


end