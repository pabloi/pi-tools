function [cdf,coordinates]=getCDF(this)
           if length(this.coordinates)>1
               error('High-dim CDFs not supported yet');
           else
               %Inefficient but elegant way:
               %for i=1:length(this.coordinates{1})
               %    cdf(i,1)=this.getCumulativeProbability(this.coordinates{1}(i));
               %end
               %Efficient way:
               cdf=zeros(size(this.pValues));
               cdf(2:end)=cumsum(diff(this.coordinates{1}).*(this.pValues(1:end-1)+.5*diff(this.pValues))); %Similar to trapz
               cdf=cdf/cdf(end); %Forcing 1 as exactly the max value
           end
           coordinates=this.coordinates;
        end
