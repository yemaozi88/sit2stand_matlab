function Durations = states2durations(states)
% function Durations = states2durations(states)
% get start and end time of each state.
%
% INPUT 
% - states: nx1 int vector.
% OUTPUT
% - Durations: nx2 int matrix. col1: start, col2: end.
%
% HISTORY
% 2019/02/14 functionized.
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%
stateEnd   = find(diff(states)~=0);
stateStart = [0; stateEnd(1:end-1)+1];
states_ = states;
states_(diff(states)==0) = [];
Durations = [stateStart, stateEnd, states_(1:end-1)];
Durations = [Durations; stateEnd(end)+1, size(states, 1), states_(end)];
