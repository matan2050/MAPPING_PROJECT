function [ dir_string ] = FixDir( dir_original )
%FIXDIR adds '\' to the input path if not existing

if dir_original(end) == '\'
  dir_string = dir_original;
else
  dir_string = [dir_original '\'];
end

end

