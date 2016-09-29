classdef parametricDistribution<probabilityDistribution
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parameters
        isParametric=true;
        isEmpiric=false;
    end
    properties(Hidden)
       PDF_ %Should be defined as a functional form with respect to parameters 
    end
    
    methods
       samplePDF(sampleGrid)
       castAsEmpiric(sampleGrid) 
    end
    
end

