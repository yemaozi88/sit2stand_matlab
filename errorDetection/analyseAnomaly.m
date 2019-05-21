%
% 2018/12/06
% make anomaly detection system.
% 
% AUTHOR
% Aki Kunikoshi
% a.kunikoshi@gmail.com
%

clear all, fclose all, clc;

%% definition
settings_Sit2Stand;
clear cutoffFrequency frameShift pointPerHz windowSize
clear dirHTK phaseList
clear filePPToverview dirPPT

extractFeature = 0;

% 0: load
% 1: per measurement
% 2: per trial
splitTrainCVTest = 0;
% used only when splitTrainCVTest = 1
dataNum_train = 6000;

dispSampleNum = 1;

%doPCA = 0;


%% load data
if extractFeature
    load(fileErrorKindTable);
    clear fileErrorKindTable
    
    X = [];
    y = [];
    sampleNumMax = size(errorKindTable, 1);
    for i = 1:sampleNumMax
        tic
        requestID = errorKindTable(i, 1);
        trialNum  = errorKindTable(i, 2);
        fprintf('\nrequestID: %d, trialNum: %d (%d/%d)\n', ...
            requestID, trialNum, i, sampleNumMax);

        disp('>>> loading data...');
        [~, results] = loadSit2StandSignal(requestID, trialNum);

        disp('>>> extracting features...');
        X_ = extractErrorFeatures(results);
        X  = [X; X_];
        y_ = repmat(errorKindTable(i, :), size(X_, 1), 1);
        y  = [y; y_];
        toc
    end % i
    clear requestID trialNum results
    clear X_ y_ 
    clear i sampleNumMax

    save([dirMat '\X.mat'], 'X');
    save([dirMat '\y.mat'], 'y');

else
    load([dirMat '\X.mat']);
    load([dirMat '\y.mat']);
    %load([dirMat '\info.mat']);
end % extractFeature
clear extractFeature


%% make train/cv/test data
% A - n x (3+28)
% - col1: requestID
% - col2: trialNum
% - col3: errorKind
%       error kind 1: 276 samples.
%       error kind 2: 8 samples.
%       error kind 3: 6475 samples.
% - col4-end: feature
A = [y, X];
clear X y 

tic
fprintf('train/cv/test data ');

