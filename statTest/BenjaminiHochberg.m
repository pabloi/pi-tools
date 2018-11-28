function [h,pThreshold,i1,pAdjusted] = BenjaminiHochberg(p,fdr)
%Performs the Benjamini-Hochberg procedure to determine significance in
%multiple comparisons while controlling the False Discovery Rate (number of 
%false positives as a % of the number of total comparisons). This is a
%less taxing alternative to performing a Bonferroni correction, for example.
%FDR control is done in expectation over many realizations.
%
%INPUT:
%p= vector of p-values from the multiple comparisons, has to be 1-D
%fdr= value in [0,1] that determines the (expected) False Discovery Rate that is
%tolerated
%OUTPUT:
%h= binary vector that is 1 if the corresponding p-value was deemed
%significant, and 0 if not.
%pThreshold = value that ends up being the cut-off for p. Should satisfy:
%h = p<=pThreshold = pAdjusted<fdr
%i1 = no. of significant results, equals sum(h)
%pAdjusted = adjusted p-values

%Validated on Oct 19th 2017 against fdr_bh() function from Matlab Exchange
%References:
%Benjamini & Hochberg 1995
%Smyth 2002 (?) (for definition of adjusted p-values)

M=numel(p); %No. of total comparisons

[p1,idx]=sort(p(:),'ascend');
h1=zeros(size(p1));
ii=find(p1 < fdr*[1:M]'/M,1,'last');
if isempty(ii)
    i1=0;
else
    i1=ii;
end

h1(1:i1)=1; %Significant results
h=nan(size(p));
h(idx)=h1; %Re-sorting

pThreshold=p1(ii);

if nargout>3 %Computing adjusted p-values
    %Adjusted p-values are the thing that is compared to fdr
    pAdjusted=nan(size(p));
    newP=p1*M./[1:M]';
    for i=(length(newP)-1):-1:1
        if newP(i)>newP(i+1)
            newP(i)=newP(i+1);
        end
    end
    pAdjusted(idx)=newP;
end


end

