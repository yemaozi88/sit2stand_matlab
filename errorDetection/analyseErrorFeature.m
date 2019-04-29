%
% 2018/12/14
% which feature is useful to differentiate analysis error or not.
% input should be Sit-to-Stand signal.
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%

clear all, fclose all, clc;


%% definition
settings_Sit2Stand;


%% load overview
% as of the Slack message from Bas on 2018/11/29
% PPToverview
%   col 1: filename
%   col 2: request ID
%   col 3: test name
%       gaittest, sixmwtest, sppb, stairtest, ststest, swaytest, tugtest
%   col 4: error kinds
%       1: analysis error
%       2: user error, 
%       3: correct analysis
%       4: analysis failed
%       5: dont know
%   col 5: comments
%   col 6: annotator
load(fileOverview);


%% load data
requestID = 16221;
trialNum = 1;

filename = [num2str(requestID) '_' num2str(trialNum) '.mat'];
load([dirSimplifiedData '\' filename]);
clear filename


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


%% similarity
axisNum = 1;
similarity = zeros(phaseNumMax, 1);
for p = 1:phaseNumMax
    [similarity_, ~] = getSignalSimilarity(...
        signal(SiStStart(1):SiStEnd(1), axisNum), ...
        signal(SiStStart(p):SiStEnd(p), axisNum));
    similarity(p, 1) = similarity_;
end % p


%% plot
% hold on
% plot(SiStN(:, axisNum));
% plot(SiSt1(:, axisNum));
% hold off