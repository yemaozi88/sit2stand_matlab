%
% function makeHTKfiles.
% make a feature file and a label file for HTK.
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%

clear all, fclose all, clc;


%% defaulat values
settings_Sit2Stand;
train_size = 1203;
splitTrainTest = 0;

tic
%% train/test split
load(fileErrorKindTable);
analysisSuccessful = errorKindTable(find(errorKindTable(:, 3)==3), :);

if splitTrainTest
    [X_train, idx] = extractRandomData(analysisSuccessful, train_size);
    analysisSuccessful(idx, :) = [];
    X_test = analysisSuccessful;
    clear analysisSuccessful
    
    save([dirMat '\X_train_HTK.mat'], 'X_train');
    save([dirMat '\X_test_HTK.mat'], 'X_test');
else
    load([dirMat '\X_train_HTK.mat']);
    load([dirMat '\X_test_HTK.mat']);    
end % splitTrainTest


%% feature - train
datakindArray = {'train', 'test'};
for ii = 1:2
    datakind = datakindArray{ii};
    dirOut = [dirHTK '\data\' datakind];
    if strcmp(datakind, 'train')
        X = X_train;
    elseif strcmp(datakind, 'test')
        X = X_test;
    end 
    
    for r = 1:size(X, 1)
        disp(['extracting feature from ' ...
            datakind '-' num2str(r) '/' num2str(size(X, 1)) ' ...']);
        makeHTKfiles(X(r, 1), X(r, 2), dirOut);
    end % r
end % ii
clear ii
toc