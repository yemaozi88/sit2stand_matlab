function [MT_signaal, Opti_signaal, RMSE] = bereken_RMSE(MT_signaal, Opti_signaal)
% function [MT_signaal, Opti_signaal, RMSE] = bereken_RMSE(MT_signaal, Opti_signaal)
% 
% Input: MoveTest signaal,
%        Optitrack signaal,
% Output:MoveTest signaal,
%        Optitrack signaal,
%        Procentuele RMSE waarde

% verwijder offset
Opti_signaal = Opti_signaal - mean(Opti_signaal(1:10));
MT_signaal = MT_signaal - mean(MT_signaal(1:10));

% Bereken RMSE absoluut
RMSE_abs = sqrt(mean((Opti_signaal - MT_signaal).^2));

% Bereken RMSE relatief
% RMSE absoluut / het verschil tussen min en max van gouden standaard
RMSE_rel = (RMSE_abs/(max(Opti_signaal)-min(Opti_signaal)))*100;

RMSE.abs = RMSE_abs;
RMSE.rel = RMSE_rel;
