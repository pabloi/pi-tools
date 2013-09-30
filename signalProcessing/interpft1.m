function [y] = interpft1(x,N,dim)
%INTERPFT1 Replacement for the original interpft, with mirroring extension to allow for circular
%continuity

%% To work for all dimensions
% %Generate a string to properly ask for extension
% str=[];
% M=size(x);
% for i=1:length(M)
%     if i~=dim
%     str=[str,num2str(size(x,i)),','];
%     else
%         str=[str,num2str(2*size(x,i)),',']
%     end
%     str(end)=';';
% end
% 
% %Initialize extended version
% eval(['x2=zeros(', str, ');']);
% 
% %Fill x2 with copies of x
% 
% 
% %Do the interpolation
% 
% %Get the relevant part of the interpolation

%% To work with only dim=1

x2=[x;x(end:-1:1)];
y2=interpft(x2,2*N);
y=y2(1:N);

end

