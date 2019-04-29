function trialNumList = getTrialNumList(requestID)
% function trialNumList = getTrialNumList(requestID)
% get trial Nums of the corresponding request ID
% by checking the filenames in the dirMT.
% 
% HISTORY
% 2019/04/29 functionized.
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%
settings_Sietze;

trialNumList = [];
dirlist = dir(fullfile([dirMT '\' num2str(requestID)], '*.mat'));
if size(dirlist, 1) > 0
    for i = 1:size(dirlist, 1)
        filename = dirlist(i).name;
        if ~strcmp(filename, '.') && ~strcmp(filename, '..')
            if contains(filename, 'movetest_ststest') & contains(filename, 'results.mat')
                trialNumStr = strrep(filename, ...
                    [num2str(requestID) '_movetest_ststest_'], '');
                trialNumStr = strrep(trialNumStr, '_results.mat', '');
                trialNumList = [trialNumList; str2num(trialNumStr)];
            end
        end
    end % i
end % if

