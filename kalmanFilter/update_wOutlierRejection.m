function [x,P]=update_wOutlierRejection(C,R,x,P,y,d)
  %update implements Kalman's update step
  K=P*C'/(C*P*C'+R);
x=x+K*(y-C*x-d);
P=P-K*C*P;

[outlierIndx]=detectOutliers(y,x,P,C,R);

%Update without outliers, by setting outliers to exactly what we expect
%with inifinite uncertainty
y(outlierIndx)=C(outlierIndx,:)*x + d(outlierIndx);
R(outlierIndx,:)=1/eps;
R(:,outlierIndx)=1/eps;

%Alt: (equivalent) eliminate outliers before update
%y=y(~outlierIndx);
%C=C(~outlierIndx,:);
%R=R(~outlierIndx,~outlierIndx);

[x,P]=update(C,R,x,P,y,d);

%Al
end
