%
% make Sit-to-Stand phase from OptiTrack.
% 
% HISTORY
% 2019/04/29
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%

%% definition
clear all, close all, clc;
settings_Sietze;


%% loop over the requestIDs.
load(fileRequestIDlist);

errorList = [];
for requestID_ = 1:size(requestIDlist, 1)
    requestID = requestIDlist(requestID_);
    trialNumList = getTrialNumList(requestID);

    for trialNum = 1:size(trialNumList, 1)
        fprintf('%d_%d\n', requestID, trialNum);
    
        % make gold standard
        try
            parameters = makeGoldStandard_Sietze(requestID, trialNum);
            fileParameters = sprintf('%s\\parameters\\original\\%d_%d.mat', ...
                dirOut, requestID, trialNum);
            save(fileParameters, 'parameters');            
        catch
            errorList = [errorList; requestID, trialNum];
        end

    end % trialNum
end % requestID_