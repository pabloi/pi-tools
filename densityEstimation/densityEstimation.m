function [p,evalCoord,bandwidth] = densityEstimation(data,evalCoord,bandwidth)
%densityEstimation estimates a probaiblity density from data points in
%data. Estimation is done by convolving with a gaussian kernel.

%INPUTS:
%'data' need not be uni-dimensional. Estimated probability will have
%dimension equal to the number of columns in the data matrix (currently it is only supported up to 2).
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
if d>2
    error('High-dim (>2) density estimation not yet supported.')
    return
end

n=size(data,1); %Number of observations
M=cov(data); %Covariance matrix

if nargin<3
    covariance=(4/(d+2))^(1/(d+4))*n^(-1/(d+4))*M;
end

if d==1
    evalCoord=evalCoord{1};
    p=ksdensity(data,evalCoord);
    if nargin>2
    warning('Using externally supplied kde function (Botev, Density estimation by diffusion), provided bandwidth will be ignored.')
    end 
    [bandwidth,p,evalCoord,cdf]=kde(data,length(evalCoord),min(evalCoord),max(evalCoord));
else %d=2
    error('High-dim (>1) density estimation not yet supported.')
    return
    
%     T(1)=length(binsC{1});
%     T(2)=length(binsC{2});
%     bins1=reshape(binsC{1},T(1),1);
%     bins2=reshape(binsC{2},1,T(2));
%     grid=zeros(T(1),T(2),2);
%     grid(:,:,1)=repmat(bins1-mean(bins1),1,T(2));
%     grid(:,:,2)=repmat(bins2-mean(bins2),T(1),1);
%     coord=reshape(grid,T(1)*T(2),2);
%     kernel=1/sqrt(det(bandwidth)) * exp(-(coord'*(bandwidth\coord)));
%     kernel=reshape(kernel,T(1),T(2));
end


%Multi-dim generalization:

% aux=[];
% aux2=[];
% aux3=[];
% aux4=[];
%for i=1:d
%     aux3=[aux3',1'];
%     aux4=[aux4,':,'];
%     aux=[aux,',' num2str(T(i))];
%end
% eval([ 'grid=zeros(' aux(2:end)  ',d);' ]);

% for i=1:d
%     T(i)=length(binsC{i});
%     aux=[aux,',' num2str(T(i))];
%     eval(['altBinC=reshape(binsC{i}',aux2, num2str(T(i)), aux3 ');']);
%     eval(['grid(' aux4 ',i)=repmat(altBinC' aux ');']);
%     aux2=[aux2,',1'];
%     aux3=aux3(1:end-2);
% end




    



end

