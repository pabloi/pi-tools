classdef cdf
    %cdf Summary of this class goes here

    %%
    properties
       FValues=[]; %Where the values of F(x) are stored
       coordinates=[]; %The coordinates of the points x where p is evaluated
       name=['Unnamed'];
    end
    %%
    properties(Dependent)
       supportRegionLimits
       dimension
    end

    %%
    methods
        %Constructor:
        function this=cdf(FValues,coordinates,name) %Constructor
            %INPUTS:
            %FValues an n-dimensional matrix which contains the cdf
            %evaluated in a given grid (grid must be rectangular)
            %Coordinates: a cell array of length n, with each cell
            %containing a vector which specifies the evaluation points of
            %the grid for a given dimension
            %Example: cdf([1:5]/5'*[0:10:90]/90,{[1:5],[0:10:90]})
            %returns the cdf of a uniform 2D distribution in the region given by
            %[1,5]x[10,90].
            
            %Check that dimension of FValues coincides with length of
            %coordinates
            if nargin<2
                ME = MException('cdf:MissingArguments','Either the values or the coordinates are missing.');
                throw(ME);
            end
            n=ndims(FValues);
            if length(FValues)==numel(FValues)
                n=1;
            end
            if n~=length(coordinates)
                ME = MException('cdf:InconsistentArguments','The dimension of the FValues and coordinates are not consistent.');
                throw(ME);
            end
            
            %Check that it is strictly non-decreasing
            
            %Check that min is 0 and max is 1, or force it to.
            

            
            %Assign properties
            this.FValues=FValues;
            auxSize=size(FValues);
            for i=1:length(coordinates)
                if length(coordinates{i})==auxSize(i);
                    this.coordinates{i}=coordinates{i}(:);
                else
                    ME = MException('cdf:InconsistentArguments','The coordinate vectors do not have the same size as the provided FValues.');
                    throw(ME);
                end
            end
            if nargin>2 && isa(name,'char')
                this.name=name;
            end

        end
        
        %Derive pdf from this cdf
        pdf=getPDF(this)
        
        
    end
