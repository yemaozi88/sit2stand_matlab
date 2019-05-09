% 
% 2019/04/18
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%
clear all, fclose all, clc;

dirIn  = 'm:\Aki\Data\MachineLearning\from_Sietze\sts\parameters';
dirOut = 'm:\Aki\Data\MachineLearning\from_Sietze\sts';

requestID = 20121;
trialNum  = 2; 

parameters1 = makeGoldStandard_Sietze(requestID, trialNum);

fileSync = [dirOut '\synced\', num2str(requestID)];
load([fileSync '.mat']);
trialName = data.input.intervals(trialNum, 5);
parameters2 = makeGoldStandard(data, trialName);



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