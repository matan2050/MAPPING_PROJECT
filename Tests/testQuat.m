pnt = [1,0,0];
rotVec = [0,0,1];
figure;
scatter3(pnt(1), pnt(2), pnt(3));
hold on;
plot3([0;0], [0;0], [0;1]);
xlabel('x');
ylabel('y');
zlabel('z');

for theta = 0:0.01:pi
  q = Quaternion(rotVec,theta);
  pntNew = QuaternionRotate(q, pnt);
  hold on;
  scatter3(pntNew(1), pntNew(2), pntNew(3));
end