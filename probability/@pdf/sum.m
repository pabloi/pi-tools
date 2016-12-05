function newDensity=sum(this,other,name) %returns de pdf of the sum of two variables with pdfs this & other
            [newThis,delta]=this.resampleUniform; %Force uniform sampling
            newOther=other.resampleUniform(delta); %Force uniform sampling
            if nargin<3 || isempty(name)
                name=['Sum of ' this.name '_' other.name];
            end
            newP=getSummedpValues(newThis.pValues,newOther.pValues,delta);
            newDensity=pdf(newP,newSumCoordinates,name); 
        end

