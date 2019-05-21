%
% 2018/12/06
% extract features which can be used for error analysis.
%
% NOTES:
% this function is intended to be used for data from Bas.
% 
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%


%% definition
dirData  = 't:\Data_PPT_Performance';

%dirMain           = 'c:\Users\A.Kunikoshi\OneDrive - McRoberts\Projects\Sit2Stand';
dirMain = 'e:\McRoberts\OneDrive\Projects\Sit2Stand';
dirSimplifiedData = [dirMain '\SimplifiedData'];
dirFig            = [dirMain '\fig'];
dirMat            = [dirMain '\mat'];
%dirHTK            = [dirMain '\htk'];
dirHTK = 'c:\Aki\htk_sit2stand';

fileErrorKindTable    = [dirMat '\errorKindTable.mat'];

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
dirPPT = 'm:\Bas\MoveTest\Performance PPT';
%fileOverview = [dirPPT '\Code\Code Rick\PPT_overview.mat'];
filePPToverview = [dirMat '\PPT_overview.mat'];


%% feature extraction
samplingFrequency = 100;
pointPerHz = 2;
cutoffFrequency = 15;
windowSize  = 200;
frameShift = 1; % 0.1[s]
% feature size: pointPerHz x cutoffFrequency x 4


%% state label
% for extractStates and for makeHTKfiles.
% sit (ii): 1
% sit2stand (it): 2
% stand (tt): 3
% stand2sit (ti): 4
phaseList = {'ii', 'it', 'tt', 'ti'};