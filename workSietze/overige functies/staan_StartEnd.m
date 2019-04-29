function [staan_Starts_Ends] = staan_StartEnd(signaal_stahoogte, index_stahoogte, index_zithoogte, frames, drempelwaarde)
% [staan_Starts_Ends] = staan_StartEnd(signaal_stahoogte, index_stahoogte, index_zithoogte, frames, drempelwaarde)
% 
% Input: signaal stahoogte (1e kolom Optitrack lineaire signalen),
%        index stahoogtes,
%        index zithoogtes,
%        frames.All,
%        drempelwaarde
% Output:Start en eindmomenten staperiodes

% preallocate variabele staan_Starts_Ends
staan_Starts_Ends = zeros(size(index_stahoogte,1)*2,2);

% stamomenten berekening
for iStahoogte = 1:size(index_stahoogte,1)
    
    % bepaal frames waarop de proefpersoon staat
    range = [index_zithoogte(iStahoogte) index_zithoogte(iStahoogte+1)];
    frames_staan = frames(frames > range(1) & frames < range(2));
    
    index_StartEnd = find(signaal_stahoogte(frames_staan) > signaal_stahoogte(index_stahoogte(iStahoogte))-drempelwaarde);
    index_StartEnd = index_StartEnd+frames(1)+(range(1)-frames(1));
    staan_Starts_Ends((iStahoogte*2)-1,:) = [index_StartEnd(1) signaal_stahoogte(index_StartEnd(1))];
    staan_Starts_Ends(iStahoogte*2,:) = [index_StartEnd(end) signaal_stahoogte(index_StartEnd(end))];
end