% 
% 2019/04/11
% make joint vectors from Sietze's data.
%
% NOTE
% this work is inspired by statistical voice conversion.
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%

%% definition
clear all, fclose all, clc;
dirFeature = 'm:\Aki\Data\MachineLearning\from_Sietze\sts\synced';


%% process data.
tic
disp('>>> loading data... ');
dirlist = dir([dirFeature '\*.mat']);
X = [];
for i = 1:size(dirlist, 1)
%for i = 1:1    
    if ~strcmp(dirlist(i).name, '.') && ~strcmp(dirlist(i).name, '..')
        filename = dirlist(i).name;
        disp(filename)
        load([dirFeature '\' filename]);
        
        mt = [...
            data.MT.linear.a, ...
            data.MT.linear.v, ...
            data.MT.linear.x, ...
            data.MT.angles.a, ...
            data.MT.angles.v, ...
            data.MT.angles.x ...
            ];
        ot = [...
            data.Opti.linear.v, ...
            data.Opti.linear.x, ...
            data.Opti.angles.v, ...
            data.Opti.angles.x ...
            ];

        mtd = adddelta(mt');       
        mtn = normalize(mtd');
        X = [X; ...
            mt, mtn, ...
            ot, normalize(ot)];
 
    end % filename is not '.' and '..'
end % for
clear filename i dirlist
clear data mt ot mtn mtd
toc


