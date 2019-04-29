function [MT_linear, MT_angles] = MoveTest_signaalbewerking(McRobertsSignals, fs)
% function [MT_linear, MT_angles] = MoveTest_signaalbewerking(McRobertsSignals)
% Omrekenen signalen naar positie snelheid en versnelling.
% Er wordt een highpass filter toegepast tegen integratiedrift
% 
% Input:  McRoberts rechtlijnige versnellingssignalen en hoeksnelheden,
%         samplefrequentie MoveTest
% Output: MT_linear struct,
%         MT_angles struct
% 
% In deze functie wordt ook gebruik gemaakt van de functie 'highfilter'.
         
% McRobertsSignals(:,1:3) = rechtlijnige versnellingen in g.
% McRobertsSignals(:,4:6) = hoeksnelheiden in graden/s.

% vul variabele met rechtlijnige versnellingen. Versnellingen worden
% omgerekend naar m/s^2.
MT_linear.a = McRobertsSignals(:,1:3)*9.81;
% integreren voor versnelling naar snelheid
MT_linear.v = cumtrapz(MT_linear.a)/fs;
% highpass filter tegen integratiedrift
MT_linear.v = highfilter(fs, 0.1, 2, MT_linear.v);
% integreren snelheid naar positie
MT_linear.x = cumtrapz(MT_linear.v)/fs;
% highpass filter tegen integratiedrift
MT_linear.x = highfilter(fs, 0.1, 2, MT_linear.x);

% vul variabele met hoeksnelheden.
MT_angles.v = McRobertsSignals(:,4:6);
% differentiëren van hoeksnelheid naar hoekversnelling
MT_angles.a = gradient(MT_angles.v,2)*fs;
% integreren van hoeksnelheid naar hoekstand
MT_angles.x = cumtrapz(MT_angles.v)/fs;
% highpass filter tegen integratiedrift
MT_angles.x = highfilter(fs, 0.1, 2, MT_angles.x);