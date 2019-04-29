function dispSit2StandSignal(requestID, trialNum, axisNum)
% function dispSit2StandSignal(requestID, trialNum, axisNum)
% display Sit-to-Stand signals.
%
% INPUT
% - requestID:
% - trialNum:
% - axisNum (optional): which axis to be displayed. 
%   When not given, default_axisNum would be default.
%   1-3: Velocity(MAS output).{x, y, z}
%   4: FlexionAngle(MAS output).
% 
% NOTES
% this function is intended to be used for data from Bas.
% the directory where all the mat files are stored is given as dirData.
%
% HISTORY
% 2018/11/29 functionized.
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%


%% test
% clear all, fclose all, clc;
% requestID = 16221;
% trialNum = 2;
% axisNum = 4;


%% definition
settings_Sit2Stand;
default_axisNum = 4;


%% load signal
%[mainStruct, results] = loadSit2StandSignal(requestID, trialNum);
load([dirSimplifiedData '\' num2str(requestID) '_' num2str(trialNum) '.mat']);


%% check axisNum
% if axisNum is not defined or wrong number, it will be default value.
if ~exist('axisNum')
    axisNum = default_axisNum;
end
axisNum = round(axisNum);
if axisNum < 1 || axisNum > 4
    disp('axisNum is not between 1 and 4.');
    disp(['axisNum is assumed to be default value: ' num2str(default_axisNum) '.']);
    axisNum = default_axisNum;
end % axisNum


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

% index
tMax = size(signal, 1);
t = 1:tMax;
t = t';


%% plot
hold on
x = signal(:, axisNum);
% x = data.resultFlexionAngle(:, 1);
% y = data.signalFlexionAngle(:, 1)*100;
plot(x, 'k', 'lineWidth', 2);
% plot(y, 'b', 'lineWidth', 2);
% legend('result', 'raw * 100');
for phaseNum = 1:phaseNumMax
    phasePeriod = SiStStart(phaseNum):SiStEnd(phaseNum);
    plot(t(phasePeriod), x(phasePeriod), 'r', 'lineWidth', 2);
    
    phasePeriod = StSiStart(phaseNum):StSiEnd(phaseNum);
    plot(t(phasePeriod), x(phasePeriod), 'g', 'lineWidth', 2);   
    
    title(['requestID: ' num2str(requestID) ', trialNum: ' num2str(trialNum)]);
end % phaseNum
hold off