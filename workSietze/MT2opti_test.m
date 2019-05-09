% 
% 2019/04/18
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%
clear all, fclose all, clc;
settings_Sietze;


%% load data
requestID = 20121;
trialNum = 1;
load([dirGoldStandard '\' num2str(requestID) '_' num2str(trialNum) '.mat']);
load([dirSynced '\' num2str(requestID) '_' num2str(trialNum) '.mat']);
trialName = data.input.intervals(trialNum, 5);

dispSit2StandPhase(data, trialName, parameters);

% load([dirIn '\goldstandard\20121_2.mat']);
% p1 = parameters;
% clear parameters
% 
% % target
% load([dirIn '\original\20121_2.mat']);
% p2 = parameters;
% clear parameters
% 
% compareStructs(p1, p2)