function [APwaves,spikeTrains] = spikeID(timeSignal,k,featureSize,expectedFiringRate)

%expectedFiringRate should be in the [0,.5] interval, where .5 means it is
%expected to fire every other sample, and 0 means it never fires.

%Compute appropriate weighing parameter for sparsity of spikes
lambda=1/expectedFiringRate;
correctedLambda=length(timeSignal)*lambda/featureSize;


%Initialize AP waveforms by finding the 
aux=conv(timeSignal,ones(featureSize,1),'same');
for i=1:k
    idx=find(max(abs(aux(1:end-featureSize))));
    APwaves(i,:)=timeSignal(idx:idx+featureSize-1);
    aux(idx:idx+featureSize-1)=0;
end


%Initialize spikeTrains
for i=1:k
    spikes(:,i)=conv(timeSignal,APwaves(i,:)','same')/norm(APwaves(i,:));
    keepIdx=abs(spikes(:,i))>=(1-expectedFiringRate)*(max(abs(spikes(:,i))));
    spikes(:,i)=spikes(keepIdx,i);
end

%Initialize constants
Niter=20;
iter=0;

%Iterate
while iter<Niter
    iter=iter+1
    J(iter)=J1(spikes,APwaves,timeSignal,correctedLambda);
    
    %Update new waveforms
    for i=1:k
        auxTimeSignal=timeSignal;
        for j=1:k
            if j~=i
                auxTimeSignal=auxTimeSignal-conv(spikes(:,j),APwaves(j,:)','same');
            end
        end
        aaux=conv(spikes(:,i),APwaves(i,:),'same');
        
        APwaves(i,:)=APwaves(i,:)-.2*();
        APwaves=fminunc(@(x) J2(x,spikes,timeSignal,correctedLambda),APwaves);
    
end

plot(J)

end

function J=J1(spikes,APwaves,timeSignal,correctedLambda)
aux=zeros(size(timeSignal));
k=size(spikes,2);
for i=1:k
    aux=aux+conv(spikes(:,i),APwaves(i,:),'same');
end
    J=norm(aux-timeSignal)^2 + correctedLambda*sum(abs(spikes(:)))^2;
end

function J=J2(APwaves,spikes,timeSignal,correctedLambda)
    aux=zeros(size(timeSignal));
    k=size(spikes,2);
    for i=1:k
        aux=aux+conv(spikes(:,i),APwaves(i,:),'same');
    end
    J=norm(aux-timeSignal)^2;
end
