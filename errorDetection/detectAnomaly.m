%
% 2018/12/06
% make anomaly detection system.
% 
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%

%% definition
clear all, fclose all, clc;
settings_Sit2Stand;

%extractErrorFeatures;

% process
dispSampleNum = 0;
splitTrainCVTest = 0;
doPCA = 1;


% make train/cv/test data
% % - error kind 1 has 276 samples.
% % - error kind 2 has 8 samples.
% % - error kind 3 has 6475 samples.
% dataNum_train = 6000;
% dataNum_cv0   = 300;
% dataNum_cv1   = 59;


%% load data
%load([dirMat '\X.mat']);
%load([dirMat '\y.mat']);
%load([dirMat '\info.mat']);
% errorFeatures = [info, y, X]; % 3 + 1 + 27
load([dirMat '\errorFeatures_n.mat']);
A = errorFeatures_n;
clear errorFeatures


%% make train/cv/test data
tic
if splitTrainCVTest
    disp('make train/cv/test data');

    %% per measurement
    % % data - correctly analysed.
    % idx   = find(y == 3);
    % X_0    = X(idx, :);
    % y_0    = y(idx, :);
    % info_0 = info(idx, :);
    % clear idx
    % 
    % % data - analysis failed.
    % idx   = find(y ~= 3);
    % X_1    = X(idx, :);
    % y_1    = y(idx, :);
    % info_1 = info(idx, :);
    % clear idx
    % 
    % 
    % % training data
    % [X_train, idx] = extractRandomData(X_0, dataNum_train);
    % y_train       = y_0(idx, :);
    % info_train    = info_0(idx, :);
    % X_0(idx, :)    = [];
    % y_0(idx, :)    = [];
    % info_0(idx, :) = [];
    % clear idx
    % 
    % % cross validation & test data
    % % - correctly analysed. 
    % [X_cv0, idx] = extractRandomData(X_0, dataNum_cv0);
    % y_cv0       = y_0(idx, :);
    % info_cv0    = info_0(idx, :);
    % X_0(idx, :)    = [];
    % y_0(idx, :)    = [];
    % info_0(idx, :) = [];
    % X_test0 = X_0;
    % y_test0 = y_0;
    % info_test0 = info_0;
    % clear idx
    % clear X_0 y_0 info_0
    % 
    % % - analysis failed.
    % [X_cv1, idx] = extractRandomData(X_1, dataNum_cv1);
    % y_cv1       = y_1(idx, :);
    % info_cv1    = info_1(idx, :);
    % X_1(idx, :)    = [];
    % y_1(idx, :)    = [];
    % info_1(idx, :) = [];
    % X_test1 = X_1;
    % y_test1 = y_1;
    % info_test1 = info_1;
    % clear idx
    % clear X_1 y_1 info_1
    % clear idx
    % 
    % % combine
    % X_cv    = [X_cv0; X_cv1];
    % y_cv    = [y_cv0; y_cv1];
    % info_cv = [info_cv0; info_cv1];
    % clear X_cv0 X_cv1 y_cv0 y_cv1 info_cv0 info_cv1
    % 
    % X_test    = [X_test0; X_test1];
    % y_test    = [y_test0; y_test1];
    % info_test = [info_test0; info_test1];
    % clear X_test0 X_test1 y_test0 y_test1 info_test0 info_test1
    % 
    % clear cutoff dataNum_cv0 dataNum_cv1 dataNum_train
    
    
    %% per trial
    [~, iUniqueTrials, ~] = unique(A(:, 1:2), 'rows'); % unique requestID + trialID
    A_ = A(iUniqueTrials, 1:4);
    clear iUniqueTrials
    
    A0 = A_(A_(:, 4)==3, :); % successfully analysed.
    A1 = setdiff(A_, A0, 'rows'); % problem analysing data.

    % split into train/cv/test data.
    [A_train, A_train_] = splitTrainTest(A0, 0.8);
    [A_cv0, A_test0]    = splitTrainTest(A_train_, 0.5);
    [A_cv1, A_test1]    = splitTrainTest(A1, 0.5);
    clear A_train_ A0 A1 A_

    A_cv   = [A_cv0; A_cv1];
    A_test = [A_test0; A_test1];
    clear A_cv0 A_cv1 A_test0 A_test1

    As = {A_train, A_cv, A_test};
    clear A_train A_cv A_test
    save([dirMat '\list_train_cv_test.mat'], 'As');
    
    
else
    load([dirMat '\list_train_cv_test.mat']);
end % splitTrainCVTest
%clear splitTrainCVTest
toc

if dispSampleNum
    % display the number of samples in train/cv/test set.
    A_train = As{1};
    A_cv    = As{2};
    A_test  = As{3};
    
    dataNum_train = size(A_train, 1);
    dataNum_cv    = size(A_cv, 1);
    dataNum_test  = size(A_test, 1); 

    dataNum_cv0 = size(find(A_cv(:, 4) == 3), 1);
    dataNum_cv1 = size(find(A_cv(:, 4) ~= 3), 1);
    dataNum_test0 = size(find(A_test(:, 4) == 3), 1);
    dataNum_test1 = size(find(A_test(:, 4) ~= 3), 1);

    fprintf('\n')
    disp('<< per trial >>')
    disp(['train data has ' num2str(dataNum_train) ' measurements (all control).']);
    disp(['cv data has ' num2str(dataNum_cv) ' measurements (' ...
        num2str(dataNum_cv0) ' control + ' num2str(dataNum_cv1) ' error).']);
    disp(['test data has ' num2str(dataNum_test) ' measurements (' ...
        num2str(dataNum_test0) ' control + ' num2str(dataNum_test1) ' error).']);
    clear dataNum_cv0 dataNum_cv1 dataNum_test0 dataNum_test1
    clear A_train A_cv A_test
