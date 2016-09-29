classdef empiricDistribution
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        isParametric=false;
        isEmpiric=true;
    end
    properties(Hidden)
        PDF_ %Empiric distributions are defined by their PDF
    end
    
    methods
    end
    methods(Static)
        estimateFromSample(samples)
    end
end

