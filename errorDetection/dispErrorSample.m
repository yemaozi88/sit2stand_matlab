function dispErrorSample(errorKind, axisNum)
% function dispErrorSample(errorKind, axisNum)
% display Sit-to-Stand signals by error kind.
% signal is chosen randomly.
%
% INPUT
% - errorKind: 
%       1: analysis error
%       2: user error
%       3: correct analysis
%       4: analysis failed
%       5: dont know
% - axisNum (optional): which axis to be displayed. 
%   When not given, default_axisNum would be default.
%   1-3: Velocity(MAS output).{x, y, z}
%   4: FlexionAngle(MAS output).
% 
% NOTES
% this function is intended to be used for data from Bas.
%
% HISTORY
% 2018/12/08 functionized.
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%


%% test
% clear all, fclose all, clc;
% errorKind = 2;
% axisNum = 7;


%% definition
settings_Sit2Stand;
default_axisNum = 1;


%% if axisNum is not defined or wrong number, it will be default value.
if ~exist('axisNum')
    axisNum = default_axisNum;
end
axisNum = round(axisNum);
if axisNum < 1 || axisNum > 4
    disp('axisNum is not between 1 and 4.');
    disp(['axisNum is assumed to be default value: ' num2str(default_axisNum) '.']);
    axisNum = default_axisNum;
end % axisNum


%% randomly choose one signal which error is specified as 'errorKind'.
load(fileErrorKindTable);
errorKindTable_ = errorKindTable(find(errorKindTable(:, 3) == errorKind), :)
rNumMax = size(errorKindTable_, 1);
idx = randi(rNumMax);


%% extra information
disp(['One of ' num2str(rNumMax) ' samples of error kind ' num2str(errorKind)]);
disp('  1: analysis error');
disp('  2: user error');
disp('  3: correct analysis');
disp('  4: analysis failed');
disp('  5: dont know');


%% display signal
requestID = errorKindTable_(idx, 1);
trialNum  = errorKindTable_(idx, 2);

dispSit2StandSignal(requestID, trialNum, axisNum);

hold on
title(['requestID: ' num2str(requestID) ', trialNum: ' num2str(trialNum)]);
hold off