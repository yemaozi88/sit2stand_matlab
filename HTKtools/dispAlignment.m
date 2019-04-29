function dispAlignment(requestID, trialNum, axisNum, phaseNum)
% function dispAlignment(requestID, trialNum, axisNum, phaseNum)
%
% HISTORY
% 2019/02/14 functionized.
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%


%% test
% clear all, fclose all, clc;
% requestID = 11203;
% trialNum = 1;
% axisNum = 1;
% phaseNum = 3;


%% initial settings.
settings_Sit2Stand;
filename = [num2str(requestID) '_' num2str(trialNum)];


%% load signal.
load([dirSimplifiedData '\' filename '.mat']);
[states, signal] = extractStates(data);
Durations_ = states2durations(states);


%% load HTK recognition result.
result_rec = [dirHTK '\data\test\' filename '.rec'];
[Durations, Phones, Words, Likelihoods] = readHTKrec(result_rec);


%% display
% sit (ii): 1
% sit2stand (it): 2
% stand (tt): 3
% stand2sit (ti): 4
plot(signal(:, axisNum), 'k', 'Linewidth', 2);
hold on
% sit
idxs_ = find(Durations_(:, 3)==phaseNum);
if ~isempty(idxs_)
    dur_ = Durations_(idxs_, :);
    for idx = 1:size(idxs_, 1)
        durStart = Durations_(idxs_(idx), 1)+1;
        durEnd   = Durations_(idxs_(idx), 2)+1;
        t = durStart:durEnd;
        plot(t', signal(durStart:durEnd, axisNum), 'r', 'Linewidth', 2)
    end
end 
idxs = find(strcmp(Phones, phaseList{phaseNum}));
if ~isempty(idxs)
    dur = Durations(idxs, :);
    for idx = 1:size(idxs, 1)
        durStart = Durations(idxs(idx), 1)+1;
        durEnd   = Durations(idxs(idx), 2)+1;
        disp([num2str(durStart) '-' num2str(durEnd)])
        t = durStart:durEnd;
        plot(t', signal(durStart:durEnd, axisNum), 'b', 'Linewidth', 2)
    end
end 

hold off