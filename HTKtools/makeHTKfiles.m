function makeHTKfiles(requestID, trialNum, dirOut)
% function makeHTKfiles(requestID, trialNum, dirOut)
% make a feature file and a label file for HTK.
%
% INPUT 
% - requestID:
% - trialNum:
% - dirOut: the directory where the files will be saved.
%
% NOTE:
% this script for simplified version of the data which Bas gave me. 
% 
% REFERENCE
% - HTK format file.
% http://www.ee.columbia.edu/~dpwe/LabROSA/doc/HTKBook21/node58.html
% - label file.
% http://www.ee.columbia.edu/~dpwe/LabROSA/doc/HTKBook21/node82.html
% - precision in MATLAB.
% https://jp.mathworks.com/help/matlab/ref/fwrite.html
%
% HISTORY
% 2019/01/10 modified for features.
% 2019/01/03 functionized.
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%


%% test
% clear all, fclose all, clc;
% requestID = 10623;
% trialNum = 2;


%% defaulat values
settings_Sit2Stand;


%% load data
filename = [num2str(requestID) '_' num2str(trialNum)];
load([dirSimplifiedData '\' filename '.mat']);


%% features
[HMMfeatures, phaseMatrix] = extractHMMfeatures(data);


%% output files
fsignal = fopen([dirOut '\' filename '.fea'], 'w');
flabel  = fopen([dirOut '\' filename '.lab'], 'wt');


%% transcription.
% % as of the Slack message from Bas on 2018/11/29.
% % phases
% %   col 1: start SiSt
% %   col 2: max flex SiSt
% %   col 3: end SiSt
% %   col 4: start StSi
% %   col 5: max flex StSi
% %   col 6: end StSi
% %   col 7&8: (Bas added personally. Not required for this topic).
% phases = data.resultPhases;
% phaseNumMax = size(phases, 1);
% SiStStart = phases(:, 1);
% SiStEnd   = phases(:, 3);
% StSiStart = phases(:, 4);
% StSiEnd   = phases(:, 6);

% segments = [];
% for phaseNum = 1:phaseNumMax
%     segments = [segments; SiStStart(phaseNum), SiStEnd(phaseNum)];
%     if phaseNum == 1
%         labels = {'sit2stand'};
%     else
%         labels = [labels; 'sit2stand'];
%     end
%     segments = [segments; SiStEnd(phaseNum)+1, StSiStart(phaseNum)-1];
%     labels   = [labels; 'stand'];
%     segments = [segments; StSiStart(phaseNum), StSiEnd(phaseNum)];
%     labels   = [labels; 'stand2sit'];
%     if phaseNum ~= phaseNumMax
%         segments = [segments; StSiEnd(phaseNum)+1, SiStStart(phaseNum+1)-1];
%         labels   = [labels; 'sit'];
%     end
% end % phaseNum

% % HTK uses 100[ns] unit. 
% % 1[ms] = 1,000,000[ns] = 10,000[htk]
% % MoveTest samples data in 100[Hz] (=1 point/0.01[s])
% % 0.01[s] = 10[ms] = 100,000[htk].
% segments = segments * 100000;
% for i = 1:size(labels, 1)
%     fprintf(flabel, '%d %d %s\n', segments(i, 1), segments(i, 2), labels{i});
% end


%% signal file.
%signal = [data.resultVelocity, data.resultFlexionAngle];
%signal = data.resultFlexionAngle;

% number of samples in file (4-byte integer)
%nSamples   = size(signal, 1);
nSamples  = size(HMMfeatures, 1);
% sample period in 100ns units (4-byte integer)
sampPeriod = 1000000.0; % 0.1[s]
% number of bytes per sample (2-byte integer)
sampSize   = size(HMMfeatures, 2)*2;
% a code indicating the sample kind (2-byte integer)
parmKind   = 9; % USER


%% status
% (phone)
% sit (ii): 1
% sit2stand (it): 2
% stand (tt): 3
% stand2sit (ti): 4
% (word)
% SIT2STAND: sit+sit2stand
% STAND2SIT: stand+stand2sit
word = phaseMatrix(:, 3);
word(find(word<3))  = 0; % SIT2STAND
word(find(word>=3)) = 1; % STAND2SIT
phaseMatrix = [phaseMatrix, word];
clear word

word_ = '';
for ii = 1:size(phaseMatrix, 1)
    phaseStart = int64(phaseMatrix(ii, 1) * sampPeriod);
    phaseEnd   = int64(phaseMatrix(ii, 2) * sampPeriod);    
    phase = phaseMatrix(ii, 3);
    word  = phaseMatrix(ii, 4);
    
    switch phase
        case 1
            phaseStr = 'ii';
        case 2
            phaseStr = 'it';
        case 3
            phaseStr = 'tt';
        case 4
            phaseStr = 'ti';
    end % switch
    
    if word == word_
        wordStr = '';
    elseif word == 0
        wordStr = 'SIT2STAND';
    elseif word == 1
        wordStr = 'STAND2SIT';
    end
    fprintf(flabel, '%d %d %s %s\n', phaseStart, phaseEnd, phaseStr, wordStr);
    word_ = word;
end % ii
%fprintf(flabel, '.\n');
fclose(flabel);


% output.
fwrite(fsignal, nSamples, 'integer*4', 'ieee-be');
fwrite(fsignal, sampPeriod, 'integer*4', 'ieee-be');
fwrite(fsignal, sampSize, 'integer*2', 'ieee-be') ;
fwrite(fsignal, parmKind, 'integer*2', 'ieee-be');
fwrite(fsignal, HMMfeatures, 'float', 'ieee-be');
fclose(fsignal);


%% load overview
%load(filePPToverview);
%clear filePPToverview
%load(fileErrorKindTable);
%clear fileErrorKindTable
