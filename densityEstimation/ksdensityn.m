function [p] = ksdensityn(data,binsC,method,bandwidth,weights,k)
%ksdensityn estimates a probability density from data points in
%data. Estimation is done by convolving with a gaussian kernel.

%INPUTS:
%'data' need not be uni-dimensional. Estimated probability will have
%dimension equal to the number of columns in the data matrix.
%'binsC' specifies the centers of the points in which the probability density
%is to be sampled (has to be a uniform grid). Bins is a cell array such that bins{i} = vector of
%desired centers in the i-th dimension.
%'bandwidth' is the n x n matrix that determines the covariance matrix for the kernel (where n is the dimension of the data, or its number of columns). If not
%given, it will be taken to be (4/(d+2))^(1/(d+4))*n^(-1/(d+4))*M, donde M es la matriz de covarianza de los datos (Thanks Wikipedia!)

%Check:
if size(data,1)<=size(data,2)
    data=data';
end

d=size(data,2); %Dimension of data (<3)
n=size(data,1); %Number of observations

%Do standardization of samples along all dimensions before applying any
%kernel technique
 for i=1:length(binsC)
     mu(i)=mean(data(:,i));
     stddev(i)=std(data(:,i));
     data(:,i)=(data(:,i)-mu(i))/stddev(i);
     binsC{i}=(binsC{i}-mu(i))/stddev(i);
 end

M=cov(data); %Covariance matrix, with standardized data should be identity
grid=[];

if nargin<3 || isempty(method)
%Method choice: fft is more efficient, but slightly less precise.
method='fft';
%method='conv';
end

if nargin<4 || isempty(bandwidth)
    bandwidth=1; %No correlations
end
%kernel=bandwidth*(4/(d+2))^(2/(d+4))*n^(-2/(d+4))*M;
kernel=bandwidth*(4/(d+2))^(2/(d+4))*n^(-2/(d+4))*diag(diag(M));


if nargin<5 || isempty(weights)
   weights=ones(1,d); 
else
    if any(size(weights)~=[1,d])
        if all(size(weights)==[d,1])
            weights=weights';
        else
            throw(MException('kdensityn:weights','Size of weight vector is inappropriate for given data: it should be [1,d], where d==size(data,2).'))
        end
    end
end

if nargin<6 || isempty(k)
    k=5;
end




if d==1
    p=ksdensity(data,binsC);
