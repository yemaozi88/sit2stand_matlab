function gcf = dispSit2StandPhase(data, trialName, parameters, dispFigure)
% function gcf = dispSit2StandPhase(data, trialName, parameters, dispFig)
% display phases of Sit2Stand signal. 
%
% INPUT
% - data.
% - parameters.
% - trialName: the name of trial. Can be obtained as
% data.input.intervals(trialNum, 5).
% - dispFigure (optional): if display figures. Default value is 1.
%
% NOTES
% data.Opti as gold standard.
% data.MT as an estimated values (start and end are plotted).
% 
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%


%% default values.
settings_Sietze;
switch nargin
    case 3
        dispFigure = 1;
    case 4
    otherwise
        error('Please check the arguments.');
end


%% index for the graph
% based on the makeGoldStandard_Sietze.m.
t = data.output.STSperiod(1)-(data.output.shift_sec*data.samplingFrequency)...
    :data.output.STSperiod(2)-(data.output.shift_sec*data.samplingFrequency);
t = round(t);
            
% bepaal de lengte van een periode en knip adhv de periode het
% signaal wat smaller.
[indices, periode] = periode_bepaling(trialName, t, data.Opti.linear.v2(:,1));
t = signaal_knippen(periode, indices);


%% plot
if dispFigure
    figure('visible', 'on');
else
    figure('visible', 'off');
end
hold on
    xlabel('Frame No', 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold');
    ylabel('Sensor output', 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold');

    plot(t, data.Opti.linear.x2(t, 1), 'k-', 'LineWidth', 2); %VT positie

    
    %% Gold standard based on Optitrack.
    Sit2Stand = [parameters.Opti.Start_Sit_To_Stand, parameters.Opti.End_Sit_To_Stand];
    Stand2Sit = [parameters.Opti.Start_Stand_To_Sit, parameters.Opti.End_Stand_To_Sit];
    for i = 1:parameters.Opti.TotaalStS
        tSit2Stand = t(Sit2Stand(i, 1):Sit2Stand(i, 2));
        tStand2Sit = t(Stand2Sit(i, 1):Stand2Sit(i, 2));
        plot(tSit2Stand, data.Opti.linear.x2(tSit2Stand, 1), 'r-', 'LineWidth', 2);
        plot(tStand2Sit, data.Opti.linear.x2(tStand2Sit, 1), 'b-', 'LineWidth', 2);        
    end % i
    
    
    %% Estimated.
    for i = 1:parameters.MT.TotaalStS
        % start Sit-to-Stand
        t_ = t(parameters.MT.Start_Sit_To_Stand(i, 1));
        plot(t_, data.Opti.linear.x2(t_, 1), 'ro', ...
            'LineWidth', 2, 'MarkerSize', 10);
        % end Sit-to-Stand
        t_ = t(parameters.MT.End_Sit_To_Stand(i, 1));
        plot(t_, data.Opti.linear.x2(t_, 1), 'rx', ...
            'LineWidth', 2, 'MarkerSize', 10);
        % start Stand-to-Sit
        t_ = t(parameters.MT.Start_Stand_To_Sit(i, 1));
        plot(t_, data.Opti.linear.x2(t_, 1), 'bo', ...
            'LineWidth', 2, 'MarkerSize', 10);
        % end Stand-to-Sit
        t_ = t(parameters.MT.End_Stand_To_Sit(i, 1));
        plot(t_, data.Opti.linear.x2(t_, 1), 'bx', ...
            'LineWidth', 2, 'MarkerSize', 10);
    end % i
    
    legend('Opti angles v', 'Sit2Stand', 'Stand2Sit');
    set(gca, 'FontName', 'Arial', 'FontSize', 14);
    %saveas(gcf, [fileSync '.png']);
hold off

