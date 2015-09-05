classdef ArtificialObject < handle
  % ARTIFICIALOBJECT represents the object that will be overlayed above the
  % movie. the object will be a cube, defined by it's vertices.
  % the object will be defined in 3d space
  
  properties %(Access = private)
    %% ### GENERAL PROPERTIES ###
    name              = [];       % general name for the shape
    shape             = 'Cube';   % type of shape (default is cube)
    
    %% ### GEOMETRICAL INPUT PROPERTIES ###
    points_list_      = [];       % vector of 3d points
    lines_list_       = [];       % vector of point indices pairs {pnt_ind_A, pnt_ind_B}
    faces_list_       = [];       % vector of point indices quads {pnt_ind_A, pnt_ind_B, pnt_ind_C, pnt_ind_D}
    
    %% ### DISPLAYABLE PROPERTIES ###
    scatters_   = [];       % points organized for use in scatter3 figure
    lines_      = [];       % points organized for use in line figure
    fills_      = [];       % points organized for use in fill3 figure
    
    %% ### CALCULATED PROPERTIES ###
    center_point_     = [];       % algebric mean of shape's points
  end
  
  methods
    %% ### CONSTRUCTOR ###
    function obj = ArtificialObject(name, points, lines, faces)
      % assigned parameters
      obj.name          = name;
      obj.points_list_  = points;
      obj.lines_list_   = lines;
      obj.faces_list_   = faces;
      
      obj = obj.RefreshShape();
    end
    
    
    %% ### REFRESH SHAPE ###
    function obj = RefreshShape(obj)
      % at this time, the point were already transformed
      obj.center_point_ = [mean(obj.points_list_(:,1)),...
                           mean(obj.points_list_(:,2)),...
                           mean(obj.points_list_(:,3))];
      
      % for scatter plot
      obj.scatters_ = obj.points_list_;
      
      % for lines
      nLines = size(obj.lines_list_,1);
      obj.lines_ = cell(nLines,1);
      for i=1:nLines
        pnt1 = obj.points_list_(obj.lines_list_(i,1),:)';
        pnt2 = obj.points_list_(obj.lines_list_(i,2),:)';
        
        obj.lines_{i}   = [[pnt1(1), pnt2(1)]',...
                           [pnt1(2), pnt2(2)]',...
                           [pnt1(3), pnt2(3)]'];
      end
      
      % for fills
      nFills = size(obj.faces_list_,1);
      obj.fills_ = cell(nFills,1);
      for i=1:nFills
        obj.fills_{i}   = [obj.points_list_(obj.faces_list_(i,1),:)',...
                           obj.points_list_(obj.faces_list_(i,2),:)',...
                           obj.points_list_(obj.faces_list_(i,3),:)'];
      end
    end
    
    
    %% ### GET FUNCTIONS ###
    function pntList = GetPointsList(obj)
      pntList = obj.points_list_;
    end
    
    function lines = GetLinesList(obj)
      lines = obj.lines_list_;
    end
    
    function faces = GetFacesList(obj)
      faces = obj.faces_list_;
    end
    
    
    %% ### SET FUNCTIONS ###
    function obj = SetPointsList(obj, pntList)
      obj.points_list_ = pntList;
    end
    
    function obj = SetLinesList(obj, linesList)
      obj.lines_list_ = linesList;
    end
    
    function obj = SetFacesList(obj, facesList)
      obj.faces_list_ = facesList;
    end
    
    
    %% ### GEOMETRIC FUNCTIONS
    % ROTATION
    function obj = RotateArtificialObject(obj, angles, rotationCenterPoint)
      if nargin == 2
        rotationCenterPoint = obj.center_point_;
      end
      
      R = RotationMatrix(angles(1), angles(2), angles(3));
      [m,n] = size(obj.points_list_);
      
      pointsFromCenter = [obj.points_list_(:,1) - ones(m,1) * rotationCenterPoint(1),...
                          obj.points_list_(:,2) - ones(m,1) * rotationCenterPoint(2),...
                          obj.points_list_(:,3) - ones(m,1) * rotationCenterPoint(3)];
      
      obj.points_list_ = R * pointsFromCenter';
      obj.points_list_ = obj.points_list_';
      obj = obj.RefreshShape();
    end
    
    % TRANSLATION
    function obj = TranslateArtificialObject(obj, translationValues)
      obj.points_list_(:,1) = obj.points_list_(:,1) + translationValues(1);
      obj.points_list_(:,2) = obj.points_list_(:,2) + translationValues(2);
      obj.points_list_(:,3) = obj.points_list_(:,3) + translationValues(3);
      obj = obj.RefreshShape();
    end
    
    % SCALING
    function obj = ScaleArtificialObject(obj, scaleFactors)
      obj.points_list_(:,1) = obj.points_list_(:,1) * scaleFactors(1);
      obj.points_list_(:,2) = obj.points_list_(:,2) * scaleFactors(2);
      obj.points_list_(:,3) = obj.points_list_(:,3) * scaleFactors(3);
      obj = obj.RefreshShape();
    end
    
    %% DISPLAY FUNCTIONS
    function DisplayShape(obj)
      %%%%%%%%%%%%%%%%%%%%%%%%% TODO - FINISH FUNCTION
      figure, hold on;
      for i=1:size(obj.points_list_,1)
        scatter3(obj.scatters_(i,1),...
                 obj.scatters_(i,2),...
                 obj.scatters_(i,3));
        hold on;
      end
      
      hold on;
      for i=1:length(obj.lines_)
        curr_line = obj.lines_{i};
        
        plot3(curr_line(:,1), curr_line(:,2), curr_line(:,3));
        hold on;
      end
      
      hold on;
      for i=1:length(obj.fills_)
        color = rand(1,3);
        curr_face = obj.fills_{i};
        
        fill3(curr_face(1,:), curr_face(2,:), curr_face(3,:), color);
        hold on;
      end
    end
  end
  
end

