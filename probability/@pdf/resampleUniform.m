function [newThis,delta]=resampleUniform(this,size) %Force uniform sampling with sample size = "size"
            if nargin<2 || isempty(size) %Resample to minimum interval in current coordinates
                for i=1:length(this.coordinates)
                min1(i)=min(this.coordinates{i});
                max1(i)=max(this.coordinates{i});
                range(i)=max1(i)-min1(i);
                delta(i)=min(diff(this.coordinates{i}));
                delta(i)=range(i)/round(range(i)/delta);
                end
            else
                for i=1:length(this.coordinates)
                    min1(i)=min(this.coordinates{i});
                    max1(i)=max(this.coordinates{i});
                    range(i)=max1(i)-min1(i);
                    delta(i)=range(i)/(N-1);
                end
            end
            for i=1:length(this.coordinates)
                newThisCoordinates{i}=min1(i):delta(i):max1(i);
            end
            newThis=this.resample(newThisCoordinates); 
        end

