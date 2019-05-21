function data = extractTargetSignal(requestID, trialNum)
% function data = extractTargetSignal(requestID, trialNum)
% extract relevant signal from .mat files given by Bas.
%
% NOTES:
% this function is intended to be used for data from Bas.
%
% HISTORY
% 2018/12/02 functionized.
%
% AUTHOR
% Aki Kunikoshi
% a.kunikoshi@gmail.com
%


%% load signal
[mainStruct, results] = loadSit2StandSignal(requestID, trialNum);


%% target period
%marker = results.measInfo.markers{1, 1}.ststest;
marker = mainStruct.intervals;
trialNumMax = size(marker, 1);
assert(trialNum <= trialNumMax, 'trial number should be small then the number of trials included in the data.');

% 500 points are added before and after the trial.
timeStart = marker{trialNum, 1};
timeEnd   = marker{trialNum, 2};
targetPeriod = timeStart:timeEnd;


%% extract relevant fields
data = [];
data.requestID     = requestID;
data.trialNum      = trialNum;
% data.measurementID = mainStruct.measInfo.measurement_id;
% data.projectID     = mainStruct.measInfo.project_id;
% data.protocolID    = mainStruct.measInfo.protocol_id;
% data.visitID       = mainStruct.measInfo.visit_id;
data.subjectID     = mainStruct.requestInfo.subject_id;
data.subjectAge    = mainStruct.requestInfo.subject_age;
data.subjectWeight = mainStruct.requestInfo.subject_weight;
data.subjectHeight = mainStruct.requestInfo.subject_height;
data.subejctGender = mainStruct.requestInfo.subject_gender;

data.signalFlexionAngle  = mainStruct.angles(targetPeriod, :);
data.signalAccelerometer = mainStruct.gAcc(targetPeriod, :);
data.signalGyroscope     = mainStruct.gGyr(targetPeriod, :);
data.signalMarkers = results.measInfo.markers{1, 1}.ststest; % same as intervals.

data.resultPhases  = results.report.phases;
data.resultSit2Stand = results.database.SitToStand;
data.resultStand2Sit = results.database.StandToSit;
data.resultFlexionAngle = results.report.angle;
data.resultVelocity     = results.report.velocityVT;

% for convenience
data.result = results;
