function [Duration, Phones, Words, Likelihoods] = readHTKrec(result_rec)
% function [Duration, Phones, Words, Likelihoods] = readHTKrec(result_rec)
% read recognition result made by HVite command of HTK.
%
% INPUT 
% - result_rec: .rec file made by HVite command of HTK.
% OUTPUT
% - Duration: duration of each phone.
% - Phones, Words: corresponding phones and words
%       described in phonelist.txt and dictionary.txt in dirHTK/config.
% - Likelihoods:
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
% requestID = 10858;
% trialNum = 1;
% settings_Sit2Stand;
% result_rec = [dirHTK '\data\test\' ...
%    num2str(requestID) '_' num2str(trialNum) '.rec'];


%% rename for readtable
result_txt = strrep(result_rec, '.rec', '.txt');
copyfile(result_rec, result_txt);


%% read table
% start time, end time, phone, likelihood, word
A = readtable(result_txt, 'Format', '%d %d %s %f %s\n', 'Delimiter', ' ');
Duration    = table2array(A(:, 1:2)) / 100000;
Phones      = table2array(A(:, 3));
Likelihoods = table2array(A(:, 4));
Words       = table2array(A(:, 5));


%% delete the duplicate.
delete(result_txt)