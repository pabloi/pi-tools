function [X,Y,Z] = ellipsoid2(xC,M,N)
%ELLIPSOID Generalization of the ellipsoid function to plot ellipsoids with
%arbitrary axes.
%INPUTS: 
% xC = coordinates of the center of the ellipsoid
% M = symmetric positive definite matrix whose eigen vectors represent the direction
% of the principal axes, and the eigen values represent the inverse of size of the
% corresponding semi-axis. In this way, the ellipsoid is defined by the vectors x
% such that x'*M*x=1.
% N = number of points in the ellipsoid to find.
%OUTPUTS:
% X,Y,Z = 3D coordinates of the points in the surface of the ellipsoid.

if nargin<3
    N=20;
end
if length(xC)==2
    xC(3)=0;
    M=[M, zeros(2,1); zeros(1,2),1];
end

%Check: U and V should be the same matrix, otherwise S is not symmetric.

[X,Y,Z]=ellipsoid(xC(1),xC(2),xC(3),1,1,1,N);

aux=[X(:)-xC(1),Y(:)-xC(2),Z(:)-xC(3)]';
aux2=pinv(chol(M))*aux;
X=reshape(aux2(1,:),size(X,1),size(X,2))+xC(1);
Y=reshape(aux2(2,:),size(X,1),size(X,2))+xC(2);
Z=reshape(aux2(3,:),size(X,1),size(X,2))+xC(3);


end

