function parametersfile = delete_reqID(parametersfile, reqID)
% function parametersfile = delete_reqID(parametersfile, reqID)
% Verwijdert alle rijen waarin de opgegeven reqID zich bevindt.
% 
% input: parametersfile, reqID
% output: parametersfile

% Selecteer alle reqID's die ongelijk zijn aan de opgegeven reqID en sla
% deze op in het bestand parametersfile
for iGroup = {'Opti', 'MT'}
    for iName = fieldnames(parametersfile.(iGroup{1}))'
        parametersfile.(iGroup{1}).(iName{1}) = parametersfile.(iGroup{1}).(iName{1})(parametersfile.metadata.reqID ~= reqID,:);
    end
end

for iName = {'metadata','subject'; 'metadata','protocol'; 'metadata','StSnr'; 'metadata','reqID'}'
    parametersfile.(iName{1}).(iName{2}) = parametersfile.(iName{1}).(iName{2})(parametersfile.metadata.reqID ~= reqID,:);
end
for iName = {'trunkangle','verticalspeed'}
    for iSubName = {'abs','rel'}
        parametersfile.RMSE.(iName{1}).(iSubName{1}) = parametersfile.RMSE.(iName{1}).(iSubName{1})(parametersfile.metadata.reqID ~= reqID,:);
    end
end

% is waarschijnlijk niet meer nodig.
parametersfile.rij = length(parametersfile.metadata.reqID)+1;