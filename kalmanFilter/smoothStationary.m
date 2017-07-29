function [Xs,Ps,X,P,Xp,Pp]=smoothStationary(Y,A,C,Q,R,x0,P0,b,d)

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

%Step 1: forward filter
  [X,P,Xp,Pp]=filterStationary(Y,A,C,Q,R,x0,P0,b,d);

%Step 2: backward pass:

%Do the filtering
Xs=X;
Ps=P;
prevXs=X(:,end);
prevPs=P(:,:,end);
S=pinv(Q)*A;

for i=(size(Y,2)-1):-1:1
  H= pinv(P(:,:,i)) + A'*S;
  invH=pinv(H);
  newK=invH*S';
  %Equivalent tp:
  %newK=P(:,:,i)*A'/Pp(:,:,i+1);
  prevXs=X(:,i) + newK*(prevXs-A*X(:,i));
  Xs(:,i)=prevXs;
  prevPs=invH + newK*pinv(prevPs)*newK';
  Ps(:,:,i)=prevPs;
end

end
