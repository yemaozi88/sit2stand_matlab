function MT = MoveTest_parameters_inladen(McRoberts_database, McRoberts_fases)
% function MT = MoveTest_parameters_inladen(McRoberts_database, McRoberts_fases)
% inladen parameters MoveTest in de parameters struct
% 
% Input: McRoberts parameters database,
%        McRoberts fases
% Output:MoveTest parameters struct

MT.TijdSitSt = (McRoberts_database.SitToStand.total_duration)';
MT.TijdSttSi = (McRoberts_database.StandToSit.total_duration)';
MT.TotaalStS = size(McRoberts_fases,1);
MT.TotaalTijd = sum([McRoberts_database.SitToStand.total_duration McRoberts_database.StandToSit.total_duration McRoberts_database.StandToSit.sit_duration McRoberts_database.SitToStand.stand_duration]);
MT.Start_Sit_To_Stand = McRoberts_fases(:,1);
MT.End_Sit_To_Stand = McRoberts_fases(:,3);
MT.Start_Stand_To_Sit = McRoberts_fases(:,4);
MT.End_Stand_To_Sit = McRoberts_fases(:,6);