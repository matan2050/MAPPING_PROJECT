function [ rotatedVec ] = QuaternionRotate( quat, vec )
%QUATERNIONROTATE applies the rotation characterized by the quaternion
% { quat } to the vector { vec }. the resulting vector is returned in
% { rotatedVec }

[m,n] = size(vec);

if m>n
  vec = vec';
end

if length(vec) < 4
  vec = [0, vec];
elseif vec > 4
  error('dimension mismatch');
end

quatConj = QuaternionInv(quat);
tempRotatedVec = QuaternionProduct(quatConj, vec);
rotatedVec4element = QuaternionProduct(tempRotatedVec, quat);
rotatedVec = rotatedVec4element(2:4);

end