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
outputFigure = 1;
settings_Sietze;


%% get the list of requestIDs
if loadRequestIDlist
    save([dirOut '\requestIDlist']);
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
    requestIDremove = [20176, 20179];
    requestIDlist = setdiff(requestIDlist, requestIDremove);
    save([dirOut '\requestIDlist'], 'requestIDlist');
end % if
clear loadRequestIDlist
clear dirMT dirOptitrack dirWorkspace


%% synchronization by hand. 
% the difference between MT_angles.v(:,3) and Opti_angles.v2(:,3).
load([dirSietze '\MatLab\graph_input.mat']);


%% read Hans's work.
for requestID_ = 1:length(requestIDlist)
    tic
    requestID = requestIDlist(requestID_);
    fileOut = [dirOut '\synced\', num2str(requestID)];

    fprintf('working on request ID: %d (%d/%d)\n',...
        requestID, requestID_, length(requestIDlist));

    
    %% extract relevant information from Hans's workspace.
    data = workspace2data(requestID);
    save([fileOut '.mat'], 'data');
    
    
    %% visualize
    if outputFigure
        figure('visible', 'off');
        hold on
            xlabel('Time [s]', 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold');
            ylabel('Sensor output', 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold');

            plot(data.MT.angles.v(:, 2), 'k-', 'LineWidth', 2);
            plot(data.Opti.angles.v2(:, 2), 'r-', 'LineWidth', 2);    
            grid on
        %     xlim([0 5000])
            legend('MT angles v(2)', 'Opti angles v(2)');
            set(gca, 'FontName', 'Arial', 'FontSize', 14);

            saveas(gcf, [fileOut '.png']);
        hold off
    end % outputFigure
    toc
end % for