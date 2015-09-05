function [ outputStructure ] = InterpolateNan( structureWithNan )

% Init
[m,n] = size(structureWithNan);

if n>m
  structureWithNan = structureWithNan';
  m = m+n;
  n = m-n;
  m = m-n;
end


outputStructure = [];

for i = 1:n
  firstValue = [];
  secondValue = [];
  valueCounter = 0;
  vectorWithNan = structureWithNan(:,i);
  outputVector = zeros(size(vectorWithNan));

  j = 1;
  
  while j <= length(vectorWithNan)
    
    if ~isnan(vectorWithNan(j)) && isempty(firstValue)
      firstValue = vectorWithNan(j);
      outputVector(j) = vectorWithNan(j);
      valueCounter = 1;
      j = j + 1;
      continue;
      
    elseif ~isnan(vectorWithNan(j)) && ~isempty(firstValue)
      secondValue = vectorWithNan(j);
      
      delta = secondValue - firstValue;
      increment = delta / valueCounter;
      
      for k = 0:valueCounter
        outputVector(j-(valueCounter)+k) = firstValue + (k+1)*increment;
      end
      
      firstValue = vectorWithNan(j);
      valueCounter = 0;
      j = j + 1;
      continue;
      
    else
      valueCounter = valueCounter + 1;
    end
    j = j + 1;
  end
  
  outputStructure = [outputStructure, outputVector];
  
end

end