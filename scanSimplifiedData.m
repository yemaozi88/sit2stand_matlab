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
settings;

    
%% scan
tic
dirlist = dir(dirData);
errorKindTable = [];
for i = 3:size(dirlist, 1)
%for i = 10:10
    filename = dirlist(i).name;
    load([dirData '\' filename]);
    x = [str2num(data.requestID), data.trialNum, data.errorKind];
    errorKindTable = [errorKindTable; x]; 
end % i
clear dirlist i filename
clear x
toc