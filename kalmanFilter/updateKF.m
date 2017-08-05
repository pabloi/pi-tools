function [x,P]=updateKF(C,R,x,P,y,d)
  %update implements Kalman's update step
  K=P*C'/(C*P*C'+R);
x=x+K*(y-C*x-d);
P=P-K*C*P;
end
