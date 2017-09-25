function [Q,R]=learnQR(Y,A,C,b,d)
%Simple heuristics to estimate stationary matrices Q, R
%The idea is to  estimate QR,
%then run the filter, re-estimate QR and so forth

if nargin<4 || isempty(b)
  b=0;
end
if nargin<5 || isempty(d)
  d=0;
end

error()
end
