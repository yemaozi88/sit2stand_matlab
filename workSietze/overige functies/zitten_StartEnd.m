function [zitten_Starts_Ends] = zitten_StartEnd(signaal_stahoogte, index_zithoogte, index_stahoogte, frames, drempelwaarde)
% [zitten_Starts_Ends] = zitten_StartEnd(signaal_stahoogte, index_zithoogte, index_stahoogte, frames, drempelwaarde)
%
% Input: signaal stahoogte (1e kolom Optitrack lineaire signalen),
%        index stahoogtes,
%        index zithoogtes,
%        frames.All,
%        drempelwaarde
% Output:Start en eindmomenten zitperiodes

% preallocate variabele zitten_Starts_Ends
zitten_Starts_Ends = zeros(size(index_zithoogte,1)*2-2,2);

% zitmomenten berekening tussenliggende punten
for iZithoogte = 2:size(index_zithoogte,1)-1
    
    % bepaal frames waarop de proefpersoon zit
    range = [index_stahoogte(iZithoogte-1) index_stahoogte(iZithoogte)];
    frames_zitten = frames(frames > range(1) & frames < range(2));
    
    index_StartEnd = find(signaal_stahoogte(frames_zitten) < signaal_stahoogte(index_zithoogte(iZithoogte))+drempelwaarde);
    index_StartEnd = index_StartEnd+frames(1)+(range(1)-frames(1));
    zitten_Starts_Ends((iZithoogte*2)-2,:) = [index_StartEnd(1) signaal_stahoogte(index_StartEnd(1))];
    zitten_Starts_Ends((iZithoogte*2)-1,:) = [index_StartEnd(end) signaal_stahoogte(index_StartEnd(end))];
end

% zitmomenten eerste punt
index_StartEnd = [];
for iFactor = 0.6:0.15:1.15
    if isempty(index_StartEnd)
        % bepaal frames waarop de proefpersoon zit
        range = [index_zithoogte(1) index_stahoogte(1)];
        frames_zitten = frames(frames > range(1) & frames < range(2));
        
        index_StartEnd = find(signaal_stahoogte(frames_zitten) < signaal_stahoogte(index_zithoogte(1))+drempelwaarde);
        index_StartEnd = index_StartEnd(end)+frames(1)+(range(1)-frames(1));
    end
end
zitten_Starts_Ends(1,:) = [index_StartEnd signaal_stahoogte(index_StartEnd)];

% zitmomenten laatste punt
index_StartEnd = [];
for iFactor = 0.6:0.15:1.15
    if isempty(index_StartEnd)
        % bepaal frames waarop de proefpersoon zit
        range = [index_stahoogte(end) index_zithoogte(end)];
        frames_zitten = frames(frames > range(1) & frames < range(2));
        
        index_StartEnd = find(signaal_stahoogte(frames_zitten) < signaal_stahoogte(index_zithoogte(end))+drempelwaarde);
        index_StartEnd = index_StartEnd(1)+frames(1)+(range(1)-frames(1));
    end
end
zitten_Starts_Ends(end,:) = [index_StartEnd signaal_stahoogte(index_StartEnd)];

