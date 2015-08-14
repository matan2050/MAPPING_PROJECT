classdef AugmentedObject < handle
  
  properties (Access = private)
    ShapeRadius
    Position
    Points
    PointsIndicesTopology
  end
  
  methods
    
    % ---------------
    % AugmentedObject
    % ---------------
    %
    % Constructor, initializes a new instance of AugmentedObject
    function [ obj ] = AugmentedObject()
      obj.ShapeRadius = [];
      obj.Position = [];
      obj.Points = [];
    end
    
    
    
    % -----------
    % CreateShape
    % -----------
    %
    % Creates a new 3D shape around the 'position' field (3D vector) and in
    % the 'shapeRadius' (scalar) size
    function [ obj ] = CreateShape( obj, position, shapeRadius )
      obj.Position = position;
      obj.ShapeRadius = shapeRadius;
      obj = obj.GeneratePoints();
    end
    
    
    
    
    % --------------
    % GeneratePoints
    % --------------
    %
    % Generates the vertices of the shape according to the shape parameters
    % already entered into the object
    function [ obj ] = GeneratePoints( obj )
      
      % object's points will be 8x3 matrix
      obj.Points = zeros(8,3);
      
      % assigning new names for object parameter for convenience
      r = obj.ShapeRadius;
      p = obj.Position;
      
      obj.Points(1,:) = p + [r/2, r/2, r/2]';
      obj.Points(2,:) = p + [r/2, r/2, -r/2]';
      obj.Points(3,:) = p + [r/2, -r/2, r/2]';
      obj.Points(4,:) = p + [-r/2, r/2, r/2]';
      obj.Points(5,:) = p + [-r/2, -r/2, r/2]';
      obj.Points(6,:) = p + [-r/2, r/2, -r/2]';
      obj.Points(7,:) = p + [r/2, -r/2, -r/2]';
      obj.Points(8,:) = p + [-r/2, -r/2, -r/2]';
    end
  end
  
end