end 


% =============== ITERATION ===============
%  7: 80.1964
% 11: 90.2501
% 15: 95.4386
% 21: 99.3237
Result_cv   = [];
Result_test = [];
for dim = [7, 14, 21, 28, 35]
    for mixNum = [1, 4, 16, 64, 256]
        disp(['dim:' num2str(dim) ' mix: ' num2str(mixNum)]);
% =============== ITERATION ===============

if 1
    % extract corresponding measurements.
    % As = {A_train, A_cv, A_test};
    % A  = [info, y, X]; % 3 + 1 + 27
    info = {};
    y = {};
    X = {};
    for setNum = 1:3
        a = As{setNum};
        data = [];
        for i = 1:size(a, 1)
            % A or a
            % col 1: requestID
            % col 2: trialNum
            data_ = A(find(A(:, 1) == a(i, 1) & A(:, 2) == a(i, 2)), :);
            data  = [data; data_];
        end
        clear i data_ a
        info{setNum} = data(:, 1:3);
        y{setNum} = data(:, 4);
        X{setNum} = data(:, 5:end);
    end % setNum
    clear setNum
    
    if dispSampleNum
        fprintf('\n')
        disp('<< per phase >>')
        disp(['train data has ' num2str(size(y{1}, 1)) ' phases.']);
        disp(['cv data has ' num2str(size(y{2}, 1)) ' phases.']);
        disp(['test data has ' num2str(size(y{3},1)) ' phases.']);
    end % dispSampleNum
    %clear A
end % if


%% train GMM
if doPCA
    [Evec, Eval, u] = PCA(X{1});
    save([dirMat '\Evec.mat'], 'Evec');
    save([dirMat '\Eval.mat'], 'Eval');
    save([dirMat '\u.mat'], 'u');
    
    % energy occupancy
    EvalNorm = Eval ./ sum(Eval) * 100;
    idx = 1:length(EvalNorm);
    EvalCumsum = cumsum(EvalNorm);
    EvalCumsumIdx = [idx', EvalCumsum];
    %disp('- energy occupancy');
    %disp(EvalCumsumIdx(1:137, :));
    
    % plot - EvalCumsum
    if 0
        figure('visible', 'on');
        hold on
            xlabel('Number of PC', 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold');
            ylabel('Energy occupancy', 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold');

            fh = plot(EvalCumsum, 'ko-', 'MarkerSize', 3, 'LineWidth', 2);
            grid;
            xlim([0 30])
%             ylim([0 100])
            set(gca, 'FontName', 'Arial', 'FontSize', 14);

            saveas(fh, [dirFig '\PCA_VariableNum.fig']);
            saveas(fh, [dirFig '\PCA_VariableNum.png']);
        hold off
        clear fh
    end 
    
    for setNum = 1:3
        X{setNum} = PCA_Trans(X{setNum}, Evec, u, dim);
    end % setNum
end % doPCA

obj = trainGMM(X{1}, mixNum, 1);
save([dirMat '\obj_dim' num2str(dim) '_mix' num2str(mixNum) '.mat'], 'obj');


%% performance in cv
for setNum = 2:3
    info_ = info{setNum};
    X_    = X{setNum};
    y_    = y{setNum};
    uniqueTrials = unique(info_(:, 1:2), 'rows');
    probability = [];
    answers = [];
    %hold on
    for n = 1:size(uniqueTrials, 1)
        idx = find(info_(:, 1) == uniqueTrials(n, 1) & info_(:, 2) == uniqueTrials(n, 2));
        % for all phases
        x = X_(idx, :);
        prob = pdf(obj, x);
        errorNum = unique(y_(idx));
        probability = [probability; mean(prob)];
        answers     = [answers; errorNum];
    %     if errorNum == 3
    %         %plot(prob, 'bo-', 'LineWidth', 2);
    %         scatter(0, mean(prob), 'bo');
    %     else
    %         %plot(prob, 'ro-', 'LineWidth', 2);
    %         scatter(1, mean(prob), 'ro');
    %     end % errorNum
        %ylim([0, 0.0005]);
    end % n
    %hold off
    clear idx n

    % threshold
    if setNum == 2
        threshold = max(probability(find(probability(:, 1)~=3, 1)));
    end % if
    
    predictions = probability<threshold;
    answers_ = answers~=3;
    [results, resultsVector] = calcPerformance(predictions, answers_);
    
    fprintf('\n');
    result_ = [dim, mixNum, resultsVector];
    switch setNum
        case 2
            %disp('<< performance in CV set >>');
            Result_cv   = [Result_cv; result_];
        case 3
            %disp('<< performance in CV set >>');
            Result_test = [Result_test; result_];
    end % switch
    
    %results
end % setNum


% =============== ITERATION ===============
    end % mixNum
end % dim
save([dirMat '\Result_cv.mat'], 'Result_cv');
save([dirMat '\Result_test.mat'], 'Result_test');
% =============== ITERATION ===============