function [priorState,posteriorState,priorVariance,posteriorVariance,K] = kalmanFilter(input,output,A,B,Q,C,R,x0,p0,error)

%A,B,C,Q,R are fixed.
%x0 is the initial state estimation
xPosterior=x0;
pPosterior=p0;


for i=1:size(output,2)
    %Prediction
    if size(input,2)==size(output,2)
        xPrior=A*xPosterior + B*input(:,i); %Input is given
    else
        xPrior=(A+B*input)*xPosterior; %Assuming what is given is a state-feedback matrix
    end
    
    pPrior=A*pPosterior*A' + Q;

    %Correction:
    if nargin<10
        e=output(:,i)-C*xPrior;
    else
        e=error(:,i); %CAse error data is given. Useful to simulate error-clamp experiments.
    end
    K(:,i)=pPrior*C'*pinv(C*pPrior*C' + R);
    xPosterior=xPrior + K(:,i)*e;
    pPosterior=pPrior - K(:,i)*C*pPrior;

    %Save history of predictions:
    priorState(:,i)=xPrior;
    posteriorState(:,i)=xPosterior;
    priorVariance(:,:,i)=pPrior;
    posteriorVariance(:,:,i)=pPosterior;
end



end

