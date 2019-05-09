% 
% 2019/03/28
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%

%% definition
clear all, fclose all, clc;

loadRequestIDlist = 0;
loadData = 0;
outputFigSync = 1; 

settings_Sietze;


%% get the list of requestIDs
if loadRequestIDlist
    save([dirOut '\requestIDlist.mat']);
else
    dirlist = dir(dirMT);
    requestIDlist = [];
    for i = 1:size(dirlist, 1)
        if ~strcmp(dirlist(i).name, '.') && ~strcmp(dirlist(i).name, '..')
            requestIDlist = [requestIDlist, str2num(dirlist(i).name)];
        end
    end % for
    requestIDlist = requestIDlist';
    clear i dirlist

    % remove error data.
    requestIDremove = [20208, 20176, 20179];
    requestIDlist = setdiff(requestIDlist, requestIDremove);
    save([dirOut '\requestIDlist.mat'], 'requestIDlist');
end % if
clear loadRequestIDlist
clear dirMT dirOptitrack dirWorkspace


%% synchronization by hand. 
% % the difference between MT_angles.v(:,3) and Opti_angles.v2(:,3).
% load([dirSietze '\MatLab\graph_input.mat']);


%% read Hans's work.
errorList = [];
for requestID_ = 1:length(requestIDlist)
    %tic
    requestID = requestIDlist(requestID_);
    %fprintf('working on request ID: %d (%d/%d)\n',...
    %    requestID, requestID_, length(requestIDlist));
    
    
    %% make gold standard.
    for trialNum = getTrialNumList(requestID)'
        filename = sprintf('%d_%d', requestID, trialNum);
        fileSync = [dirOut '\synced\' filename];
        fileParameters ...
                 = [dirOut '\parameters\goldstandard\' filename '.mat'];
        disp(filename);
    
        try
            %% Sietze work.
%             parameters = makeGoldStandard_Sietze(requestID, trialNum);
%             fileParameters = sprintf('%s\\parameters\\original\\%s.mat', ...
%                 dirOut, filename);

            %% makeGoldStandard.m
%             if loadData
%                 load([fileSync '.mat']);
%             else
%                 % extract relevant information from Hans's workspace.
%                 data = workspace2data(requestID, trialNum);
%                 save([fileSync '.mat'], 'data');
% 
%                 % visualize
%                 if outputFigSync
%                     figure('visible', 'off');
%                     hold on
%                         xlabel('Time [s]', 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold');
%                         ylabel('Sensor output', 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold');
% 
%                         plot(data.MT.angles.v(:, 2), 'k-', 'LineWidth', 2);
%                         plot(data.Opti.angles.v2(:, 2), 'r-', 'LineWidth', 2);    
%                         grid on
% 
%                         legend('MT angles v(2)', 'Opti angles v(2)');
%                         set(gca, 'FontName', 'Arial', 'FontSize', 14);
%                         saveas(gcf, [fileSync '.png']);
%                     hold off
%                 end % outputFigure        
%             end % loadData
%             trialName  = data.input.intervals(trialNum, 5);
%             parameters = makeGoldStandard(data, trialName);
%             save(fileParameters, 'parameters');


            %% compare the result
%             load(fileParameters);
%             p_aki = parameters;
%             clear parameters
%             
%             load([dirOut '\parameters\goldstandard_sietze\' filename '.mat']);
%             p_sietze = parameters;
%             clear parameters
%             
%             compareStructs(p_aki, p_sietze);
        catch
            errorList = [errorList; requestID, trialNum];
        end

    end % trialNum
    %toc
end % for