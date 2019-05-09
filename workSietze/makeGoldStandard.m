function parameters = makeGoldStandard(data, trialName)
% function parameters = makeGoldStandard(data, trialName)
% make Sit-to-Stand phase from OptiTrack.
% 
% INPUT
% - data (struct): can be obtained with workspace2data. 
% - trialName: {McRoberts_input}.mainStruct.intervals(trialNum, 5);
% 
% NOTES:
% this code is simple version of 
% {Stagiaires}\Sietze de Haan\MatLab\data_analyse_parameters.mat.
%
% HISTORY
% 2019/04/29 functionized.
%
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%

%% default values
% threshold
drempelwaarde = 0.04; % in meters
% eerste waarde 'draw' is voor tekenen faseovergangen, 
% tweede waarde is voor tekenen RMSE romphoek figuren, 
% derde waarde is tekenen RMSE verticale snelheid figuren.
draw = [1 0 0];

settings_Sietze;
clear dirSietze fileRequestIDlist


%% extract target trial part from the signal.
%frames.All = McRoberts_output.results.report.startEndSTS(1)-(verschuiving*fs.beide):McRoberts_output.results.report.startEndSTS(2)-(verschuiving*fs.beide);
frames.All = data.output.STSperiod(1)-(data.output.shift_sec*data.samplingFrequency)...
    :data.output.STSperiod(2)-(data.output.shift_sec*data.samplingFrequency);
frames.All = round(frames.All);
            
% bepaal de lengte van een periode en knip adhv de periode het
% signaal wat smaller.
[indices, periode] = periode_bepaling(trialName, frames.All, data.Opti.linear.v2(:,1));
frames.All = signaal_knippen(periode, indices);
 
            
%% parameter detectief
% verwijder variabelen bij de analyse van een volgend protocolonderdeel
if exist('parameters','var') >= 1
    clear parameters
    clear indices
    clear mometen_staan
    clear momenten_zitten
end
            
% sta- en zithoogtes bepalen
[peaks, indices] = bepaal_stahoogtes(data.Opti.linear.x2, frames.All, periode);
[peaks, indices] = bepaal_zithoogtes(data.Opti.linear.x2, frames.All, periode, peaks, indices);
[peaks, indices] = index_correctie_zithoogte(data.Opti.linear.x2, frames.All, peaks, indices);
[peaks, indices] = index_correctie_stahoogte(peaks, indices);

% bepaal de start en het einde van de staperiode op basis van de stahoogte
momenten_staan = staan_StartEnd(data.Opti.linear.x2(:,1), indices.stahoogte, indices.zithoogte, frames.All, drempelwaarde);

% bepaal de start en het einde van de zitperiode op basis van de zithoogte
momenten_zitten = zitten_StartEnd(data.Opti.linear.x2(:,1), indices.zithoogte, indices.stahoogte, frames.All, drempelwaarde);

% transitiemomenten bepalen.
% bepalen start trial
parameters.Opti.TotaalStS = length(momenten_staan(1:2:length(momenten_staan),1));
momenten.All = 0;
frames.transitie = 0;
for iFrame = 1:momenten_zitten(1:1)-frames.All(1)-1
    frames = nullijn_passage(frames, data.Opti.angles.v2(:,2), iFrame, draw);
end
momenten.All(1) = frames.transitie(end);

% bepalen tussenliggende transities
for iSTS = 1:(parameters.Opti.TotaalStS)-1
    frames.transitie = 0;
    for iFrame = momenten_staan(iSTS*2-1,1)-frames.All(1):momenten_staan(iSTS*2,1)-frames.All(1)-1
        frames = nullijn_passage(frames, data.Opti.angles.v2(:,2), iFrame, draw);
    end
    frames.transitie = Controleer_transitie_bepaling(iSTS, indices.stahoogte, frames.transitie, data.Opti.angles.v2(:,2), draw);
    momenten.All(size(momenten.All,1)+1:size(momenten.All,1)+2,1) = [frames.transitie(1); frames.transitie(end)];

    frames.transitie = 0;
    for iFrame = momenten_zitten(iSTS*2,1)-frames.All(1):momenten_zitten(iSTS*2+1,1)-frames.All(1)-1
        frames = nullijn_passage(frames, data.Opti.angles.v2(:,2), iFrame, draw);
    end
    frames.transitie = Controleer_transitie_bepaling(iSTS+1, indices.zithoogte, frames.transitie, data.Opti.angles.v2(:,2), draw);
    momenten.All(size(momenten.All,1)+1:size(momenten.All,1)+2,1) = [frames.transitie(1); frames.transitie(end)];
