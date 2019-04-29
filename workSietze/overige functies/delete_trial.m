function parametersfile = delete_trial(parametersfile, reqID, trialnr)
% function parametersfile = delete_trial(parametersfile, reqID, trialnr)
% Verwijdert alle rijen waarin de opgegeven trial van de opgegeven reqID
% zich bevindt.
% 
% input: parametersfile,
%        reqID,
%        trialnr (1=5xSTSslow, 2=5xSTShabitual 3=5xSTSfast etc.)
% output: parametersfile

rijen_proefpersoon = find(parametersfile.metadata.reqID == reqID);
rijen_trial = parametersfile.metadata.protocol(rijen_proefpersoon) == trialnr;
rows = rijen_proefpersoon(rijen_trial);

rows_remain = 1:length(parametersfile.metadata.reqID);
for i = 1:length(rows)
rows_remain = rows_remain(rows_remain ~= rows(i));
end

for iGroup = {'Opti', 'MT'}
    for iName = fieldnames(parametersfile.(iGroup{1}))'
        parametersfile.(iGroup{1}).(iName{1}) = parametersfile.(iGroup{1}).(iName{1})(rows_remain,:);
    end
end

for iName = {'metadata','reqID'; 'metadata','subject'; 'metadata','protocol'; 'metadata','StSnr'}'
    parametersfile.(iName{1}).(iName{2}) = parametersfile.(iName{1}).(iName{2})(rows_remain,:);
end
for iName = {'trunkangle','verticalspeed'}
    for iSubName = {'abs','rel'}
        parametersfile.RMSE.(iName{1}).(iSubName{1}) = parametersfile.RMSE.(iName{1}).(iSubName{1})(rows_remain,:);
    end
end

parametersfile.rij = length(parametersfile.metadata.reqID)+1;