classdef probabilityDistribution
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dimension
        mean
        cov
        std
        entropy
        isConditional
        isEmpiric
        isParametric
    end
    
    methods
        function this=probabilityDistribution()
            
        end
        getMoment(dim,order)
        getPDF(sampleGrid)
        getCDF(sampleGrid)
        getMutualInfo(dim1,dim2)
        marginalize(dim)
        drawSample(N)
    end
    
    methods(Static)
       newThis=getDistributionOfVariableSum(this,other)
       newThis=getDistributionOfVariableProduct(this,other)
       
    end
    
end

