function MT = MTcorrection(index, OptiLengte, MT, veldnamen)
% function MT = MTcorrection(index, OptiLengte, MT, veldnamen)
% Schrijft NaNs weg in MT data waar Opti wel STS's meet.
% 
% input: index (uitkomt van functie 'index_MT_Opti_match'),
%        OptiLengte (aantal sit to stands volgens Optitrack)
%        parameters MT struct,
%        veldnamen
% output:parameters MT struct

% NaNs wegschrijven in tijdelijke struct
for veldnaam = veldnamen
    temp.(veldnaam{1}) = NaN(OptiLengte, size(veldnaam,2));
end

% data MT in tijdelijke struct plaatsen
for iTransitie = 1:length(index)
    for veldnaam = veldnamen
        temp.(veldnaam{1})(index(iTransitie),:) = MT.(veldnaam{1})(iTransitie,:);
    end
end

% Waardes echte struct vervangen met tijdelijke struct
for veldnaam = veldnamen
    MT.(veldnaam{1}) = temp.(veldnaam{1});
end