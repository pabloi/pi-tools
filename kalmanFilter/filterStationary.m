function [X,P,Xp,Pp]=filterStationary(Y,A,C,Q,R,x0,P0,b,d,outlierRejection)
%filterStationary implements a Kalman filter assuming
%stationary (fixed) noise matrices and system dynamics
%The model is: x[k+1]=A*x[k]+b+v[k], v~N(0,Q)
%y[k]=C*x[k]+d+w[k], w~N(0,R)

%Init missing params:
if nargin<6 || isempty(x0)
  x0=zeros(size(A,1),1); %Column vector
end
if nargin<7 || isempty(P0)
  P0=1e8 * eye(size(A));
end
if nargin<7 || isempty(b)
  b=0;
end
if nargin<8 || isempty(d)
  d=0;
end

%Size checks:
%TODO

%Do the filtering
Xp=nan(size(A,1),size(Y,2));
X=nan(size(A,1),size(Y,2));
Pp=nan(size(A,1),size(A,1),size(Y,2));
P=nan(size(A,1),size(A,1),size(Y,2));
prevX=x0;
prevP=P0;
for i=1:size(Y,2)
  [prevX,prevP]=predict(A,Q,prevX,prevP,b);
  Xp(:,i)=prevX;
  Pp(:,:,i)=prevP;
  if ~outlierRejection
    [prevX,prevP]=update(C,R,prevX,prevP,d);
  else
    [prevX,prevP]=update_wOutlierRejection(C,R,prevX,prevP,d);
  end
  X(:,i)=prevX;
  P(:,:,i)=prevP;
end

end
