function [w] = columnNorm(X,p)
%Calculates the p-norm of each column in a matrix (along first dimension)
%and returns it as a row vector.

w = sum(X.^p,1).^(1/p);

end