%elseif d==2
%    p=ksdensity2(data,binsC,bandwidth);
else %d>2
    aux=[];
    aux2=[];
    aux3=[];
    for i=1:d
        aux=[aux, '1,'];
        T(i)=length(binsC{i});
        aux2=[aux2 'T(' num2str(i) '),']; %This will fail when dim>9
        aux3=[aux3 ':,'];
    end
    for i=1:d
        str=['binsC{i}=reshape(binsC{i},' aux(1:2*i-2) 'T(i)' aux(2*i:end-1) ');'];
        eval(str); %Make sure vectors are in the correct dimension
    end
    str=['grid=zeros(' aux2(1:end-1) ',d);'];
    eval(str);
    str=['counter=zeros(size(grid(' aux3 '1)));'];
    eval(str);
    
    %#############################################################################
    if strcmp(method,'conv') %Direct method: actually do the convolution    
        
        for i=1:d
            str=['grid(' aux3 'i)=repmat(binsC{i},[' aux2(1:5*i-5) '1,' aux2(5*i+1:end-1) ']);'];
            eval(str);
        end
        coord=reshape(grid,prod(T),d);
        
        for i=1:n
            newCoord=(coord'-repmat(data(i,:)',1,prod(T)));
            convKernel=1/sqrt(det(kernel)) * exp(-sum(newCoord'.*(kernel\newCoord)',2));
            str=['convKernel=reshape(convKernel,' aux2(1:end-1) ');'];
            eval(str);
            counter=counter+convKernel;
        end
        p=counter;
    
    %#############################################################################
    elseif strcmp(method,'varconv') %Convolution with variable kernel: the kernel is of different SIZE for each sample
        
        for i=1:d
            str=['grid(' aux3 'i)=repmat(binsC{i},[' aux2(1:5*i-5) '1,' aux2(5*i+1:end-1) ']);'];
            eval(str);
        end
        coord=reshape(grid,prod(T),d);
        
        for i=1:n
            auxData=data'-repmat(data(i,:)',1,size(data,1));
            dataDistance=sum((repmat(weights',1,size(data,1)).*(auxData)).^2,1);
            [~,idx]=sort(dataDistance,'ascend');
            newCov=n*diag(diag(cov(auxData(:,idx(1:k))')))/k; %Covariance matrix of the k-nearest neighbours of the given sample.
            %newCov=norm(auxData(:,idx(k)))*eye(d); %Taking just the k-th nearest neighbour distance
            kernel= bandwidth*(4/(d+2))^(2/(d+4))*n^(-2/(d+4))*newCov; %Computing local kernel.
            newCoord=(coord'-repmat(data(i,:)',1,prod(T)));
            convKernel=1/sqrt(det(kernel)) * exp(-sum(newCoord'.*(kernel\newCoord)',2));
            str=['convKernel=reshape(convKernel,' aux2(1:end-1) ');'];
            eval(str);
            counter=counter+convKernel;
        end
        p=counter;
            %#############################################################################
    elseif strcmp(method,'varshapeconv') %Convolution with variable kernel: the kernel is of different shape & size for each sample
        
        for i=1:d
            str=['grid(' aux3 'i)=repmat(binsC{i},[' aux2(1:5*i-5) '1,' aux2(5*i+1:end-1) ']);'];
            eval(str);
        end
        coord=reshape(grid,prod(T),d);
        
        for i=1:n
            auxData=data'-repmat(data(i,:)',1,size(data,1));
            dataDistance=sum((repmat(weights',1,size(data,1)).*(auxData)).^2,1);
            [~,idx]=sort(dataDistance,'ascend');
            newCov=(n/k)*cov(auxData(:,idx(1:k))');%/diag(diag(cov(auxData(:,idx(1:k))'))); %Matrix with unity eigenvalues, just gives shape
            kernel= bandwidth*(4/(d+2))^(2/(d+4))*n^(-2/(d+4))*newCov; %Computing local kernel.
            newCoord=(coord'-repmat(data(i,:)',1,prod(T)));
            convKernel=1/sqrt(det(kernel)) * exp(-sum(newCoord'.*(kernel\newCoord)',2));
            str=['convKernel=reshape(convKernel,' aux2(1:end-1) ');'];
            eval(str);
            counter=counter+convKernel;
        end
        p=counter;
    %##################################################################################
    elseif strcmp(method,'fft') %Indirect: do it in Fourier space, and rounding some stuff
         str=['counter=zeros(size(grid(' aux3 '1)));'];
         eval(str);
         for i=1:n %Designate each data sample to a bin in the quantized probability dist (histogram)
             str2=[];
             for j=1:d
                 [~,v]=min(abs(binsC{j}-data(i,j)));
                 str2=[str2 num2str(v) ','];
             end
             str=['counter(' str2(1:end-1) ')=counter(' str2(1:end-1) ')+1;'];
             eval(str);
         end
         for i=1:d
             str=['grid(' aux3 'i)=repmat(binsC{i}-mean(binsC{i}),[' aux2(1:5*i-5) '1,' aux2(5*i+1:end-1) ']);'];
             eval(str)
         end
         coord=reshape(grid,prod(T),d);
         convKernel=1/sqrt(det(kernel)) * exp(-sum(coord.*(kernel\coord')',2));
         str=['convKernel=reshape(convKernel,' aux2(1:end-1) ');'];
         eval(str);
         convKernel=fftshift(convKernel);
         p=real(ifftn(fftn(counter).*fftn(convKernel))); %Avoid numerical errors that give rise to small imaginary parts
         p(p<0)=0; %Avoid numerical errors that give rise to small negative real parts
    end
    %Normalization:
    p=p/sum(p(:));
end

end

