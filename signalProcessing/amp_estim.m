function [ amplitude ] = amp_estim(signal,fs,mod_ord,cutoff,BW)
%EMG AMPLITUDE ESTIMATION Summary of this function goes here
%   Detailed explanation goes here

if nargin<5
	BW=[10,300];
end
%% Stage 1: pre-processing, noise rejection
emg1=highpassfiltering(signal,BW(1),5,fs); %Lit says 0-20Hz is only electrode-skin interaction.
emg1=lowpassfiltering(signal,BW(2),5,fs); %Reject high-freq noise. I think it really is not immportant (gets filtered afterwards).

%% Stage 2: whitening
emg2=emg1; %ToDo

%% Stage 3: rectification
emg3=abs(emg2).^mod_ord;

%% Stage 4: estimation (low-pass filtering)
emg4=lowpassfiltering(emg3, cutoff, 5, fs);

%% Stage 5: relinearization
amplitude=abs(emg4.^(1/mod_ord));
%amplitude=lowpassfiltering(amplitude, cutoff, 10, fs); %The step above
%(relin.) might introduce higher freq components than intended. However,
%filtering might introduce negative values. What to do?

end

