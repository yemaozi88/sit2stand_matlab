% 
% 2019/04/18
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%
clear all, fclose all, clc;

makeGoldStandard;
p1 = parameters;
load('m:\Aki\Data\MachineLearning\from_Sietze\sts\parameters\original\20121_1.mat');
p2 = parameters;
clear parameters

compareStructs(p1, p2)