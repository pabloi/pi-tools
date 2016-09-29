classdef probabilityFunction
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dimension
        mean
        cov
        std
        entropy
        
    end
    
    methods
        function this=probabilityDistribution()
            
        end
        getMoment(dim,order)
        getPDF(sampleGrid)
        getCDF(sampleGrid)
        getMutualInfo(dim1,dim2)
        marginalize(dim)
    end
    
    methods(Static)
        get 
    end
    
end

