function firstCross=robustRateEstimation(y1)
%Implements a simple estimation of rate under the assumption that the data
%comes from a single-rate decaying exponential.
%It exploits the fact that y(t)-y(t1) ~ exp(-(t-t1)/tau) * (y(inf)-y(t1))
%So, if we know y(inf), we can get tau

y=monoLS(y1,2,3,1); %Monotonic approximation
threshold=1-exp(-1);
yinf=y(end);
firstCross=nan(size(y));
for i=1:numel(y)
    GAP=y(i)-yinf;
    aux=find((-(y(i:end)-y(i))/GAP)>threshold,1,'first')
    if ~isempty(aux) && y(aux)~=y(end)
        firstCross(i)=aux-1;
    end
end

figure
subplot(2,1,1)
hold on
plot(y)
plot(y1,'.')
subplot(2,1,2)
plot(firstCross)


%TODO:
%Iterate improving the yinf estimate once tau is estimated, to remove bias
%Find 63% point between any two points, and invert the tanh function that
%results to get an estimate of tau
%Test with dual rate systems
%Optimize the threshold that should be used (probably depends on SNR)
%use monoLS before rate estimation to reduce/remove noise
%Interpolate between samples to allow for non-integer estimates
%Weighted average of results, assuming exponential decay of signal and
%constant/fixed noise levels