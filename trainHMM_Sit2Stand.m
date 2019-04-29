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
%load(filePPToverview);
%clear filePPToverview
load(fileErrorKindTable);
clear fileErrorKindTable


%% load data
tic
analysisSucceed = errorKindTable(find(errorKindTable(:, 3) == 3), :);
analysisSucceedNumMax = size(analysisSucceed, 1);

Signals = [];
States  = [];
for i = 1:analysisSucceedNumMax
    requestID = analysisSucceed(i, 1);
    trialNum  = analysisSucceed(i, 2);
    
    filename = [num2str(requestID) '_' num2str(trialNum) '.mat'];
    load([dirSimplifiedData '\' filename]);

    [signal, states] = extractHMMfeatures(data);
    % figure;
    % plot(signal(:, 4))
    % hold on
    % plot(states)
    Signals = [Signals; signal];
    States  = [States; states];
end % i
clear i analysisSucceedNumMax
clear requestID trialNum filename
clear signal states
toc


%% train HMM
%[trans, emits] = hmmestimate(Signals', States');
% trans = [0.95,0.05;
%       0.10,0.90];
% emis = [1/6, 1/6, 1/6, 1/6, 1/6, 1/6;
%    1/10, 1/10, 1/10, 1/10, 1/10, 1/2];
% 
% seq1 = hmmgenerate(100,trans,emis);
% seq2 = hmmgenerate(200,trans,emis);
% seqs = {seq1,seq2};