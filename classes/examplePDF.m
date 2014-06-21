%example script for the DensityDistribution class

%% Example 1: 1D distribution
this=DensityDistribution(ones(100,1),{[1:100]}); %Constructor
alpha=this.getCumulativeProbability(5) %Gets the integrated value of the density from -inf to X(i) in each of the dimensions
%X=getAlphaThreshold(this,alpha); %Essentially the inverse of the previous function
%marginalDensityDistr=getMarginalDistribution(this,dim) %Compute the marginal density distribution with respect to dimension dim. It returns a DensityDistribution object with one dimension less than the original object
limits=this.supportRegionLimits
dim=this.dimension
this.plot
%        newDensityDistr=smooth(this)
%        newDensityDistr=resample(this,newCoordinates)
%        polyCoefs=approximateByPolinomial(this,tol) %only if dimension=1
%        figHandle=plot(this) %only if dim in {1,2}
%        display(this) %only if dim=1

%% Example 1: 2D distribution
this=DensityDistribution(ones(101,1)*exp(-([0:100]-50).^2/200),{[0:100],[0:100]}); %Constructor
alpha=this.getCumulativeProbability([5,30]) %Gets the integrated value of the density from -inf to X(i) in each of the dimensions
%X=getAlphaThreshold(this,alpha); %Essentially the inverse of the previous function
marginalDensityDistr=this.getMarginalDistribution(2); %Compute the marginal density distribution with respect to dimension dim. It returns a DensityDistribution object with one dimension less than the original object
limits=this.supportRegionLimits
dim=this.dimension
this.plot
marginalDensityDistr.plot
%        newDensityDistr=smooth(this)
%        newDensityDistr=resample(this,newCoordinates)
%        polyCoefs=approximateByPolinomial(this,tol) %only if dimension=1
%        figHandle=plot(this) %only if dim in {1,2}
%        display(this) %only if dim=1