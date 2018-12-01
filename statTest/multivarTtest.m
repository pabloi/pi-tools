function [pValue,stat] = multivarTtest(v,S,dof)
%Computes the p-value (probability of observing an equal or larger value) 
%of the statistic v'*inv(S)*v, under the distribution v ~ N(0,Sigma), and 
%S ~ Wishart(Sigma,dof), assuming v,S are independent. 
%The statistic is then distributed as Hotelling's T^2(p,dof)/dof. 
%This is a multivariate extension of a two-tailed one-sample t-test.
%If dof is not given, the presumption is dof -> infinity (i.e. Sigma is
%known exactly). Then the statistics is distributed as chi^2(p)
%
%Example 1: assume we have a matrix X (n x p) where each row represents an
%p-dimensional observation, and we wish to compute the p-value of the observed sample
%mean under the null-hypothesis that the true mean is 0. Define v=mean(X),
%S=cov(X)/n (covariance of the sample mean, an extension of the standard
%error of the mean). Then pVal=multivarTtest(v,S,n-1) is the solution.
%
%Example 2: assume two samples X and Y as before, v1=mean(X), v2=mean(Y),
%S1=cov(X), S2=cov(Y), and nx=size(X,1), ny=size(Y,1). Suppose we want to
%test whether the means are different across the two samples. 
%NOTE TO SELF: there does not appear to be an exact solution to this
%problem, as the sum of two matrices with different Wishart distributions
%does not result in a Wishart distribution, and thus the statistic is not
%distributed as T^2 or chi^2.
%If we assume (or know) nx and ny large (or the covariances S1 and S2 are 
%known exactly), then we can simply do: pVal=multivarTtest(v1-v2,S1/nx +S2/ny,[])
%See Härdle and Simar, p.189
%Alternatively, we can assume that the covariances are the same accross the
%two populations. Then, we can define the pooled sample covariance 
%S= ((nx-1)*S1+(ny-1)*S2)/(nx+ny-2). Then:
%pVal=multivarTtest(v1-v2,S*(nx+ny)/(nx*ny),nx+ny-2)
%See Härdle and Simar, p.185 and Anderson, pp. 179-180
%
%References:
%Härdle and Simar, Applied Multivariate Statistical Analysis, 2nd Ed.,
%Springer. Theorem 5.8, and Section 7.2 (pp. 185-189)
%
%Anderson, Introduction to Multivariate Statistics, 3rd. Ed., Wiley.
%Section 5.3.4 (pp. 179-180)
%
% Pablo A. Iturralde - piturralde at ieee dot org - Nov 27th 2018

stat=v'*inv(S)*v;
p=length(v);
if nargin<3 || isempty(dof)
    pValue=chi2cdf(stat,p,'upper'); %computing prob. of tail
else
    pValue=1-fcdf((dof+1-p)*stat/(dof*p),p,dof+1-p);
end

end

