function eh=draw2Dci(c,M,prc,Mdof)
%Draws a 2D ellipse representing the prc(%) CI of a multivariate random
%variable x when x ~ N(c,Sigma) and M ~ W(Sigma,Mdof). If Mdof is not
%given, it is assumed to be infinity so M=Sigma (Sigma known). The ellipse 
%takes the form (x-c)'*inv(M)*(x-c) = threshold, where the threshold is
%determined using the critical value of the appropriate distribution.
%Example: suppose we have a matrix X (n x p), where each row was drawn
%independently from a normal distribution with mean mu and covariance Sigma
%We can then estimate the sample mean as c=mean(X,1), with M=cov(X)/n
%representing the standard error of the mean. Then, T= (x-c)'*inv(M)*(x-c) 
%is distributed as Hotelling's T^2 with p and n-1 degrees of freedom.
%Calling draw2Dci(c,M,.95,n-1) will draw the 95% CI for the sample mean.
%
%TODO: If simultFlag is set, draw instead the region that guarantees 
%prc (%) CI for any 1D projection of the distribution.
%
%See T.W. Anderson, An Introduction to Multivariate Statistics, 3rd Ed., Wiley
%Sections 5.3.2 and 5.3.3
%
%INPUTS:
%c: mean of the distribution
%M: covariance matrix of the distribution
%prc: percentile for the confidence interval
%Mdof: (optional) degrees of freedom of the covariance matrix provided. If
%not given, the assumption is that the covariance matrix is known exactly
%(Mdof -> infinity)
%
%OUTPUTS:
%
% Pablo A. Iturralde - piturralde at ieee dot org - Nov 27th 2018


%Determine critical value at level prc for the quantity (x-c)'*inv(M)*(x-c)
%If M is known exactly, this is distributed as chi^2_p, where p=size(M,1)
%Otherwise, it is distributed as Hotelling's T^2 with p,Mdof degrees of freedom
p=size(M,1);
if nargin<4 || isempty(Mdof) %No degrees of freedom given, assuming covariance is known exactly
    gamma = chi2inv(prc,p);
else
    gamma = (Mdof*p/(Mdof+1-p))*finv(prc,p,Mdof+1-p);
end

eh=drawEllipse2D(inv(M)/gamma,c);
end