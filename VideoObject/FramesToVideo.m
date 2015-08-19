function FramesToVideo( outputVideoPath, framesStructOrFiles, frameRate )

% Reading frames from files if it is not a struct
if ~isstruct(framesStructOrFiles)
  framesFiles = dir([FixDir(framesStructOrFiles) '/*.jpg']);
  numFrames = length(framesFiles);
else
  numFrames = length(framesStructOrFiles);
end


% Creating the VideoWriter object and opening the new video
outputVideo = VideoWriter(outputVideoPath);
outputVideo.FrameRate = frameRate;
open(outputVideo);


% Adding frames
for i = 1:numFrames
  if isstruct(framesStructOrFiles)
    img = framesStructOrFiles(i).cdata;
  else
    img = imread([FixDir(framesStructOrFiles) framesFiles(i).name]);
  end
  
  
  % Write the frame
  writeVideo(outputVideo, img);
end


% Finalizing the outputted video
close(outputVideo)

end