function index = index_MT_Opti_match(MT_Start_Sit_To_Stand, Opti_Start_Sit_To_Stand, MT_TotaalStS)
% function index = index_MT_Opti_match(MT_Start_Sit_To_Stand, Opti_Start_Sit_To_Stand, MT_TotaalStS)
% Bepalen bij welke Optitrack STS de MoveTest STS hoort.
% Input: MT start sit to stand, Opti start sit to stand, MT totaal STS
% Output: index
% 
% index = index_MT_Opti_match(parameters.MT.Start_Sit_To_Stand, parameters.Opti.Start_Sit_To_Stand, parameters.MT.TotaalStS)
% 
% vb input:
% MT_Start_Sit_To_Stand = [345 378 390 430]
% Opti_Start_Sit_To_Stand = [347 375 391 413 429]
% MT_TotaalStS = [4 4 4 4]
% 
% vb output:
% index = [1 2 3 5]

for iTransition = 1:MT_TotaalStS(1)
    [~, index(iTransition)] = min(abs(MT_Start_Sit_To_Stand(iTransition) - Opti_Start_Sit_To_Stand));
end
