function save_parameters_to_mat(i, reqID, parameters, subject_code)
% function save_parameters_to_mat(i, reqID, parameters, subject_code)
% Alle parameters en metadata worden in een matfile opgeslagen.
%
% Input: i,
%        reqID,
%        parameters,
%        subject_code
% Output: -

% Voorbewerking voor opslaan.
parameters.Opti.TotaalTijd = repmat(parameters.Opti.TotaalTijd, parameters.Opti.TotaalStS, 1);
parameters.Opti.TotaalStS = repmat(parameters.Opti.TotaalStS, parameters.Opti.TotaalStS, 1);
parameters.MT.TotaalStS = repmat(parameters.MT.TotaalStS, parameters.Opti.TotaalStS(1), 1);
parameters.MT.TotaalTijd = repmat(parameters.MT.TotaalTijd, parameters.Opti.TotaalStS(1), 1);
parameters.RMSE.trunkangle.abs = repmat(parameters.RMSE.trunkangle.abs, parameters.Opti.TotaalStS(1),1);
parameters.RMSE.trunkangle.rel = repmat(parameters.RMSE.trunkangle.rel, parameters.Opti.TotaalStS(1),1);
parameters.RMSE.verticalspeed.abs = repmat(parameters.RMSE.verticalspeed.abs, parameters.Opti.TotaalStS(1),1);
parameters.RMSE.verticalspeed.rel = repmat(parameters.RMSE.verticalspeed.rel, parameters.Opti.TotaalStS(1),1);
parameters.metadata.reqID = repmat(reqID,parameters.Opti.TotaalStS(1),1);
parameters.metadata.subject = repmat({subject_code},parameters.Opti.TotaalStS(1),1);
parameters.metadata.protocol = repmat(parameters.metadata.volgorde(i),parameters.Opti.TotaalStS(1),1);
parameters.metadata.StSnr = (1:parameters.Opti.TotaalStS(1))';

if exist('parametersfile.mat','file') == 0
    % parameters opslaan
    parametersfile = parameters;
else
    % Vectoren met velden aanmaken om makkelijk te kunnen loopen.
    VeldenMetadata = {'reqID','subject','protocol','StSnr'};
    VeldenParameters = {'Start_Sit_To_Stand','End_Sit_To_Stand','Start_Stand_To_Sit','End_Stand_To_Sit','TijdSitSt','TijdSttSi','TotaalStS','TotaalTijd'};
    VeldenRMSE = {'trunkangle','verticalspeed'};
    subVeldenRMSE = {'abs','rel'};
    
    % parametersfile inladen en invulrijen bepalen
    load('parametersfile.mat')
    parametersfile.rij = (size(parametersfile.Opti.TotaalTijd,1)+1):size(parametersfile.Opti.TotaalTijd,1)+parameters.Opti.TotaalStS(1);
    
    % parameters opslaan
    for iVeld = VeldenMetadata
        parametersfile.metadata.(iVeld{1})(parametersfile.rij,1) = parameters.metadata.(iVeld{1});
    end
    for iVeld = VeldenParameters
        parametersfile.MT.(iVeld{1})(parametersfile.rij,1) = parameters.MT.(iVeld{1});
        parametersfile.Opti.(iVeld{1})(parametersfile.rij,1) = parameters.Opti.(iVeld{1});
    end
    for iVeld = VeldenRMSE
        for iSubVeld = subVeldenRMSE
            parametersfile.RMSE.(iVeld{1}).(iSubVeld{1})(parametersfile.rij,1) = parameters.RMSE.(iVeld{1}).(iSubVeld{1});
        end
    end
end

% Zonder pauze in de code runt hij te snel oid. Na 4x de loop doorlopen te
% hebben krijg je een 'unable to write' error.
pause(0.4)
save('parametersfile.mat', 'parametersfile')