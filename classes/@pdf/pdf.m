classdef pdf
    %pdf Summary of this class goes here

    %%
    properties
       pValues=[]; %Where the values of p(x) are stored
       coordinates=[]; %The coordinates of the points x where p is evaluated
       name=['Unnamed'];
    end
    %%
    properties(Dependent)
       supportRegionLimits
       dimension
    end
    %%
    properties(GetAccess=private, SetAccess=private)
        build=1;
    end
    
    %%
    methods
        %Constructor:
        function this=pdf(pValues,coordinates,name) %Constructor
            %INPUTS:
            %pValues an n-dimensional matrix which contains the density
            %evaluated in a given grid (grid must be rectangular)
            %Coordinates: a cell array of length n, with each cell
            %containing a vector which specifies the evaluation points of
            %the grid for a given dimension
            %Example: pdf(ones(5,10),{[1:5],[0:10:90]})
            %returns a uniform 2D distribution in the region given by
            %[1,5]x[10,90] (and zero outside that region).
            
            %Check that dimension of pValues coincides with length of
            %coordinates
            if nargin<2
                ME = MException('pdf:MissingArguments','Either the values or the coordinates are missing.');
                throw(ME);
            end
            n=ndims(pValues);
            if length(pValues)==numel(pValues)
                n=1;
            end
            if n~=length(coordinates)
                ME = MException('pdf:InconsistentArguments','The dimension of the pValues and coordinates are not consistent.');
                throw(ME);
            end
            
            %Check that it integrates to 1, if not, normalize
            if ~strcmp(this.name,'nonorm') && ~pdf.checkIntegration(pValues,coordinates) %Secret name 'nonorm' avoids normalization step, should never be used.
                warning('pdf:Constructor', ['Attempting to create pdf that integrates to ' num2str(pdf.fullIntegration(pValues,coordinates)) ', normalizing.'])
                pValues=pdf.normalize(pValues,coordinates);
            end
            if ~strcmp(this.name,'nonorm') && ~pdf.checkIntegration(pValues,coordinates)
                warning('Normalization did not work.')
            end
            
            %Assign properties
            if size(pValues,2)==numel(pValues) %Row vector
                pValues=pValues';
            end
            this.pValues=pValues;
            auxSize=size(pValues);
            for i=1:length(coordinates)
                if length(coordinates{i})==auxSize(i);
                    this.coordinates{i}=coordinates{i}(:);
                else
                    ME = MException('pdf:InconsistentArguments','The coordinate vectors do not have the same size as the provided pValues.');
                    throw(ME);
                end
            end
            if nargin>2 && isa(name,'char')
                this.name=name;
            end

        end
        
        %Dependent properties:
        function limits=get.supportRegionLimits(this)
           for i=1:length(this.coordinates)
               limits(1,i)=this.coordinates{i}(1);
               limits(2,i)=this.coordinates{i}(end);
           end
        end
        
        function dim=get.dimension(this)
            dim=length(this.coordinates);
        end
        
        %Useful properties/derived distributions:
        function alpha=getCumulativeProbability(this,X) %Gets the integrated value of the density from -inf to X(i) in each of the dimensions
            %Check length(X) is the same as length(this.coordinates)
            auxStr=[];
            auxStr2=[];
            for i=1:length(X)
                aaux= find((this.coordinates{i}-X(i))<=0,1,'last');
                if ~isempty(aaux)
                    ind(i)= aaux;
                else
                    ind(i)=0;
                end
                auxStr2=[auxStr2 '1:ind(' num2str(i) '),'];
                partialCoordinates{i}=this.coordinates{i}(1:ind(i));
            end
            eval(['partialCell=this.pValues(' auxStr2(1:end-1) ');']);
            alpha=pdf.fullIntegration(partialCell,partialCoordinates);
            %auxDist=pdf(partialCell,partialCoordinates,'nonorm');
            %alpha=auxDist.fullIntegration; %This is a first order (no interpolation) aproximation, which is always lower than the actual value
        end
        
        function X=getInvCDF(this,alpha) %Essentially the inverse of the previous function
            if this.dimension>1
                 error('High-dim pdfs are not supported yet.')
            else
                if abs(alpha-.5)>.5
                    error('Alpha value is not in the [0,1] interval.')
                else
                    [cdf,coordinates]=getCDF(this);
                    [~,i]=min(abs(cdf-alpha));
                    X=coordinates{1}(i);
                end
            end
        end
        
        [cdf,coordinates]=getCDF(this)
        
        marginalDensityDistr=getMarginalDistribution(this,dim,name) %Compute the marginal density distribution with respect to dimension dim. It returns a pdf object with one dimension less than the original object
        
        function condDistr=getConditionalDistribution(this,dim) %Essentially returns the same, but normalized across dimension dim so for each value along that dimension, you would have a probability distribution
            auxP=permute(this.pValues,[dim, 1:dim-1,dim+1:this.dimension]);
            sizeTmp=size(auxP);
            for i=1:length(this.coordinates{dim})
                if length(sizeTmp)>2
                    tmp=reshape(auxP(i,:),sizeTmp(2:end)); %This might not work properly if the resulting pdf is one-dimensional.
                else
                    tmp=squeeze(auxP(i,:)); %This works for the 1-D case.
                end
                condDistr{i}.pdf=pdf(tmp,this.coordinates([1:dim-1,dim+1:this.dimension])); 
                condDistr{i}.coordinate=this.coordinates{dim}(i);
            end
        end
        
        %Statistics:
        function mu=getMean(this)
            if this.dimension>1
                 error('High-dim pdfs are not supported yet.')
            else
                aux=this.pValues .* this.coordinates{1}(:);
                mu=pdf.fullIntegration(aux,this.coordinates);
            end
        end
        
        function sigma=getStddev(this)
           if this.dimension>1
                 error('High-dim pdfs are not supported yet.')
           else
                mu=this.getMean;
                aux=this.pValues .* (this.coordinates{1}(:)-mu).^2;
                sigma=sqrt(pdf.fullIntegration(aux,this.coordinates));
            end 
        end
        
        function nu=getMedian(this)
            if this.dimension>1
                error('High-dim pdfs are not supported yet.')
            else
                [cdf,coordinates]=this.getCDF;
                [~,j]=min((cdf-.5).^2);
                nu=coordinates{1}(j);
            end
        end
        
        function nu=getMode(this)
            if this.dimension>1
                error('High-dim pdfs are not supported yet.')
            else
                [~,j]=max(this.pValues);
                nu=this.coordinates{1}(j);
            end
        end
        
        function S=getEntropy(this) %Computes the differential entropy
            S=pdf.integrateWithRespectToPDF(-log2(this.pValues),this);
        end
        
        function S=getDiscreteEntropy(this) %Computes the entropy of the quantized distribution, assuming uniform sampling.
            S=getEntropy(this);
            for i=1:this.dimension
                S=S-log2(median(diff(this.coordinates{i})));
            end
        end
        
        function I=getMutualInfo(this,inds1) %computes mutual info of the variables refered on inds1, with respect to the remaining ones
              %S1=getEntropy(this);
              %pdf1=this.getMarginalDistribution(inds1); %Function only of the remaining variables variables
                I=NaN;
        end
        
        function samples=drawSample(this,N) %Draws a random sample of N elements from this distribution
            if this.dimension>1
                error('High-dim pdfs are not supported yet.')
            else
                R=rand(N);
                [cdf,coordinates]=this.getCDF;
                for i=1:N
                    [~,j]=min((cdf-R(i)).^2); %Essentially applying cdf^{-1} (x), where x ~U[0,1]
                    samples(i)=coordinates{1}(j);
                end
            end
        end
        

        %Modifications:
        function newDensityDistr=permute(this,newOrder)
            if length(newOrder)==this.dimension
                newP=permute(this.pValues,newOrder);
                newC=this.coordinates(newOrder);
                newDensityDistr=pdf(newP,newC);
            else
                throw(MException('pdf:permute','New order vector is not of length equal to pdf dimension.'))
            end
        end
        
        function newDensityDistr=squeeze(this)
            newC={};
            for i=1:this.dimension
                if length(this.coordinates{i})>1
                    newC{end+1}=this.coordinates{i};
                end
            end
            newP=squeeze(this.pValues);
            newDensityDistr=pdf(newP,newC);
        end
        
        newDensityDistr=smooth(this) 
        
        newDensityDistr=resample(this,newCoordinates)

        
        [newThis,delta]=resampleUniform(this,size) %Force uniform sampling with sample size = "size"


        %Simple math derived distributions:
        newDensity=sum(this,other,name) %returns de pdf of the sum of two variables with pdfs this & other
        
        newDensity=average(this,N) %Computes the pdf for an average of N iid samples drawn from this distribution
        
        newDensity=funct(this,functionName) %Computes the pdf for y=f(x), where f is the functionname given. f must be monotonic, and the syntax y=functionName(x) needs to work in Matlab.
        
        newDensity=log(this) %Special case of the function before, with functionName='log'
        
        newDensity=exp(this) %Special case of funct, with functionName='exp', is inverse of previous function
        
        newDensity=prod(this,other) %Computes the pdf of the product of two distributions, implemented as the exponential of the sum of the log variables
        
        %Approximation to continuous function:
        polyCoefs=approximateByPolinomial(this,tol) %only if dimension=1
        
        %Display:
        function [figHandle,axesHandles]=plot(this,figHandle,axesHandle,samples) %only if dim in {1,2}
            if nargin<2 || isempty(figHandle)
                figHandle=figure;
            else
                figure(figHandle);
            end
            if this.dimension==1
                if nargin>2 && ~isempty(axesHandle)
                    axes(axesHandle);
                else
                    axes;
                end
                hold on
                plot(this.coordinates{1},this.pValues,'r','LineWidth',2);
                axis([min(this.coordinates{1}) max(this.coordinates{1}) 0 1.1*max(this.pValues)])
                if nargin>3 && ~isempty(samples)
                   %
                   bins=length(samples)/2;
                   [h,c]=hist(samples,linspace(this.coordinates{1}(1),this.coordinates{1}(end),bins));
                   H=h/(sum(h)*median(diff(c)));
                   bar(c,H,1)
                   plot(samples,.01*max(this.pValues)*ones(size(samples)),'.','LineWidth',2','Color',[1,1,1]); 
                   axis([min(this.coordinates{1}) max(this.coordinates{1}) 0 1.1*max(H)])
                end
                hold off
            elseif this.dimension==2
                if nargin>2 && ~isempty(axesHandle)
                    axes(axesHandle);
                else
                    axes;
                end
                hold on
                surf(this.coordinates{1},this.coordinates{2},this.pValues','EdgeColor','none')
                view(2)
                axis tight
                if nargin>3 && ~isempty(samples)
                   plot3(samples(:,1),samples(:,2),2*max(this.pValues(:))*ones(size(samples(:,1))),'wx','LineWidth',2) 
                end
                hold off
            elseif this.dimension==3
                %Do three plots of the marginals distributions
                %warning('Dimensionality not currently supported (yet!). Not plotting.')
                axesHandles(1)=subplot(7,7,[1:3,8:10,15:17]);
                hold on
                title('Marginal distribution for dimensions 2 and 3')
                partialSamples=[];
                if nargin>3 && ~isempty(samples)
                   partialSamples=samples(:,[3,2]); 
                end
                this.getMarginalDistribution(1).permute([2,1]).plot(figHandle,axesHandles(1),partialSamples);
                %xlabel('Dim 3')
                ylabel('Dim 2')
                hold off
                axesHandles(2)=subplot(7,7,28+[1:3,8:10,15:17]);
                hold on
                %title('Marginal distribution for dimensions 1 and 3')
                partialSamples=[];
                if nargin>3 && ~isempty(samples)
                   partialSamples=samples(:,[3,1]); 
                end
                this.getMarginalDistribution(2).permute([2,1]).plot(figHandle,axesHandles(2),partialSamples);
                xlabel('Dim 3')
                ylabel('Dim 1')
                hold off
                axesHandles(3)=subplot(7,7,4+[1:3,8:10,15:17]);
                hold on
                title('Marginal distribution for dimensions 1 and 2')
                partialSamples=[];
                if nargin>3 && ~isempty(samples)
                   partialSamples=samples(:,1:2); 
                end
                this.getMarginalDistribution(3).plot(figHandle,axesHandles(3),partialSamples);
                %xlabel('Dim 1')
                %ylabel('Dim 2')
                hold off
                axesHandles(4)=subplot(7,7,[22:24]);
                hold on
                partialSamples=[];
                if nargin>3 && ~isempty(samples)
                   partialSamples=samples(:,3); 
                end
                this.getMarginalDistribution(1).getMarginalDistribution(1).plot(figHandle,axesHandles(4),partialSamples);
                hold off
                axesHandles(5)=subplot(7,7,[4,11,18]);
                hold on
                %aux=this.getMarginalDistribution(3).getMarginalDistribution(1);
                %plot(aux.pValues,aux.coordinates{1});
                partialSamples=[];
                if nargin>3 && ~isempty(samples)
                   partialSamples=samples(:,2); 
                end
                this.getMarginalDistribution(3).getMarginalDistribution(1).plot(figHandle,axesHandles(5),partialSamples);
                %plot(.1*max(aux.pValues)*ones(size(partialSamples)),partialSamples,'x','LineWidth',2','Color',[0,0,0]);
                view(-90,90)
                hold off
                axesHandles(6)=subplot(7,7,4+[22:24]);
                xlabel('Dim 1')
                hold on
                partialSamples=[];
                if nargin>3 && ~isempty(samples)
                   partialSamples=samples(:,1); 
                end
                this.getMarginalDistribution(3).getMarginalDistribution(2).plot(figHandle,axesHandles(6),partialSamples);
                hold off
            else
                warning('Dimensionality too high. Cannot plot.')
            end
        end
        %display(this) %only if dim=1

    end
    
    %% Useful methods that should never be used by end-user
    methods(Access=private, Static)
        
        function integral=fullIntegration(pValues,coordinates)
            newP=pValues;
            newC=coordinates;
            for i=length(coordinates):-1:2
                [newP,newC]=pdf.getMarginalValues(newP,newC,i);
            end
            if length(newC{1})==1
                integral=0;
            else
                integral=trapz(newC{1},newP);
            end
        end
        
        function newP=normalize(pValues,coordinates)
            newP=pValues/pdf.fullIntegration(pValues,coordinates);
        end
        
        function isSane=checkIntegration(pValues,coordinates)
            isSane = abs(pdf.fullIntegration(pValues,coordinates)-1)<.00001; %0.001% errror in normalization tolerated
        end
        
        function [newP,newC]=getMarginalValues(pValues,coordinates,dim)
            dimension=length(coordinates);
            if length(coordinates{dim})>1
                newP=trapz(coordinates{dim},permute(pValues,[dim,1:dim-1,dim+1:dimension]));
                auxS=size(pValues);
                newP=reshape(newP,[auxS(1:dim-1),1,auxS(dim+1:dimension)]);
            else
                newP=pValues;
            end
            newC=coordinates;
            if dim==dimension %This is necessary because if the trailing dimension is singleton (case in which we are marginalizing on the last dimension) matlab forces newP to have dim-1 (i.e. a MxNx1 matrix is just a n MxN matrix)
                newC=newC(1:dim-1);
            else
                newC{dim}=0;
            end
            %newC=coordinates([1:dim-1,dim+1:end]);
        end
        
        function newP=getSummedpValues(pValues1,pValues2,delta)
            %This assumes uniform and equal spacing of samples for pValues1
            %and 2
            newP=prod(delta)*convn(pValues1,pValues2,'full'); %This is pretty efficient as is!
        end

        function S=entropy(pValues,coordinates) %Computes the entropy
           aux=pValues;
           v=-aux.*log2(aux);
           v(aux==0)=0; %Avoids NaNs
           S=pdf.fullIntegration(v,coordinates);
        end
    end
    
    %% 
    methods(Static)
        %Alternative constructions from sample data:
       function newDist=kernelEstimation(sampleCoordinates,evalCoord)
            %sampleCoordinates should be a N x M matrix, where the lesser
            %of [M,N] represents the dimensionality of the data.
            if size(sampleCoordinates,2)<size(sampleCoordinates,1)
                sampleCoordinates=sampleCoordinates.';
            end
             if nargin<2
                for i=1:size(sampleCoordinates,1)
                    N=1024;
                    range=max(sampleCoordinates(i,:))-min(sampleCoordinates(i,:));
                    evalCoord{i}=min(sampleCoordinates(i,:)):range/(N-1):max(sampleCoordinates(i,:));
                end
            end
            %[p,xmesh,~]=densityEstimation(sampleCoordinates,evalCoord,[]);
            %p=abs(p); %This correction is necessary because the external kde function returns some high-freq oscillations (I guess because of a 'real(fft)' that is in the code, when the result should be real before taking the real part). This oscillations are small, so it is no problem to take abs()
            weights=1./max(abs(sampleCoordinates')); %This weights distances by their relative factor to the biggest possible value of the variable. Another option would be weights equal to std.
            %weights=1./std(sampleCoordinates');
            %p=ksdensityn(sampleCoordinates,evalCoord,'varconv',[],weights);
            p=ksdensityn(sampleCoordinates,evalCoord,'conv');
            newDist=pdf(p,evalCoord);
       end
        
       %newDist=histEstimation(sampleCoordinates,evalCoord);
       
       function newDist=unimodalEstimation(sampleCoordinates,evalCoord); %This would be
       %something like a MLE with a regularization term to avoid a spiky
       %solution. The regularization term might be in terms of distribution
       %entropy, power spectrum or some condition on the derivatives (TBD).
       if length(evalCoord)>1
            error('High-dim prob. densities not yet supported');
       else
           aux=diff(evalCoord{1});
           aux2=(.5*[aux;0]+.5*[0;aux])';
           aux3=.5*aux(1:end-1)+.5*aux(2:end);
            p0=ones(length(evalCoord{1}),1)/sum(aux);
            alpha=.004;
            N=length(sampleCoordinates);
            Maux=zeros(N,length(p0));
            for i=1:length(sampleCoordinates)
                aa=find((sampleCoordinates(i)-evalCoord{1})>0,1,'last');
                Maux(i,aa)= (sampleCoordinates(i)-evalCoord{1}(aa))./(evalCoord{1}(aa+1)-evalCoord{1}(aa));
                Maux(i,aa+1)= 1-Maux(i,aa);
            end
           p=fmincon(@(p) -prod((Maux*p).^(1/N))+alpha*pdf.entropy(p,evalCoord),p0,[],[],aux2,1,zeros(size(p0)),[]);
       end
       newDist=pdf(p,evalCoord);
       end
       
       function [newDist]=empiricPDF(sample)
           %[cdf,coordinates]=pdf.empiricCDF(sample);
            %p=diff(cdf)'./diff(coordinates{1});
            
            [p,c]=hist(sample,round(length(sample)/100));
            newDist=pdf(p',{c'}); %Middle point assignments       
       end
       
       %Others
       function [cdf,coordinates]=empiricCDF(sample)
          N=size(sample,1);
          if size(sample,2)>1
              error('High-dim samples not yet supported.')
          else
              coordinates{1}=[min(sample)-.1;sort(sample,'ascend')];
              cdf=[0:N]/N;
          end
       end
       
       function D=DKL(pdf1,pdf2) %Computes the Kullbach-Leibler divergence
           flag=false;
           for i=1:pdf1.dimension
                flag=flag || any(pdf1.coordinates{i}~=pdf2.coordinates{i})
           end
           if flag
               throw(MException('pdf:DKL','Given pdfs are not sampled in the same space. Cannot compute.'));
           end
           aux=pdf1.pValues;
           aux(aux==0)=eps;
           aux2=pdf2.pValues;
           aux2(aux2==0)=eps;
           v=aux.*log2(aux.*aux2);
           v(aux==0);
           D=pdf.fullIntegration(v,pdf1.coordinates);
       end
       
       function newDist=product(pdf1,pdf2)
           %...TO DO

       end
       
       function newF=integrateWithRespectToPDF(f,pdf1)
           if any(size(pdf1.pValues) ~= size(f))
               throw(MException('integrateWithRespectToPDF::InconsistentArguments','Provided arguments have to be of equal sizes.'))
           end
           v=pdf1.pValues.*f;
           v(pdf1.pValues==0)=0; %Avoiding indeterminacies.
           newF=pdf.fullIntegration(v,pdf1.coordinates);
       end
    end
    
end

