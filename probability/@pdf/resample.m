function newDensityDistr=resample(this,newCoordinates)
            coordString=[''];
            newCoordString=[''];
            for i=1:length(this.coordinates);
                coordString=[coordString, 'this.coordinates{' num2str(i) '},'];
                newCoordString=[newCoordString, 'newCoordinates{' num2str(i) '},'];
            end
            eval(['newPvalues=interpn(' coordString 'this.pValues,' newCoordString '''linear'',0);']);
            newDensityDistr=pdf(newPvalues(:),newCoordinates,this.name);
        end
