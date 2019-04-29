%
% 2018/11/29
% extract interesting variables from Move Test data provided by Bas.
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
tic
errorLoad = [0, 0];
for r = 1:size(PPToverview, 1)
    filename  = strrep(PPToverview{r, 1}, '_results', '');
    requestID = PPToverview{r, 2};
    testname  = PPToverview{r, 3};
    errorNum  = size(PPToverview{r, 4}, 2);
    
    % load only sit-to-stand test
    if strcmp(testname, 'ststest') && errorNum == 1
        % kind of error
        errorKind = PPToverview{r, 4};
        if str2double(requestID) == 5349
            disp(r)
        end 
        
        % get trialNum
        %filename = '16823_movetest_ststest_2.mat';
        filenameSplitted = split(filename, '_');
        %requestID = str2double(filenameSplitted(1, 1));
        trialNum  = str2double(strrep(filenameSplitted(4, 1), '.mat', ''));
        clear filenameSplitted

        fprintf('i: %d, r: %d, filename: %s, error: %d\n', i, r, filename, errorKind);
        try
            data = extractTargetSignal(requestID, trialNum);
            data.errroNum  = errorNum; 
            data.errorKind = errorKind;
        
            % save
            save([dirSimplifiedData '\' num2str(requestID) '_' num2str(trialNum) '.mat'], 'data');
        catch
            fprintf('>>> problem in extractTargetSignal!\n');
            errorLoad = [errorLoad; i, r];
        end
        i = i + 1;
    end % if errorNum
end % r
% somewhat errorLoad becomes a complex matrix.
errorLoad = [real(errorLoad(:, 1)), errorLoad(:, 2)];
errorLoad(1, :) = [];
save([dirMain '\errorLoad.mat'], 'errorLoad');
toc 