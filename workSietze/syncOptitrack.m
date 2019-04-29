% 
% 2019/03/28
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%

%% definition
clear all, fclose all, clc;
dirHansWork  = 'r:\Stagiaires\Sietze de Haan';
dirMT        = 'r:\Stagiaires\Sietze de Haan\dataMT';
dirOptitrack = 'r:\Stagiaires\Sietze de Haan\dataOptitrack';
dirWorkspace = 'r:\Stagiaires\Sietze de Haan\workspaces';
dirOut       = 'm:\Aki\Data\MachineLearning\from_Sietze\sts';

loadRequestIDlist = 0;


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


%% synchronization by hand. 
% the difference between MT_angles.v(:,3) and Opti_angles.v2(:,3).
load([dirHansWork '\MatLab\graph_input.mat']);


%% read Hans work.
for requestID_ = 1:length(requestIDlist)
    requestID = requestIDlist(requestID_);
    fileOut = [dirOut '\synced\', num2str(requestID)];
    disp(['working on request ID: ', num2str(requestID)]);

    workspaceName = [dirWorkspace '\workspace' num2str(requestID)];
    load(workspaceName);

    data.requestID = requestID;
    data.t = t_opti2;
    data.shift = ...
        floor(graph_input(find(graph_input(:, 1)==requestID), 2) * fs.beide);
    data.samplingFrequency = fs.beide;

    syncEnd = min(length(MT_angles.v), length(Opti_angles.v2));
    syncPeriod = 1:syncEnd;

    data.MT.linear.a = MT_linear.a(syncPeriod+data.shift, :);
    data.MT.linear.v = MT_linear.v(syncPeriod+data.shift, :);
    data.MT.linear.x = MT_linear.x(syncPeriod+data.shift, :);

    data.MT.angles.a = MT_angles.a(syncPeriod+data.shift, :);
    data.MT.angles.v = MT_angles.v(syncPeriod+data.shift, :);
    data.MT.angles.x = MT_angles.x(syncPeriod+data.shift, :);

    data.Opti.linear.v = Opti_linear.v2;
    data.Opti.linear.x = Opti_linear.x2;

    data.Opti.angles.v = Opti_angles.v2;
    data.Opti.angles.x = Opti_angles.x2;
    
    save([fileOut, '.mat'], 'data');       
    clear syncEnd syncPeriod


    %% visualize
    figure('visible', 'off');
    hold on
        xlabel('Time [s]', 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold');
        ylabel('Sensor output', 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold');

        plot(data.MT.angles.v(:, 2), 'k-', 'LineWidth', 2);
        plot(data.Opti.angles.v(:, 2), 'r-', 'LineWidth', 2);    
        grid on
    %     xlim([0 5000])
        legend('MT angles v(2)', 'Opti angles v(2)');
        set(gca, 'FontName', 'Arial', 'FontSize', 14);

        saveas(gcf, [fileOut '.png']);
    hold off


    %% remove unnecessary variables.
    clear resample_verhouding verschuiving
    clear fs t_MT t_opti t_opti2
    clear iReqID reqID_all
    clear McRoberts_input McRoberts_output
    clear metadata workspaceName
    clear MT_angles MT_linear
    clear Opti_angles Opti_linear
    clear coordinaten
    clear data X
end % for