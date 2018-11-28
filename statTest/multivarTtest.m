function [pValue,stat] = multivarTtest(v,S,dof)
%Computes the p-value of observing the statistic v'*inv(S)*v,
%under the distribution v ~ N(0,Sigma), and S ~ Wishart(Sigma,dof),
%assuming v,S are independent. The statistic is then distributed as
%Hotelling's T^2(p,dof)/dof. This is a multivariate extension of a
%two-tailed one-sample t-test.
%If dof is not given, the presumption is dof -> infinity (i.e. Sigma is
%known exactly). Then the statistics is distributed as chi^2(p)
%
%See Härdle and Simar, Applied Multivariate Statistical Analysis, 2nd Ed.,
%Springer. Theorem 5.8

stat=v'*inv(S)*v;
p=length(v);
if nargin<3 || isempty(dof)
    pValue=chi2cdf(stat,p);
else
    pValue=fcdf((dof+1-p)*stat/(dof*p),p,dof+1-p);
end

end

