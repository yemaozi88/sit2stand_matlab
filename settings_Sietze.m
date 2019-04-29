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
dirSietze = 'r:\Stagiaires\Sietze de Haan';
dirOut = 'm:\Aki\Data\MachineLearning\from_Sietze\sts';

dirMT        = [dirSietze '\dataMT'];
dirWorkspace = [dirSietze '\workspaces'];

fileRequestIDlist = [dirOut '\requestIDlist.mat'];