end

% bepalen laatste einde Sit to Stand en begin Stand to Sit
frames.transitie = 0;
for iFrame = momenten_staan(iSTS*2+1,1)-frames.All(1):momenten_staan(iSTS*2+2,1)-frames.All(1)-1
    frames = nullijn_passage(frames, data.Opti.angles.v2(:,2), iFrame, draw);
end
frames.transitie = Controleer_transitie_bepaling(iSTS+1, indices.stahoogte, frames.transitie, data.Opti.angles.v2(:,2), draw);
momenten.All(size(momenten.All,1)+1:size(momenten.All,1)+2,1) = [frames.transitie(1); frames.transitie(end)];

% bepalen einde trial
frames.transitie = 0;
for iFrame = momenten_zitten(iSTS*2+2,1)-frames.All(1):frames.All(end)-frames.All(1)-1
    frames = nullijn_passage(frames, data.Opti.angles.v2(:,2), iFrame, draw);
end
transitieNr = vijf_graden_regel(data.Opti.angles.x2(:,2), frames.transitie);
momenten.All(size(momenten.All,1)+1,1) = frames.transitie(transitieNr);
            

%% parameter calculation
% this part should be removed because mcroberts_output is used.

% opsplitsen van faseovergangen naar start en stopmomenten
parameters.Opti = splits_faseovergangen(parameters.Opti, momenten.All);

% berekening Optitrack parameters
parameters.Opti = Opti_parameters_berekenen(parameters.Opti, data.output.STSperiod(1), data.output.shift_sec, data.samplingFrequency);

% parameters inladen MT
parameters.MT = MoveTest_parameters_inladen(data.output.database, data.output.phases);


%% Aantal STS's MT en Opti vergelijken. NaN invullen bij missende data
index = index_MT_Opti_match(parameters.MT.Start_Sit_To_Stand, parameters.Opti.Start_Sit_To_Stand, parameters.MT.TotaalStS);
veldnamen = {'Start_Sit_To_Stand', 'End_Sit_To_Stand', 'Start_Stand_To_Sit', 'End_Stand_To_Sit', 'TijdSitSt', 'TijdSttSi'};
parameters.MT = MTcorrection(index, parameters.Opti.TotaalStS(1), parameters.MT, veldnamen);


%% RMSE
% range_RMSE = McRoberts_output.results.report.phases(1,1):McRoberts_output.results.report.phases(end,6);
% 
% % trunk angle
% MT_angles.trunkangle = McRoberts_output.results.report.angle(range_RMSE);
% Opti_angles.trunkangle = Opti_angles.x2(range_RMSE-round(verschuiving*fs_beide)+McRoberts_output.results.report.startEndSTS(1),2);
% [MT_angles.trunkangle, Opti_angles.trunkangle, parameters.RMSE.trunkangle] = bereken_RMSE(MT_angles.trunkangle, Opti_angles.trunkangle);
% 
% % verticale snelheid
% MT_linear.verticalspeed = McRoberts_output.results.report.velocityVT(range_RMSE,1);
% Opti_linear.verticalspeed = Opti_linear.v2(range_RMSE-round(verschuiving*fs_beide)+McRoberts_output.results.report.startEndSTS(1),1);
% [MT_linear.verticalspeed, Opti_linear.verticalspeed, parameters.RMSE.verticalspeed] = bereken_RMSE(MT_linear.verticalspeed, Opti_linear.verticalspeed);
%             
            
%% bepaal volgorde protocol
parameters.metadata = bepaal_protocolvolgorde(data.input.intervals);