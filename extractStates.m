function [states, signal] = extractStates(data)
% function [states, signal] = extractStates(data)
% load states (=phase: sit, sit2stand, stand2sit, stand, still)
%
% INPUT
% - data: simplified the data which Bas gave me. 
% 
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%

%clear all, fclose all, clc;

settings_Sit2Stand;


%% signal
signal = [data.resultVelocity, data.resultFlexionAngle];

% as of the Slack message from Bas on 2018/11/29.
% phases
%   col 1: start SiSt
%   col 2: max flex SiSt
%   col 3: end SiSt
%   col 4: start StSi
%   col 5: max flex StSi
%   col 6: end StSi
%   col 7&8: (Bas added personally. Not required for this topic).
phases = data.resultPhases;
phaseNumMax = size(phases, 1);
SiStStart = phases(:, 1);
SiStEnd   = phases(:, 3);
StSiStart = phases(:, 4);
StSiEnd   = phases(:, 6);


%% state label.
% sit (ii): 1
% sit2stand (it): 2
% stand (tt): 3
% stand2sit (ti): 4
states = ones(size(signal, 1), 1);
for phaseNum = 1:phaseNumMax
    phasePeriod = SiStStart(phaseNum):SiStEnd(phaseNum);
    states(phasePeriod, :) = 2;
    phasePeriod = SiStEnd(phaseNum)+1:StSiStart(phaseNum)-1;
    states(phasePeriod, :) = 3;
    phasePeriod = StSiStart(phaseNum):StSiEnd(phaseNum);
    states(phasePeriod, :) = 4;
end % phaseNum

% % plot
% figure
% dispSit2StandSignal(requestID, trialNum);
% hold on
% plot(states * (-10), 'm', 'LineWidth', 2);
% hold off

measurementStart = SiStStart(1);
measurementEnd   = StSiEnd(end);

states = states(measurementStart:measurementEnd, :);
signal = signal(measurementStart:measurementEnd, :);