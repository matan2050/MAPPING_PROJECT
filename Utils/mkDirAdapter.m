function mkDirAdapter( folder )

if ~exist(folder, 'dir')
  mkdir(folder);
end

end