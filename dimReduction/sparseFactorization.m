function [A1,A2] = sparseFactorization(data,k)
%sparseFactorization tries to find A1 and A2 such that: data=A1*A2 +e,
%where e is an error term, and A1 and A2 are matrices such that their
%external dimensions match those of the data, and their internal dimensions
%are k (this is a dimensionality reduction technique). Differently from
%PCA, FA, NNMF and whatnot, this factorization tries to minimize the cost
%J= ||data-A1*A2||_2 + lambda*||A2||_1, which is equivalent to minimizing
% the L2 norm of e plus a sparsity inducing term for the matrix A2. 


Niter=10;
Etol=1e-8;
Ctol=1e-10;



iter=0;
A2=randn(k,size(data,2));
A2=normr(A2);
A1=data/A2;
dA1=Inf;
dA2=Inf;

lambda=1e-3;
correctedLambda=numel(data)*lambda/numel(A2); %This should be less than 1, I think. Otherwise it might be problematic.

DD=norm(data,'fro')^2 + correctedLambda*sum(abs(A2(:)))^2;
J=zeros(Niter,1);
J(1)=DD;
prevJ=2*J(1);

while iter<Niter && (abs(J(iter+1)-prevJ)>prevJ*Etol) && ((dA1+dA2)>(norm(A1,'fro')^2+norm(A2,'fro')^2)*Ctol)
    iter=iter+1
    %Update A2:
    oldA2=A2;
    A2=A2-0.2*(-A1'*(data-A1*A2)+correctedLambda*(sign(A2)));
    A2(abs(A2)<.001*abs(max(A2(:))))=0; %Forcibly killing near 0 elements
    A2=normr(A2);
    
    %Update A1:
    oldA1=A1;
    A1=data*pinv(A2);
    
   % %Normalize A1:
   % A1=normc(A1);
    
    
    
    %Compute new J, dA1, dA2
    J(iter+1)=norm(data-A1*A2,'fro')^2 + correctedLambda*sum(abs(A2(:)))^2; %The factor lambda is normalized so that regardless of the relative size of data and A2 it works in approximately the same way (i.e. that if data has more rows it doesn't necessarily mean that the first term will be larger than the second which is unaffected by more rows).
    dA1=norm(A1-oldA1,'fro')^2;
    dA2=norm(A2-oldA2,'fro')^2;
    prevJ=J(iter);
end

if iter==Niter
    disp('Factorization ended because max number of iterations was reached.')
end
if (abs(J(iter+1)-prevJ)<=prevJ*Etol)
    disp('Factorization converged to a local minimum within tolerance.');
end
if ((dA1+dA2)<=(norm(A1,'fro')^2+norm(A2,'fro')^2)*Ctol)
    disp('Factorization converged but cost was still changing. ')
end
    
figure
semilogy(J)

end

