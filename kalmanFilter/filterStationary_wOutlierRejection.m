function [X,P,Xp,Pp]=filterStationary_wOutlierRejection(Y,A,C,Q,R,x0,P0,B,D,th)
%Same as filterStationary but measurements which are deemed too unlikely
%given current beliefs are rejected and the update step is skipped.

%Init missing params:
if nargin<6 || isempty(x0)
  x0=zeros(size(A,1),1); %Column vector
end
if nargin<7 || isempty(P0)
  P0=1e8 * eye(size(A));
end
if nargin<7 || isempty(B)
  B=0;
end
if nargin<8 || isempty(D)
  D=0;
end
if nargin<9 || isempty(th)
  th=-Inf; %No outliers
end

%Size checks:
%TODO

%Do the filtering
m=size(Y,1); %Dimension of observations
Xp=nan(size(A,1),size(Y,2));
X=nan(size(A,1),size(Y,2));
Pp=nan(size(A,1),size(A,1),size(Y,2));
P=nan(size(A,1),size(A,1),size(Y,2));
prevX=x0;
prevP=P0;
for i=1:size(Y,2)
  b=B*U(:,i);
  d=D*U(:,i);
  [prevX,prevP]=predict(A,Q,prevX,prevP,b);
  Xp(:,i)=prevX;
  Pp(:,:,i)=prevP;
  obsY=Y(:,i);
  innov=obsY-C*prevX; %Innovation from prior belief
  obsUncertainty=C*prevP1*C' + R;
  logp=-innov'*pinv(obsUncertainty)*innov - m*log(2*pi*det(obsUncertainty)); %1/2 of log(p) of observation
  if  logp < th %outlier: no update

  else
    [prevX,prevP]=update(C,R,prevX,prevP,obsY,d);
  end
  X(:,i)=prevX;
  P(:,:,i)=prevP;
end

end