switch splitTrainCVTest
    case 0
        fprintf('is loaded.\n');
        clear dataNum_train
        load([dirMat '\A_train_cv_test.mat']);

    case 1 % per measurement
        fprintf('is made per measurement.\n');
        % number of measurements
        % - control: 6379 (train 6000 + cv/test 379)
        % - error: 318
        dataNum_cv0   = floor(size(find(A(:, 3)==3))/2);
        dataNum_cv1   = floor(size(find(A(:, 3)~=3))/2);

        % correctly analysed.
        idx = find(A(:, 3) == 3);
        A_0 = A(idx, :);
        clear idx

        % analysis failed.
        idx = find(A(:, 3) ~= 3);
        A_1 = A(idx, :);
        clear idx

        % training data
        % only chosen from correctly analysed data.
        [A_train, idx] = extractRandomData(A_0, dataNum_train);
        A_0(idx, :)    = [];
        clear idx

        % cross validation & test data
        % - correctly analysed. 
        [A_cv0, idx] = extractRandomData(A_0, dataNum_cv0);
        A_0(idx, :)  = [];
        A_test0 = A_0;
        clear idx A_0

        % - analysis failed.
        [A_cv1, idx] = extractRandomData(A_1, dataNum_cv1);
        A_1(idx, :)  = [];
        A_test1 = A_1;
        clear idx A_1

        % combine
        A_cv   = [A_cv0; A_cv1];
        A_test = [A_test0; A_test1];
        clear A_cv0 A_cv1 A_test0 A_test1 
        clear dataNum_cv0 dataNum_cv1 dataNum_train

        As = {A_train, A_cv, A_test};
        save([dirMat '\A_train_cv_test.mat'], 'As');     
        clear A_train A_cv A_test
        
    case 2 % per trial
        fprintf('is made per trial.\n');
        clear dataNum_train
        
        % unique requestID + trialID
        [~, iUniqueTrials, ~] = unique(A(:, 1:2), 'rows');
        iA_ = A(iUniqueTrials, 1:3);
        clear iUniqueTrials
    
        % successfully analysed.
        iA_0 = iA_(iA_(:, 3)==3, :);
        % problem analysing data.
        iA_1 = setdiff(iA_, iA_0, 'rows'); 

        % split into train/cv/test data.
        [iA_train, iA_train_] = splitTrainTest(iA_0, 0.8);
        [iA_cv0, iA_test0]    = splitTrainTest(iA_train_, 0.5);
        [iA_cv1, iA_test1]    = splitTrainTest(iA_1, 0.5);
        clear iA_train_ iA_0 iA_1 iA_

        iA_cv   = [iA_cv0; iA_cv1];
        iA_test = [iA_test0; iA_test1];
        clear iA_cv0 iA_cv1 iA_test0 iA_test1

        iAs = {iA_train, iA_cv, iA_test};
        clear iA_train iA_cv iA_test
    
        % extract correspoinding measurements. 
        As = {};
        for setNum = 1:3 % train cv test
            a = iAs{setNum};
            data = [];
            for i = 1:size(a, 1)
                % A or a
                % col 1: requestID
                % col 2: trialNum
                data_ = A(find(A(:, 1) == a(i, 1) & A(:, 2) == a(i, 2)), :);
                data  = [data; data_];
            end
            clear i data_ a
            As{setNum} = data;
            %info{setNum} = data(:, 1:3);
            %y{setNum} = data(:, 4);
            %X{setNum} = data(:, 5:end);
        end % setNum
    clear setNum iAs
    save([dirMat '\A_train_cv_test.mat'], 'As');     
end % splitTrainCVTest
clear splitTrainCVTest
toc

if dispSampleNum
    % display the number of samples in train/cv/test set.
    A_train = As{1};
    A_cv    = As{2};
    A_test  = As{3};
    
    dataNum_train = size(A_train, 1);
    dataNum_cv    = size(A_cv, 1);
    dataNum_test  = size(A_test, 1); 

    dataNum_cv0 = size(find(A_cv(:, 3) == 3), 1);
    dataNum_cv1 = size(find(A_cv(:, 3) ~= 3), 1);
    dataNum_test0 = size(find(A_test(:, 3) == 3), 1);
    dataNum_test1 = size(find(A_test(:, 3) ~= 3), 1);

    fprintf('\n')
    disp(['train data has ' num2str(dataNum_train) ' measurements (all control).']);
    disp(['cv data has ' num2str(dataNum_cv) ' measurements (' ...
        num2str(dataNum_cv0) ' control + ' num2str(dataNum_cv1) ' error).']);
    disp(['test data has ' num2str(dataNum_test) ' measurements (' ...
        num2str(dataNum_test0) ' control + ' num2str(dataNum_test1) ' error).']);
    clear dataNum_cv0 dataNum_cv1 dataNum_test0 dataNum_test1
    clear A_train A_cv A_test
end 


% %% normalize data
% if 0
%     try
%         load([dirMat '\z_mu.mat']);
%         load([dirMat '\z_sigma.mat']);
% 
%         z_mu    = z_mu';
%         z_sigma = z_sigma';
%     
%         X = X - z_mu ./ z_sigma
%     catch
%         warning('mu and/or sigma cannot be loaded. feature is not normalized.');
%     end
% end
% 
% 
% %% PCA
% if 0
%     try
%         load([dirMat '\Evec.mat']);
%         load([dirMat '\u.mat']);
%         X = PCA_Trans(X, Evec, u, PCAdeg);
%     catch
%         warning('Evec and/or u cannot be loaded. PCA is not performed.\n');
%     end
% end % end
% errorFeatures = X;



