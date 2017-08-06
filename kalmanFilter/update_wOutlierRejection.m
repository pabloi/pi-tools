function [x,P]=update_wOutlierRejection(C,R,x,P,y,d)
[outlierIndx]=detectOutliers(y-d,x,P,C,R);

if any(~outlierIndx)
%Update without outliers, by setting outliers to exactly what we expect
%with inifinite uncertainty
%y(outlierIndx)=C(outlierIndx,:)*x + d(outlierIndx); %Unnecessary
R(outlierIndx,:)=1/eps;
R(:,outlierIndx)=1/eps;

%Alt: (equivalent) eliminate outliers before update
%y=y(~outlierIndx);
%C=C(~outlierIndx,:);
%R=R(~outlierIndx,~outlierIndx);

[x,P]=updateKF(C,R,x,P,y,d);
end

%Al
end
