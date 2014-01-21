function [avgResult,fullResults,dataGroups] = doWithBootstrap(data,splittingDimension,Nsplits,functionString,otherParams,shuffleFlag)
%Evaluates any function through bootstrapping. Given the data matrix
%"data", it splits it into Nsplits groups of data along dimension
%"splittingDimension". Then calls the function name given by
%"functionString" with each data group as the first parameter, and other
%parameters given by "otherParams" (cell array). Data will be shuffled if
%the shuffle flag is on.

%Put the splitting dimension as first dimension of array
newOrder=[splittingDimension, 1:splittingDimension-1 splittingDimension+1:length(size(data))];
dataEasy=permute(data,newOrder);

if shuffleFlag
    %To Do shuffling
end

splittingPoints=round([1:(size(data,splittingDimension)-1)/Nsplits:size(data,splittingDimension)]);
for i=1:Nsplits
    %Generate data splits for bootstrapping
    dataGroups{i}=dataEasy(splittingPoints(i):splittingPoints(i+1)-1,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:);
    aux=[];
    for j=1:length(otherParams)
        aux=[aux ', otherParams{' num2str(j) '}'];
    end
    eval(['fullResults{i}=' functionString '(dataGroups{i}' aux ');']);
    dataGroups{i}=depermute(dataGroups{i},newOrder);
    if i==1
        avg=fullResults{1};
    else
        avg=avg+fullResults{i};
    end
    avgResult=avg/Nsplits;
end



end

