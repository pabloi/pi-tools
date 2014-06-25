function [fact1,fact2] = nnmfpca(data,k,replicates)
if nargin<3
    replicates=5;
end

%Step 1: get the PCA subspace with corresponding components. Not centered,
%since it is assumed that data is positive so we can do nnmf on it.
[coeff,scores]=pca(data,'NumComponents',k,'Centered','off');

%Step 2: project the data matrix onto the principal subspace
newData=coeff*data;
newData=newData.*(newData>0); %Some projections might not be strictly positive, so forcing positivity

%Step 3: doing NNMF on the new data
[fact1,fact2]=myNNMF(newData,k,replicates,'always');

end

