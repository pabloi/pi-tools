function marginalDensityDistr=getMarginalDistribution(this,dim,name) %Compute the marginal density distribution with respect to dimension dim. It returns a pdf object with one dimension less than the original object
            newP=this.pValues;
            newC=this.coordinates;
            for i=1:length(dim) %Not sure this will work, need to test. The idea is that we can give many dimensions to marginalize over at once. 
            [newP,newC]=pdf.getMarginalValues(newP,newC,dim(i));
            end
            newP=squeeze(newP);
            if size(newP,2)==numel(newP) %Row vectors are not squeezed
                newP=newP';
            end
            newC=newC([1:dim-1,dim+1:this.dimension]);
            if nargin<3 || isempty(name)
                name=['Marginal ' this.name ' dim ' num2str(dim)];
            end
            marginalDensityDistr=pdf(newP,newC,name);
        end

