%
% 2019/05/22
% anomaly detection system 
% based on the error analysis (analyseAnomaly.m) 
% 
% INPUT
% - results: MAS output of Sit2Stand test.
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

fileObj = 'obj_mix1024.mat';
fileThreshold = 'threshold_mix1024.mat';


%% test
requestID = 8900;
trialNum  = 1;
[~, results] = loadSit2StandSignal(requestID, trialNum);



%% check data
disp('>>> extracting features...');
X = extractErrorFeatures(results);


%% normalize data
disp('>>> normalizing the features...');
try
    load([dirMat '\z_mu.mat']);
    load([dirMat '\z_sigma.mat']);
catch
    error('mu and/or sigma cannot be loaded. feature is not normalized.');
end % try
fprintf('\nfeatures are normalized.\n');
X = X - z_mu ./ z_sigma;


%% prediction using GMM
disp('>>> loading the GMM object...');
try
    load([dirMat '\' fileObj]);
    load([dirMat '\' fileThreshold]);
catch
    error('obj cannot be loaded.');
end % try

% prediction
probability = mean(pdf(obj, x));


        predictions = probability<threshold;
        answers_ = answers~=3;
        [results, resultsVector] = calcPerformance(predictions, answers_);
        fprintf('\ndim: %d, mix: %d, F1score: %f\n', ...
            PCAdim, mixNum, results.F1);
        
        result_ = [PCAdim, mixNum, resultsVector];
        switch i
            case 2
                %disp('<< performance in CV set >>');
                Result_cv   = [Result_cv; result_];
            case 3
                %disp('<< performance in CV set >>');
                Result_test = [Result_test; result_];
        end % switch

        %results
    end % setNum

end % mixNum
save([dirMat '\Result_cv.mat'], 'Result_cv');
save([dirMat '\Result_test.mat'], 'Result_test');