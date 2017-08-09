function [outlierIndx]=detectOutliers(y,x,P,C,R)
m=size(y,1);
th=25; %Threshold
expY=C*x;
Py=C*P*C' + R;
innov=y-expY;
%logp=innov'*pinv(Py)*innov; %-1/2 of log(p) of observation
auxTh=th*m;%-log(det(2*pi*Py));
auxLogP=pinv(Py)*innov;
%innov.*auxLogP
auxDist=innov.*auxLogP;
outlierSamples=sum(auxDist)>auxTh;
outlierIndx=false(size(auxDist));
outlierIndx(:,outlierSamples)=true;
outlierIndx=auxDist> auxTh/m; %Values of 1 indicate likely outliers

%if any(outlierIndx)
%    disp(['Found outliers:' num2str(find(outlierIndx)')])
%    y
%end

%ALT: do it recursively by finding the lowest log(p), if it passes the threshold
%exclude it, then re-compute log(p) without considering it, find the second lowest
%value, and so forth.

end
