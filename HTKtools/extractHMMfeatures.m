function [HMMfeatures, phaseMatrix] = extractHMMfeatures(data)
% function [HMMfeatures, phaseVector] = extractHMMfeatures(data)
% extract features which can be used for HMM for Sit-to-Stand phase detection.
%
% INPUT:
% - data: simplified version of Bas data.
% OUTPUT:
% - HMMfeatures: n x d(static + delta) feature matrix.
% - phaseMatrix: n x 3(phase, start, end) matrix. 
%
% HISTORY
% 2019/01/10 functionized.
% 
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%

%clear all, fclose all, clc;


%% default values
settings_Sit2Stand;


%% test
% requestID = 10623;
% trialNum = 2;
% filename = [num2str(requestID) '_' num2str(trialNum)];
% load([dirSimplifiedData '\' filename '.mat']);


%% set variables
%signal = [data.resultVelocity, data.resultFlexionAngle];
[states, signal] = extractStates(data);


%% feature extraction
sampleSize = size(signal, 1);
axisNumMax = size(signal, 2);

assert(sampleSize > windowSize, 'the signal is too short.');
cutoffPoints = pointPerHz*cutoffFrequency;

X = [];
for axisNum = 1:axisNumMax
    [PSDmat, tindex] = calcPSDslide(signal(:, axisNum), ...
        samplingFrequency, pointPerHz, windowSize, frameShift);
    X = [X, PSDmat(:, 1:cutoffPoints)];
end % axis
clear PSDmat axisNum

% adddelta
HMMfeatures = adddelta(X')';


%% status information.
%states = states(tindex);
%phase_ = 0;
%for i = 1:size(states)
%     phase = states(i);
%     if phase ~= phase_
%         phaseVector = [phaseVector; phase];
%     end
%end % i
%clear i phase_ phase
phaseMatrix = [];
phase_ = 0;
phaseStart  = 0;
phaseStart_ = 0;
phaseEnd    = 0;
phaseEnd_   = 0;
for i = 1:size(tindex, 1)
    statesStart = tindex(i);
    statesEnd   = statesStart + windowSize -1;      
    %states_ = %[phaseVector_; mode(states(statesPeriod))];
    % most frequent states
    %phase = mode(states(statesStart:statesEnd));
    % beginning states
    phase = states(statesStart);
    if i == size(tindex, 1)
        phaseEnd = statesStart + windowSize;
    else
        phaseEnd = statesStart + frameShift;
    end
    
    if i == size(tindex, 1)
        %fprintf('%d: %d-%d, %d-%d\n', ...
        %phase, statesStart, statesEnd, phaseStart, phaseEnd);
        phaseMatrix = [phaseMatrix; phaseStart, phaseEnd, phase];
    elseif phase ~= phase_ && phase_ ~= 0
        phaseStart = statesStart;
        %fprintf('%d: %d-%d, %d-%d\n', ...
        %    phase_, statesStart, statesEnd, phaseStart_, phaseEnd_);
        phaseMatrix = [phaseMatrix; phaseStart_, phaseEnd_, phase_];
    end
    phase_ = phase;
    phaseStart_ = phaseStart;
    phaseEnd_   = phaseEnd;
end % i
clear i
clear statesStart statesEnd
clear phase_ phaseStart_ phaseEnd_
clear phase phaseStart phaseEnd

