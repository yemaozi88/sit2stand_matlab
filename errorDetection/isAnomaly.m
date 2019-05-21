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

% process
doPCA = 1;


%% load data
%load([dirMat '\X.mat']);
%load([dirMat '\y.mat']);
%load([dirMat '\info.mat']);
% errorFeatures = [info, y, X]; % 3 + 1 + 27
load([dirMat '\errorFeatures_n.mat']);
A = errorFeatures_n;
clear errorFeatures


%% make train/cv/test data
load([dirMat '\list_train_cv_test.mat']);


%  7: 80.1964
% 11: 90.2501
% 15: 95.4386
% 21: 99.3237
dim = 28;
mixNum = 256;
disp(['dim:' num2str(dim) ' mix: ' num2str(mixNum)]);


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