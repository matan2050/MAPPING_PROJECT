classdef AugmentedObject < handle
  
  properties (Access = private)
    ShapeRadius
    Position
    Points
    Lines
    Faces
    PointsImage
    LinesImage
    FacesImage
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
      obj.Lines = [];
      obj.Faces = [];
      obj.PointsImage = [];
      obj.LinesImage = [];
      obj.FacesImage = [];
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
      
      % Assigning new names for object parameter for convenience
      r = obj.ShapeRadius;
      p = obj.Position;
      
      
      % Filling points list
      obj.Points(1,:) = p + [r/2, r/2, r/2]';
      obj.Points(2,:) = p + [r/2, r/2, -r/2]';
      obj.Points(3,:) = p + [r/2, -r/2, r/2]';
      obj.Points(4,:) = p + [-r/2, r/2, r/2]';
      obj.Points(5,:) = p + [-r/2, -r/2, r/2]';
      obj.Points(6,:) = p + [-r/2, r/2, -r/2]';
      obj.Points(7,:) = p + [r/2, -r/2, -r/2]';
      obj.Points(8,:) = p + [-r/2, -r/2, -r/2]';
      
      
      % Line-Points connectivity
      obj.Lines = zeros(10,2);
      obj.Lines(1,:) = [1,2];
      obj.Lines(2,:) = [1,3];
      obj.Lines(3,:) = [1,4];
      obj.Lines(4,:) = [2,6];
      obj.Lines(5,:) = [2,7];
      obj.Lines(6,:) = [3,5];
      obj.Lines(7,:) = [3,7];
      obj.Lines(8,:) = [4,5];
      obj.Lines(9,:) = [4,6];
      obj.Lines(10,:) = [5,8];
      obj.Lines(11,:) = [6,8];
      obj.Lines(12,:) = [7,8];
      
      
      % Face-Points connectivity
      obj.Faces = zeros(6,5); 
      obj.Faces(1,:) = [1,2,6,4,1]; % V
      obj.Faces(2,:) = [1,3,7,2,1]; % V
      obj.Faces(3,:) = [2,6,8,7,2]; % V
      obj.Faces(4,:) = [4,5,8,6,4]; % V
      obj.Faces(5,:) = [3,5,4,1,3]; % V
      obj.Faces(6,:) = [7,3,5,8,7];
    end
    
    
    
    % ----------------
    % VisualizeLines3D
    % ----------------
    %
    % Visualizes the augmented object's lines in a 3D line plot (mainly for
    % debugging purposes
    function [ figHandle ] = VisualizeLines3D( obj, figHandle )
      
      % Making sure we have a figure ready
      if nargin > 1
        currHandle = figHandle;
      else
        currHandle = figure;
      end
      
      figure(currHandle);
      hold on;
      
      for i = 1:size(obj.Lines,1)
        currentPair = zeros(2,3);
        currentPair(:,1) = [obj.Points(obj.Lines(i,1),1); obj.Points(obj.Lines(i,2),1)];
        currentPair(:,2) = [obj.Points(obj.Lines(i,1),2); obj.Points(obj.Lines(i,2),2)];
        currentPair(:,3) = [obj.Points(obj.Lines(i,1),3); obj.Points(obj.Lines(i,2),3)];
        line(currentPair(:,1), currentPair(:,2), currentPair(:,3));
      end
      
      
      % Assigning figure to output argument
      figHandle = currHandle;
    end
    
    
    
    % ----------------
    % VisualizeFaces3D
    % ----------------
    %
    % Visualizes the augmented object's faces in a 3D face plot (mainly for
    % debugging purposes
    function [ figHandle ] = VisualizeFaces3D( obj, figHandle )
      
      
      % Making sure we have a figure ready
      if nargin > 1
        currHandle = figHandle;
      else
        currHandle = figure;
      end
      
      
      % For better readability, shorter names
      f = obj.Faces;
      p = obj.Points;
      
      
      figure(currHandle);
      hold on;
      
      
      for i = 1:size(obj.Faces)
        currentSet = zeros(5,3);
        currentSet(:,1) = [p(f(i,1),1); p(f(i,2),1); p(f(i,3),1); p(f(i,4),1); p(f(i,5),1)];
        currentSet(:,2) = [p(f(i,1),2); p(f(i,2),2); p(f(i,3),2); p(f(i,4),2); p(f(i,5),2)];
        currentSet(:,3) = [p(f(i,1),3); p(f(i,2),3); p(f(i,3),3); p(f(i,4),3); p(f(i,5),3)];
        fill3(currentSet(:,1), currentSet(:,2), currentSet(:,3), rand);
      end
    end
    
    
    
    % ------------
    % ShapeToImage
    % ------------
    %
    % Projets the AugmentedObject shape from 3D space (World) to 2D image
    % plane (Image) according to a camera model object
    function [ obj ] = ShapeToImage( cameraModel )
      
    end
  end
  
end

