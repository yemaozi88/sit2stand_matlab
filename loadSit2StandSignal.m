function [mainStruct, results] = loadSit2StandSignal(requestID, trialNum)
% function [mainStruct, results] = loadSit2StandSignal(requestID, trialNum)
% load Sit-to-Stand signals from 
% (requestID)_movetest_ststest_(trialNum).mat
% and (requestID)_movetest_ststest_(trialNum)_result.mat.
%
% INPUT
% - requestID:
% - trialNum:
%  filename would be (requestID)_movetest_ststest_(trialNum).mat
%  (requestID)_movetest_ststest_(trialNum)_result.mat
%  would also be in the same folder.
% 
% OUTPUT
% - mainStruct: original signal.
% - results: MAS analysis results.
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%


%% test
%clear all, fclose all, clc;
%requestID = 16823;
%trialNum  = 2;


%% default values
settings_Sit2Stand;
testname = 'ststest';


%% load mat file
filename = [num2str(requestID) '_movetest_' testname '_' num2str(trialNum) '.mat'];
% get request ID and trialNum from the filename.
%filename = '16823_movetest_ststest_2.mat';
%filenameSplitted = split(filename, '_');
%requestID = str2double(filenameSplitted(1, 1));
%trialNum  = str2double(strrep(filenameSplitted(4, 1), '.mat', ''));
%clear filenameSplitted

% ogirinal signal
signalMAT = [dirData '\' num2str(requestID) '\' filename];
try
    load(signalMAT);
catch
    disp([signalMAT ' cannot open.']);
end

% result signal
resultMAT = strrep(signalMAT, '.mat', '_results.mat');
try
    load(resultMAT);
catch
    disp([resultMAT ' cannot open.']);
end
clear signalMAT resultMAT