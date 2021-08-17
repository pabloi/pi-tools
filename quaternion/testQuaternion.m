
%% Constructors
q1 = myQuaternion([1,2,3,4])
q2 = myQuaternion(1,[4,3,2])
q3 = myQuaternion(4,3,2,1)
q4 = myQuaternion.fromVector([1,2,3])
dq = myQuaternion(.001*randn(4,1))

%% Functions
disp('Should match:')
q1.norm 
sqrt( 1^2 + 2^2 + 3^2 + 4^2)

disp('')
q1 * q2 

disp(['Should be ' num2str(q1.norm.^2) ' * [1,0,0,0]:'])
q= q1 * q1.conj;
q.to4Vector

disp('Should be product neutral quaternion [1,0,0,0]:')
q = q3 * q3.inv;
q.to4Vector

%% Rotations of vectors and its derivatives
v=[4,2,1];

%Direct:
[w,J] = q1.rotate(v);
q2 = q1+dq;
[w2] = q2.rotate(v);
disp('Should match:')
w2-w
J*dq.to4Vector

R = q1.toRotationMatrix;
disp('Should match:')
R*v'
w

%Inverse:
[w,J] = q1.rotateinv(v);
[w2] = q2.rotateinv(v);
disp('Should match:')
w2-w
J*dq.to4Vector

R = q1.toRotationInvMatrix;
disp('Should match:')
R*v'
w

%% Products as matrix products

disp('Should match:')
q = q1 * q2;
q.to4Vector
q1.toLeftProdMatrix * q2.to4Vector

disp('Should match:')
q.to4Vector
q2.toRightProdMatrix * q1.to4Vector