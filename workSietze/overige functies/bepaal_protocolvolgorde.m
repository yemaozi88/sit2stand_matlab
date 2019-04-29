function metadata = bepaal_protocolvolgorde(McRoberts_intervallen)
% function metadata = bepaal_protocolvolgorde(McRoberts_intervallen)
% Bepaalt de volgorde waarin de trails zijn uitgevoerd.
% 
% Input: McRoberts_input.mainStruct.intervals
% Ouput: protocolnamen en volgorde
% 
% Voorbeeld:
% Input = {'5x STS Fast'} {'5x STS Slow'} {'5x STS Habitual'} {'30sec STS Habitual'} {'30sec STS Slow'} {'30sec STS Fast'}
% Output = [3 1 2 5 4 6]

% bepaal volgorde protocol
metadata.protocolnamen = [{'5x STS Slow'} {'5x STS Habitual'} {'5x STS Fast'} {'30sec STS Slow'} {'30sec STS Habitual'} {'30sec STS Fast'}];
metadata.protocolnamen = [num2cell(1:6)' metadata.protocolnamen'];
for iNamen = 1:6
    for iTrial = 1:6
        if strcmp(metadata.protocolnamen(iNamen, 2), McRoberts_intervallen(iTrial, 5)) == 1
            metadata.volgorde(iTrial) = iNamen;
        end
    end
end