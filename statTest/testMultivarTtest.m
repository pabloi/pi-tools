% Testing 2D CI:
%
N=1e2; %Number of samples
mu=[3;1];
cholSigma=[sqrt(2) 0; 1/sqrt(2) .5];
Sigma=cholSigma*cholSigma';
%
%% Draw samples:
Nsamp=2e4;
p1=nan(Nsamp,1);
p2=nan(Nsamp,1);
for i=1:Nsamp
    X=mu+cholSigma*randn(2,N);
    S=cov(X')/N;
    c=mean(X,2);
    p1(i)=multivarTtest(c-mu,S,N-1); %Computing p-values of true mean under the 
    %sample mean, cov distribution, should be uniformly distributed if correct
    p2(i)=multivarTtest(c-mu,Sigma/N); %p-val of sample mean under true dist
end
figure;
histogram(p1,'BinEdges',0:.05:1,'Normalization','pdf','EdgeColor','none')
hold on
histogram(p2,'BinEdges',0:.05:1,'Normalization','pdf','EdgeColor','none')

%% Plot one sample's result:
figure; hold on;
plot(mu(1),mu(2),'x','DisplayName','True mean')
plot(c(1), c(2),'o','DisplayName','Sample mean');

%Draw the ellipse that represents the 95% CI of the sample mean given the
%known distribution parameters
eh=drawEllipse2D(inv(chi2inv(.95,2)*Sigma/N),mu);
eh.DisplayName='Sample mean 95% CI'; 

%Draw the confidence interval for the estimate of the true mean given the
%observed sample:
eh=draw2Dci(c,cov(X')/N,.95,N-1);
eh.DisplayName='95% CI for the true mean';
legend

%%
