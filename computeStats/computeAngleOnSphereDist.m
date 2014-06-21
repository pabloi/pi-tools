function [distPoints,evalPoints] = computeAngleOnSphereDist(sphereDim,Nrepeats,evalPoints)
%computeAngleOnSphereDist This function computes the distribution for the
%angle between two points drawn from a uniform distribution on a spheric shell of dimension sphereDim
%   Detailed explanation goes here

if nargin<3 || isempty(evalPoints)
    evalPoints=[.5:.5:89.5]; %Degrees
end
if nargin<2 || isempty(Nrepeats)
    Nrepeats=10000;
end
if nargin==0 || isempty(sphereDim)
    sphereDim=3;
end

angle=zeros(Nrepeats,1);
for j=1:Nrepeats
    randomSample=randn(2,sphereDim); %Draw random points in space
    %I think the next line is not necessary, since the angle function is
    %invariant to scale changes. That means that to evaluate what I want,
    %it is sufficient to draw vectors from any distribution with spherical
    %symmetricity
    %randomSample=randomSample./repmat(columnNorm(randomSample',2)',size(randomSample,1),1); %This should make sure that they are projected onto the shell
    angle(j)=acosd(cosine(randomSample(1,:)',randomSample(2,:)'));
end
[distPoints]=hist(angle,evalPoints)/Nrepeats;


end

