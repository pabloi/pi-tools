function [H] = myEntropy(p,step)
%myEntropy calculates the entropy of a probability density p (or discrete
%probability p).
%In case p is a probability density, the interval between samples (step)
%has to be given. For discrete probabilities this is not necessary
%(step=1).

if nargin<2
    disp('Warning: step parameter not given, assuming discrete probability distribution.')
    disp('To avoid this message from appearing, set step=1 for discrete probabilities.')
    step=1; %Assuming discrete probability distribution
end

%p needs to be a probability density, which means that:
%p has to be >=0 everywhere. If not, the function will display an error and
%return NaN.
%It's integral should be one, or numerically: sum(p(:))=1. This is enforced
%with a warning when necessary.

%Check positivity
if any(p(:)<0)
    disp('Error: p cannot have negative values')
    H=NaN;
    return
end

%Check normalization
if step*sum(p(:))~=1
    disp('Warning: p is not normalized. Normalizing.')
    p=p/(step*sum(p(:)));
end

aux=p.*log2(p);
aux(isnan(aux))=0; %Getting rid of 0*log(0) indeterminations
H=-sum(step*aux);


end

