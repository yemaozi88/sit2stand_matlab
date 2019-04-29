function parameters = checkrun(reqID)
% function parameters = checkrun(reqID)
% Bepaalt of reqID al in parametersfile.mat staat. Zoja, niet uitvoeren om
% dubbele data te voorkomen.
% 
% Input: reqID
% Output:parameters.runanalysis (bevat 0 of 1)

if exist('parametersfile.mat','file') == 0
    parameters.runanalysis = 1;
else
    load('parametersfile.mat')
    if ismember(reqID,parametersfile.metadata.reqID) == 0
        parameters.runanalysis = 1;
    else
        parameters.runanalysis = 0;
    end
end
