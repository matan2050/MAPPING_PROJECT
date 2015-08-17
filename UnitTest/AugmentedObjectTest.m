%% Test Initialization + faces and lines visualizations
testObj = AugmentedObject();
testObj.CreateShape([0;0;0], 50);
testObj.VisualizeLines3D();
testObj.VisualizeFaces3D();


%% Define camera model and project the shape to it
model = CameraModel([], 1000, 1000, 1000, 1000, 0, 0, 0, 500, 500, 500, [2000 2000])
testObj.ShapeToImage(model);
testObj.VisualizeLines2D();
testObj.VisualizeFaces2D();
model.UpdateByRotation(pi/4, pi/4, pi/4);
testObj.ShapeToImage(model);
testObj.VisualizeLines2D();
testObj.VisualizeFaces2D();
testObj.VisualizeShape2D();