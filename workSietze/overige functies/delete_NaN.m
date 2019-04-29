function parametersfile = delete_NaN(parametersfile)
% function parametersfile = delete_NaN(parametersfile)
% Deze functie verwijdert alle rijen uit de struct 'parametersfile' waar de
% waarde NaN in staat.
% 
% input: parametersfile
% output: parametersfile

realnums = isfinite(parametersfile.MT.Start_Sit_To_Stand);

for iGroup = {'Opti', 'MT'}
    for iName = fieldnames(parametersfile.(iGroup{1}))'
        parametersfile.(iGroup{1}).(iName{1}) = parametersfile.(iGroup{1}).(iName{1})(realnums,:);
    end
end

for iName = {'metadata','reqID'; 'metadata','subject'; 'metadata','protocol'; 'metadata','StSnr'}'
    parametersfile.(iName{1}).(iName{2}) = parametersfile.(iName{1}).(iName{2})(realnums,:);
end
for iName = {'trunkangle','verticalspeed'}
    for iSubName = {'abs','rel'}
        parametersfile.RMSE.(iName{1}).(iSubName{1}) = parametersfile.RMSE.(iName{1}).(iSubName{1})(realnums,:);
    end
end
