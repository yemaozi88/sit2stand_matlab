%
% 2018/12/08
% analyse error features extracted using extractErrorFeatures.m.
%
% NOTES:
% intended to be used for data from Bas.
% 
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%


%% definition
clear all, fclose all, clc;
settings_Sit2Stand;

% % frequency analysis
% samplingFrequency = 100;
% ppHz = 10;
% cutoff = 10;

loadFeatures = 1;
doNormalize = 0;
doPCA = 0;
cleanData = 1;
calcPCA = 1;

    
%% extract features per phase
tic
disp('extracting features...');
if loadFeatures
    load([dirMat '\errorFeatures.mat']);
else
    % cutoff_point = ppHz * cutoff;
    X = [];
    y = [];
    info = [];
    dirlist = dir(dirSimplifiedData);
    for i = 3:size(dirlist, 1)
    %for i = 10:10
        disp([num2str(i) '/' num2str(size(dirlist, 1))])
        filename = dirlist(i).name;
        load([dirSimplifiedData '\' filename]);


        %% error features 
        X_ = extractErrorFeatures(data, doNormalize, doPCA);
        phaseNumMax = size(X_, 1);

        y_ = repmat([data.errorKind], phaseNumMax, 1);

        info_ = repmat([str2num(data.requestID), data.trialNum], phaseNumMax, 1);
        info_ = [info_, (1:phaseNumMax)'];


        %% update
        X = [X; X_];
        y = [y; y_];
        info = [info; info_];
    end % i
    clear dirlist i filename
    clear X_ y_ info_ phaseNumMax
    
    errorFeatures = [info, y, X]; % 3 + 1 + 27;
    save([dirMat '\errorFeatures.mat'], 'errorFeatures');
end % loadFeatures
clear loadFeatures
clear doNormalize doPCA
toc
fprintf('\n');


%% clean data
if cleanData
    disp('clearning data...')
    [X, y, info] = errorFeatures2x(errorFeatures);
    
    % overview
    if 0
        disp('< overview >')
        %       1: analysis error
        %       2: user error, 
        %       3: correct analysis
        %       4: analysis failed
        %       5: dont know
        h = histogram(y);
        for i = 1:5
            fprintf('error kind %d has %d samples.\n', i, h.Values(i));
        end % i
        clear i
        fprintf('\n');
    end
    
    % remove unknown errors.
    %   1: analysis error - 276
    %   2: user error - 8
    %   3: correct analysis - 6475
    %   4: analysis failed - 0
    %   5: dont know - 74
    idx = find(y == 5);
    y(idx, :) = [];
    info(idx, :) = [];
    X(idx, :) = [];
    clear idx
    
    errorFeatures = [info, y, X]; % 3 + 1 + 27;
    save([dirMat '\errorFeatures_cleaned.mat'], 'errorFeatures');

    % normalize using zscore
    Xn = zeros(size(X));
    degMax = size(X, 2);
    z_mu = zeros(degMax, 1);
    z_sigma = zeros(degMax, 1);
    for deg = 1:size(X, 2)
        [Xn(:, deg), z_mu(deg), z_sigma(deg)] = zscore(X(:, deg));
    end % deg
    clear deg degMax
    
    errorFeatures = [info, y, Xn]; % 3 + 1 + 27;
    save([dirMat '\z_mu.mat'], 'z_mu');
    save([dirMat '\z_sigma.mat'], 'z_sigma');
    save([dirMat '\errorFeatures_cleaned_n.mat'], 'errorFeatures');
    
    clear X Xn info y
    clear z_mu z_sigma
    clear errorFeatures
    
    toc
    fprintf('\n');
end
clear cleanData


%% PCA
if calcPCA
    load([dirMat '\errorFeatures_cleaned_n.mat']);
    [X, y, info] = errorFeatures2x(errorFeatures);
    
    tic
    disp('PCA...');
    
    [Evec, Eval, u] = PCA(X);

    % energy occupancy
    EvalNorm = Eval ./ sum(Eval) * 100;
    idx = 1:length(EvalNorm);
    EvalCumsum = cumsum(EvalNorm);
    EvalCumsumIdx = [idx', EvalCumsum];
    disp('- energy occupancy');
    disp(EvalCumsumIdx);

    % plot - EvalCumsum
    if 1
        figure('visible', 'off');
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

    % project features onto the 2 dimensional PCA plane
    if 1
        XPCA = PCA_Trans(X, Evec, u, 2);
 
        figure('visible', 'off');
        hold on
            xlabel('1st Principal Component', 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold');
            ylabel('2nd Principal Component', 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold');

            % analysis OK
            idx = find(y==3); 
            fh = plot(XPCA(idx, 1), XPCA(idx, 2), 'k.', 'MarkerSize', 6);
            
            % analysis error 
            idx = find(y==1);
            fh = plot(XPCA(idx, 1), XPCA(idx, 2), 'rx', 'MarkerSize', 10, 'Linewidth', 2);

            % user error 
            idx = find(y==2);
            fh = plot(XPCA(idx, 1), XPCA(idx, 2), 'bx', 'MarkerSize', 10, 'Linewidth', 2);
            
            legend([{'OK'}; {'analysis error'}; {'user error'}], 'Location', 'southeast');
            set(gca, 'FontName', 'Arial', 'FontSize', 14);
 
            saveas(fh, [dirFig '\PCA.fig']);
            saveas(fh, [dirFig '\PCA.png']);
        hold off
        clear fh
    end % project
    toc
    fprintf('\n');
end
clear calcPCA