function newDensity=average(this,N) %Computes the pdf for an average of N iid samples drawn from this distribution

            %Force uniform sampling
            [newThis,delta]=this.resampleUniform;
            
            %Way 1: iterate sum of this and this
            newP=newThis.pValues;
            for i=1:N-1
                newP=pdf.getSummedpValues(newP,newThis.pValues,delta);
                newP=2*newP(1:2:end); %Works only for dim=1 distributions!
            end
            newDensity=pdf(newP,this.coordinates,['Avg of ' num2str(N) ' ' this.name ' iid vars.']);
            
            %Way 2: more efficient fourier-space computation
            %newP=ifftn(fftn(newThis.pValues).^N);
            %newDensity=pdf(prod(delta)^(N-1)*newP,newThis.coordinates,['Avg of ' num2str(N) ' ' this.name ' iid vars.']);
        end

