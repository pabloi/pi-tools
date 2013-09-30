function [I] = mutualInfo(p)
%mutualInfo calculates the mutual information of two variables x,y from
%their joint probability density distribution p sampled at uniform
%intervals in both axes (the actual interval does not matter for the
%purpose of the numerical integration, although a coarsely sampled probability distribution will probably result in less accurate results when compared to the actual mutual information derived from the continuous distribution)
%It is assumed that the probability distribution is 0 outside of the given
%values

%p needs to be a probability density, which means that:
%p has to be >=0 everywhere. If not, the function will display an error and
%return NaN.
%It's integral should be one, or numerically: sum(p(:))=1. This is enforced
%with a warning when necessary.

%Check positivity
if any(p(:)<0)
    disp('Error: p cannot have negative values')
    I=NaN;
    return
end

%Check normalization
if sum(p(:))~=1
    disp('Warning: p is not normalized. Normalizing.') %I don't think this matters for mutual info, it cancels anyway (otherwise the grid size would become important)
    p=p/(sum(p(:)));
end

px=sum(p,2);
py=sum(p,1);

aux1=p.*log2(p./(px*py));
aux1(isnan(aux1))=0;
I=sum(aux1(:));


end

