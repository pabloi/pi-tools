% Example of how to use the event detection

%load some file & define FzR and FzL (z-component of left and right
%force-plates)
fsample=1000; %Hz
FzR=(1000*(sin(2*pi*1*[0:.001:10])) + 10*randn(1,10001))'; % 10 sec recording
FzR=FzR.*(FzR>0);
FzL=(1000*(cos(2*pi*1*[0:.001:10])) + 10*randn(1,10001))';
FzL=FzL.*(FzL>0);

%Define threshold for considering a foot on the ground
threshold=30; %Newtons


%Get stance phases:
[stanceL] = getStanceFromForces(FzL, threshold, fsample);
[stanceR] = getStanceFromForces(FzR, threshold, fsample);

%Get events (as boolean vector):
[LHS,RHS,LTO,RTO] = getEventsFromStance(stanceL,stanceR);

%Put event times in a vector:
LHStimes =(find(LHS)-1)/fsample;
RHStimes = (find(RHS)-1)/fsample;