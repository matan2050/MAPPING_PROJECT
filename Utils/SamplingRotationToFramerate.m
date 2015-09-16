function [ newRs, newAngs ] = SamplingRotationToFramerate( Rs, euler, samplingRate, frameRate )
% SamplingRotationToFramerate takes the outputted rotation matrices from
% the Madgwick algorithm, and creates a new cell array of rotation matrices
% for every frame in a given framerate

numberOfRs = size(Rs, 1);
totalTime = numberOfRs * samplingRate;

framerateTime = 0:(1/frameRate):totalTime;
samplingrateTime = 0:samplingRate:totalTime;
frameTimeIndices = zeros(size(framerateTime));

% Starting frames and samples iterators to 1
iter_f = 1;
iter_s = 1;

while iter_f <= length(framerateTime)
  
  % Checking if we've passed the length of sampling iterator
  if iter_s > length(Rs)
    break;
  end
  
  % Assigning the values according to current iterator positions
  newRs(iter_f) = Rs(iter_s);
  newAngs(iter_f,:) = euler(iter_s,:);
  
  
  % Updating iterators;
  if framerateTime(iter_f) > samplingrateTime(iter_s)
    iter_s = iter_s + 1;
    iter_f = iter_f + 1;
    
  elseif framerateTime(iter_f) <= samplingrateTime(iter_s)
    iter_f = iter_f + 1;
  end 
  
end

newRs = newRs';
end

