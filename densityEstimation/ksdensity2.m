function [p] = ksdensity2(data,binsC,bandwidth)
%ksdensity2 estimates a probaiblity density from 2-D data points in
%data. Estimation is done by convolving with a gaussian kernel.

%INPUTS:
%'data' need not be uni-dimensional. Estimated probability will have
%dimension equal to the number of columns in the data matrix (currently it is only supported up to 2).
%'binsC' specifies the centers of the points in which the probability density
%is to be sampled (HAS to be a uniform rectangular grid). Bins is a cell array such that bins{i} = vector of
%desired centers in the i-th dimension.
%'bandwidth' is the n x n matrix that determines the covariance matrix for the kernel (where n is the dimension of the data, or its number of columns). If not
%given, it will be taken to be (4/(d+2))^(1/(d+4))*n^(-1/(d+4))*M, donde M es la matriz de covarianza de los datos (Thanks Wikipedia!)

%Check:
if size(data,1)<=size(data,2)
    data=data';
end

d=size(data,2); %Dimension of data (<3)
n=size(data,1); %Number of observations
M=cov(data); %Covariance matrix

%Method choice: fft is more efficient, but slightly less precise
method='fft';

if nargin<3
    bandwidth=(4/(d+2))^(1/(d+4))*n^(-1/(d+4))*M;
end

if d==1
    p=ksdensity(data,binsC);
else %d=2
    T(1)=length(binsC{1});
    T(2)=length(binsC{2});
    bins1=reshape(binsC{1},T(1),1);
    bins2=reshape(binsC{2},1,T(2));
    grid=zeros(T(1),T(2),2);
    
    if strcmp(method,'conv') %Direct method: actually do the convolution
    grid(:,:,1)=repmat(bins1,1,T(2));
    grid(:,:,2)=repmat(bins2,T(1),1);
    coord=reshape(grid,T(1)*T(2),2);
    aux=zeros(size(grid(:,:,1)));
    for i=1:n
        newCoord=(coord'-repmat(data(i,:)',1,T(1)*T(2)));
        convKernel=1/sqrt(det(bandwidth)) * exp(-sum(newCoord'.*(bandwidth\newCoord)',2));
        convKernel=reshape(convKernel,T(1),T(2));
        aux=aux+convKernel;
    end
    p=aux;
    
    elseif strcmp(method,'fft') %Indirect: do it in Fourier space, and rounding some stuff
        aux2=zeros(size(grid(:,:,1)));
        for i=1:n
            [m,t1]=min(abs(binsC{1}-data(i,1)));
            [m,t2]=min(abs(binsC{2}-data(i,2)));
            aux2(t1,t2)=aux2(t1,t2)+1;
        end
        grid(:,:,1)=repmat(bins1-mean(bins1),1,T(2));
        grid(:,:,2)=repmat(bins2-mean(bins2),T(1),1);
        coord=reshape(grid,T(1)*T(2),2);
        kernel=1/sqrt(det(bandwidth)) * exp(-sum(coord.*(inv(bandwidth)*coord')',2));
        kernel=reshape(kernel,T(1),T(2));
        kernel=fftshift(kernel);
        p=real(ifft2(fft2(aux2).*fft2(kernel))); %Avoid numerical errors that give rise to small imaginary parts
        p(p<0)=0; %Avoid numerical errors that give rise to small negative real parts
    end
    %Normalization:
    p=p/sum(p(:));
end







    



end

