% Not saving frames
videoPath = 'C:\Users\User\Dropbox\MAPPING_PROJECT\Data\1_Jun_2015_17-08-31_GMT\video-1_Jun_2015_17-08-31_GMT.mp4';
[mov, frameRate] = VideoToFrames(videoPath);

% Saving frames
videoPath = 'C:\Users\User\Dropbox\MAPPING_PROJECT\Data\1_Jun_2015_17-08-31_GMT\video-1_Jun_2015_17-08-31_GMT.mp4';
framesDir = 'c:\temp\frames';
[mov, frameRate] = VideoToFrames(videoPath, framesDir);