% % =============== ITERATION ===============
% %  7: 80.1964
% % 11: 90.2501
% % 15: 95.4386
% % 21: 99.3237
% Result_cv   = [];
% Result_test = [];
% for dim = [7, 14, 21, 28, 35]
%     for mixNum = [1, 4, 16, 64, 256]
%         disp(['dim:' num2str(dim) ' mix: ' num2str(mixNum)]);
% % =============== ITERATION ===============
% 
% 
% 
% %% train GMM
% if doPCA
%     [Evec, Eval, u] = PCA(X{1});
%     save([dirMat '\Evec.mat'], 'Evec');
%     save([dirMat '\Eval.mat'], 'Eval');
%     save([dirMat '\u.mat'], 'u');
%     
%     % energy occupancy
%     EvalNorm = Eval ./ sum(Eval) * 100;
%     idx = 1:length(EvalNorm);
%     EvalCumsum = cumsum(EvalNorm);
%     EvalCumsumIdx = [idx', EvalCumsum];
%     %disp('- energy occupancy');
%     %disp(EvalCumsumIdx(1:137, :));
%     
%     % plot - EvalCumsum
%     if 0
%         figure('visible', 'on');
%         hold on
%             xlabel('Number of PC', 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold');
%             ylabel('Energy occupancy', 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold');
% 
%             fh = plot(EvalCumsum, 'ko-', 'MarkerSize', 3, 'LineWidth', 2);
%             grid;
%             xlim([0 30])
% %             ylim([0 100])
%             set(gca, 'FontName', 'Arial', 'FontSize', 14);
% 
%             saveas(fh, [dirFig '\PCA_VariableNum.fig']);
%             saveas(fh, [dirFig '\PCA_VariableNum.png']);
%         hold off
%         clear fh
%     end 
%     
%     for setNum = 1:3
%         X{setNum} = PCA_Trans(X{setNum}, Evec, u, dim);
%     end % setNum
% end % doPCA
% 
% obj = trainGMM(X{1}, mixNum, 1);
% save([dirMat '\obj_dim' num2str(dim) '_mix' num2str(mixNum) '.mat'], 'obj');
% 
% 
% %% performance in cv
% for setNum = 2:3
%     info_ = info{setNum};
%     X_    = X{setNum};
%     y_    = y{setNum};
%     uniqueTrials = unique(info_(:, 1:2), 'rows');
%     probability = [];
%     answers = [];
%     %hold on
%     for n = 1:size(uniqueTrials, 1)
%         idx = find(info_(:, 1) == uniqueTrials(n, 1) & info_(:, 2) == uniqueTrials(n, 2));
%         % for all phases
%         x = X_(idx, :);
%         prob = pdf(obj, x);
%         errorNum = unique(y_(idx));
%         probability = [probability; mean(prob)];
%         answers     = [answers; errorNum];
%     %     if errorNum == 3
%     %         %plot(prob, 'bo-', 'LineWidth', 2);
%     %         scatter(0, mean(prob), 'bo');
%     %     else
%     %         %plot(prob, 'ro-', 'LineWidth', 2);
%     %         scatter(1, mean(prob), 'ro');
%     %     end % errorNum
%         %ylim([0, 0.0005]);
%     end % n
%     %hold off
%     clear idx n
% 
%     % threshold
%     if setNum == 2
%         threshold = max(probability(find(probability(:, 1)~=3, 1)));
%     end % if
%     
%     predictions = probability<threshold;
%     answers_ = answers~=3;
%     [results, resultsVector] = calcPerformance(predictions, answers_);
%     
%     fprintf('\n');
%     result_ = [dim, mixNum, resultsVector];
%     switch setNum
%         case 2
%             %disp('<< performance in CV set >>');
%             Result_cv   = [Result_cv; result_];
%         case 3
%             %disp('<< performance in CV set >>');
%             Result_test = [Result_test; result_];
%     end % switch
%     
%     %results
% end % setNum
% 
% 
% % =============== ITERATION ===============
%     end % mixNum
% end % dim
% save([dirMat '\Result_cv.mat'], 'Result_cv');
% save([dirMat '\Result_test.mat'], 'Result_test');
% % =============== ITERATION ===============