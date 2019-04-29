% function errorFeatures = extractErrorFeatures(data, doNormalize, doPCA)
% function errorFeatures = extractErrorFeatures(data, doNormalize, doPCA) 
% extract features which can be used for error analysis.
%
% INPUT:
% - results: MAS analysis results of Sit-to-Stand test.
%
% NOTES:
% this function is intended for simplified data from Bas.
% 
% HISTORY
% 2019/01/03 functionized.
% 
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%


%% test
clear all, fclose all, clc;
requestID = 10623;
trialNum = 2;



%% definition
settings_Sit2Stand;

filename = [num2str(requestID) '_' num2str(trialNum)];
load([dirSimplifiedData '\' filename '.mat']);

% % frequency analysis
% samplingFrequency = 100;
% ppHz = 10;
% cutoff = 10;
settings_Sit2Stand;

    
%% set variables
signal = [data.resultVelocity, data.resultFlexionAngle];


%% error features
axisNumMax = size(signal, 2);
phaseNumMax = size(data.resultPhases, 1);
 
% as of the Slack message from Bas on 2018/11/29.
% phases
%   col 1: start SiSt
%   col 2: max flex SiSt
%   col 3: end SiSt
%   col 4: start StSi
%   col 5: max flex StSi
%   col 6: end StSi
%   col 7&8: (Bas added personally. Not required for this topic).
SiStStart = phases(:, 1);
SiStEnd   = phases(:, 3);
% StSiStart = phases(:, 4);
% StSiEnd   = phases(:, 6);

    
%     % peak location.
%     % one repetition should take more than 0.5 sec. 
%     [peaks, locations] = findpeaks(signal, t, 'MinPeakProminence', 1);
%     tMax = size(signal, 1);
%     t = 1:tMax;
%     t = t';
% % sit_duration is removed, because the matrix is sometimes empty.
%         if isempty(StSi.sit_duration)
%             sit_duration = 0;
%         else
%             sit_duration = StSi.sit_duration;
%         end  
    X = [X;
        SiSt.total_duration(p), ...
        SiSt.flexion_duration(p), ...
        SiSt.extension_duration(p), ...
        SiSt.stand_duration(p), ...
        SiSt.maximum_flexion_angular_velocity(p), ...
        SiSt.maximum_extension_angular_velocity(p), ...
        SiSt.flexion_range(p), ...
        SiSt.extension_range(p), ...
        SiSt.maximum_vertical_velocity(p), ...
        SiSt.mean_power(p), ...
        SiSt.peak_power(p), ...
        SiSt.time_to_peak_power(p), ...
        SiSt.rate_of_power_development(p), ...
        SiSt.peak_rate_of_power_development(p), ...
        StSi.total_duration(p), ...
        StSi.flexion_duration(p), ...
        StSi.extension_duration(p), ...
        StSi.maximum_flexion_angular_velocity(p), ...
        StSi.maximum_extension_angular_velocity(p), ...
        StSi.flexion_range(p), ...
        StSi.extension_range(p), ...
        StSi.minimum_vertical_velocity(p), ...
        StSi.mean_power(p), ...
        StSi.peak_power(p), ...
        StSi.time_to_peak_power(p), ...
        StSi.rate_of_power_development(p), ...
        StSi.peak_rate_of_power_development(p), ...  
        similarity
        ];
end % phase 
    
%     % peak location.
%     % one repetition should take more than 0.5 sec. 
%     [peaks, locations] = findpeaks(signal, t, 'MinPeakProminence', 1);
%     tMax = size(signal, 1);
%     t = 1:tMax;
%     t = t';
% 
%     dispSit2StandSignal(requestID, trialNum, axisNum);
%     hold on
%     plot(locations, signal(locations), 'bo');


%% normalize data
if doNormalize
    try
        load([dirMat '\z_mu.mat']);
        load([dirMat '\z_sigma.mat']);

        z_mu    = z_mu';
        z_sigma = z_sigma';
    
        X = X - z_mu ./ z_sigma
    catch
        warning('mu and/or sigma cannot be loaded. feature is not normalized.');
    end
end


%% PCA
if doPCA
    try
        load([dirMat '\Evec.mat']);
        load([dirMat '\u.mat']);
        X = PCA_Trans(X, Evec, u, PCAdeg);
    catch
        warning('Evec and/or u cannot be loaded. PCA is not performed.\n');
    end
end % end


errorFeatures = X;


dispSit2StandSignal(requestID, trialNum, axisNum);
%     hold on
%     plot(locations, signal(locations), 'bo');

errorFeatures = X;
