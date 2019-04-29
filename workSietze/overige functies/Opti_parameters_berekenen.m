function Opti = Opti_parameters_berekenen(Opti, McRoberts_start_trial, verschuiving, fs)
% Opti parameters berekenen en omrekenen
% 
% Input: Opti parameters struct
%        samplenr van de start van de trial
%        verschuivingswaarde (in sec)
%        samplefrequentie (fs)
% Output:Opti parameters struct

% parameters berekenen adhv start en stop momenten STS's.
% De parameter Totaal aantal STS's in eerder in de code al berekend. Deze
% zit dus al in de Opti struct die ingeladen wordt.
Opti.TijdSitSt = (Opti.End_Sit_To_Stand-Opti.Start_Sit_To_Stand)/fs;
Opti.TijdSttSi = (Opti.End_Stand_To_Sit-Opti.Start_Stand_To_Sit)/fs;
Opti.TotaalTijd = (Opti.End_Stand_To_Sit(end)-Opti.Start_Sit_To_Stand(1))/fs;

% De start en eind momenten worden verschoven zodat ze vergeleken kunnen
% worden met de start en eind momenten van McRoberts.
Opti.Start_Sit_To_Stand = Opti.Start_Sit_To_Stand-McRoberts_start_trial+(verschuiving*fs);
Opti.End_Sit_To_Stand = Opti.End_Sit_To_Stand-McRoberts_start_trial+(verschuiving*fs);
Opti.Start_Stand_To_Sit = Opti.Start_Stand_To_Sit-McRoberts_start_trial+(verschuiving*fs);
Opti.End_Stand_To_Sit = Opti.End_Stand_To_Sit-McRoberts_start_trial+(verschuiving*fs);

% variabelen afronden, omdat uitkomst een geheel samplenummer moet geven.
Opti.Start_Sit_To_Stand = round(Opti.Start_Sit_To_Stand);
Opti.End_Sit_To_Stand = round(Opti.End_Sit_To_Stand);
Opti.Start_Stand_To_Sit = round(Opti.Start_Stand_To_Sit);
Opti.End_Stand_To_Sit = round(Opti.End_Stand_To_Sit);
