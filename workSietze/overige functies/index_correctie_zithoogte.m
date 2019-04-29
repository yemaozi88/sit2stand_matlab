function [peaks, indices] = index_correctie_zithoogte(positie_verticaal, frames, peaks, indices)
% function [peaks, indices] = index_correctie_zithoogte(positie_verticaal, frames, peaks, indices)
% Corrigeert de eerste en laatste zithoogte.
% 
% Input: signaal stahoogte Optitrack,
%        frames.All,
%        peaks struct,
%        indices struct
% Output:peaks struct,
%        indices struct

% frames kiezen waar gekeken mag worden voor het bepalen van de eerste en
% laatste zithoogte
frames_begin = frames(1):indices.stahoogte(1);
frames_eind = indices.stahoogte(end):frames(end);

% minima zoeken binnen gekozen frame ranges
positie_verticaal(frames,1) = -positie_verticaal(frames,1);
[~, indices_zithoogte_begin] = findpeaks(positie_verticaal(frames_begin,1),'minpeakheight',-0.75);
[~, indices_zithoogte_eind] = findpeaks(positie_verticaal(frames_eind,1),'minpeakheight',-0.75);
positie_verticaal(frames,1) = -positie_verticaal(frames,1);

% indices aanpassen aan de rest van het signaal
indices_zithoogte_begin = indices_zithoogte_begin+frames(1)-1;
indices_zithoogte_eind = indices_zithoogte_eind+frames(1)+(indices.stahoogte(end)-frames(1))-1;

% eerste en laatste indices en peaks in struct vervangen met de nieuwe
% waarden
indices.zithoogte(1) = indices_zithoogte_begin(end);
indices.zithoogte(end) = indices_zithoogte_eind(1);
peaks.zithoogte(1) = positie_verticaal(indices_zithoogte_begin(end));
peaks.zithoogte(end) = positie_verticaal(indices_zithoogte_eind(1));

% controleren of er meerdere zithoogtes achter elkaar zitten in het midden
% van het signaal
for iStaan = 1:length(indices.stahoogte)-1
    range = [indices.stahoogte(iStaan) indices.stahoogte(iStaan+1)];
    if length(find(indices.zithoogte > range(1) & indices.zithoogte < range(2))) > 1
        index_teveel = find(indices.zithoogte > range(1) & indices.zithoogte < range(2));
        index_teveel = index_teveel(2:end);
        index = 1:length(indices.zithoogte);
        index(index_teveel) = [];
        indices.zithoogte = indices.zithoogte(index);
        peaks.zithoogte = peaks.zithoogte(index);
    end
end
