function [X,P,Xp,Pp]=filterStationary_wConstraint(Y,A,C,Q,R,x0,P0,B,D,U,constFun)
%Same as filterStationary but allowing for a generic constraint model for the states.
%constFun has to be a function that returns three arguments [H,e,S]=constFun(A*x_k)
% such that H*x_{k+1} = e + s, with s~N(0,S);
% This can be a linearization of a non-lin function.

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
if nargin<9 || isempty(U)
  U=zeros(size(B,2),size(X,1));
end
if nargin<10 || isempty(constFun)
  constFun=@(x) myfun(X);
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

  %Add constraint conditions to observation:
  [H,e,S]=constFun(prevX);
  newC=[C;H];
  Z=zeros(size(R,1), size(H,1));
  newR=[R, Z; Z', S];
  newObs=[obsY;e];
  newD=[d;zeros(size(e))];
  [prevX,prevP]=update_wOutlierRejection(newC,newR,prevX,prevP,newObs,newD); %Could be w/o rejection
  X(:,i)=prevX;
  P(:,:,i)=prevP;
end

end

function [H,e,S]=myfun(x)
  H=zeros(0,size(x,1));
  e=[];
  S=[];
end
