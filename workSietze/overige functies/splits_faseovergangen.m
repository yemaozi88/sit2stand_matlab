function Opti = splits_faseovergangen(Opti, faseovergangen)
% function Opti = splits_faseovergangen(Opti, faseovergangen)
% Splits alle faseovergangen uit naar start en eindmomenten. Geef de output
% in de vorm van een kolomvector.
% 
% Input: parameters.Opti
%        momenten.All
% Ouput: parameters.Opti

% Splitsen tijdparameters
for iSTS = 1:4:4*Opti.TotaalStS(1)
    Opti.Start_Sit_To_Stand((iSTS+3)/4) = faseovergangen(iSTS);
    Opti.End_Sit_To_Stand((iSTS+3)/4) = faseovergangen(iSTS+1);
    Opti.Start_Stand_To_Sit((iSTS+3)/4) = faseovergangen(iSTS+2);
    Opti.End_Stand_To_Sit((iSTS+3)/4) = faseovergangen(iSTS+3);
end

% verander in kolomvector
Opti.Start_Sit_To_Stand = Opti.Start_Sit_To_Stand';
Opti.End_Sit_To_Stand = Opti.End_Sit_To_Stand';
Opti.Start_Stand_To_Sit = Opti.Start_Stand_To_Sit';
Opti.End_Stand_To_Sit = Opti.End_Stand_To_Sit';