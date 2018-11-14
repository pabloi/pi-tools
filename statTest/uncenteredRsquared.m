function [Rsquared] = uncenteredRsquared(lm)
%Computes the uncentered R-squared for linear models (Matlab's default is
%to compute the centered version only, which is fine only if the model contains
%an intercept)

data=lm.Variables(:,end).Variables;
N=length(data);
SSE=sum((lm.Residuals.Raw).^2); %Same as Matlab
SSR=sum((lm.Fitted-mean(data)).^2); %Same as Matlab: matlab does this regardless of whether an intercept is present to explain the mean of the data!
SST=sum((data-mean(data)).^2);%Centered value. Matlab computes this by assumming SST=SSE+SSR, which is not true if the model lacks an interecept
SSR2=sum((lm.Fitted).^2);
SST2=sum(data.^2); %Uncentered value: This DOES satisfy SSE+SSR2=SST2, ALWAYS


Rsquared.centered=1-SSE/SST; %This can be negative when the model does not include an intercept (which is the use case of this function!)
Rsquared.adjusted=1-(SSE/SST)*((N-1)/lm.DFE); %N-1 dof for the SST since we are taking out the mean, which kills 1 dof
Rsquared.uncentered=1-SSE/SST2;
Rsquared.uncenteredAdj=1-(SSE/SST2)*(N/lm.DFE); %N dof

%Check:
if abs(lm.Rsquared.Ordinary-(SSR/(SSR+SSE)))>100*eps
    if isempty(lm.Robust)
        error('Centered R^2 values don''t match') 
    end
end

end

