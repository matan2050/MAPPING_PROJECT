function [ figHandleOut ] = AssertFigureHandle( figHandleIn )

if ishandle(figHandleIn)
  figHandleOut = figHandleIn;
else
  figHandleOut = figure;
end

figure(figHandleOut);
return;


end

