function data = workspace2data(requestID, trialNum)
% function data = workspace2data(requestID, trialNum)
% load Sietze's workspace and return only relevant information for mt2opti 
% as a struct 'data'.
%
% INPUT
% - requestID
% - trialNum
% OUTPUT
% - data (struct)
% 
% HISTORY
% 2019/05/09 functionized.
% 
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%

%% read Hans work.
settings_Sietze;

% Sietze did his work assuming trialNum = 1.
workspaceName = [dirWorkspace '\workspace' num2str(requestID)];
load(workspaceName);

% data of another trial numbers...
filename = [dirMT '\' num2str(requestID) '\' num2str(requestID) '_movetest_ststest_' num2str(trialNum) '.mat'];
McRoberts_input  = load(filename);
McRoberts_output = load(strrep(filename, '.mat', '_results.mat'));

% basic info
data.requestID = requestID;
data.t = t_opti2;
data.shift = ...
    floor(graph_input(find(graph_input(:, 1)==requestID), 2) * fs.beide);
data.samplingFrequency = fs.beide;


% data from MAS
data.input.intervals  = McRoberts_input.mainStruct.intervals;
data.output.STSperiod = McRoberts_output.results.report.startEndSTS;
data.output.shift_sec = verschuiving; % to be removed.
data.output.database  = McRoberts_output.results.database;
data.output.phases    = McRoberts_output.results.report.phases;


% synced
syncEnd = min(length(MT_angles.v), length(Opti_angles.v2));
syncPeriod = 1:syncEnd;

data.MT.linear.a = MT_linear.a(syncPeriod+data.shift, :);
data.MT.linear.v = MT_linear.v(syncPeriod+data.shift, :);
data.MT.linear.x = MT_linear.x(syncPeriod+data.shift, :);

data.MT.angles.a = MT_angles.a(syncPeriod+data.shift, :);
data.MT.angles.v = MT_angles.v(syncPeriod+data.shift, :);
data.MT.angles.x = MT_angles.x(syncPeriod+data.shift, :);

data.Opti.linear.v2 = Opti_linear.v2;
data.Opti.linear.x2 = Opti_linear.x2;

data.Opti.angles.v2 = Opti_angles.v2;
data.Opti.angles.x2 = Opti_angles.x2;