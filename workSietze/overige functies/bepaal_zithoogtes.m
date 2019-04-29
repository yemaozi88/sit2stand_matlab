function [peaks, indices] = bepaal_zithoogtes(positie_verticaal, frames, periode, peaks, indices)
% function [peaks, indices] = bepaal_zithoogtes(positie_verticaal, frames, periode, peaks, indices)
% input: Opti_linear.x2,
%        frames.All,
%        periode,
%        peaks struct,
%        indices struct
% output:peaks stuct,
%        indices struct

% peaks en indices bepalen van zithoogtes. Signaal wordt gespiegeld om de x-as om
% pieken te kunnen detecteren.
positie_verticaal(frames,1) = -positie_verticaal(frames,1);
if periode < 150
    [~, indices_zithoogte] = findpeaks(positie_verticaal(frames,1),'minpeakheight',-0.75,'minpeakdistance',75);
elseif periode >= 150 && periode < 200
    [~, indices_zithoogte] = findpeaks(positie_verticaal(frames,1),'minpeakheight',-0.75,'minpeakdistance',100);
elseif periode >= 200 && periode < 350
    [~, indices_zithoogte] = findpeaks(positie_verticaal(frames,1),'minpeakheight',-0.75,'minpeakdistance',150);
elseif periode >= 350 && periode < 500
    [~, indices_zithoogte] = findpeaks(positie_verticaal(frames,1),'minpeakheight',-0.75,'minpeakdistance',200);
else
    [~, indices_zithoogte] = findpeaks(positie_verticaal(frames,1),'minpeakheight',-0.75,'minpeakdistance',250);
end
positie_verticaal(frames,1) = -positie_verticaal(frames,1);

% indices omrekenen zodat ze bruikbaar zijn binnen het gehele signaal en
% niet alleen binnen de trail.
indices_zithoogte = indices_zithoogte+frames(1)-1;

% vind zithoogtes die zich voor en na stamomenten bevinden.
zithoogtes_goed = [];
for iZithoogtes = 1:length(indices_zithoogte)-1
    if find(indices.stahoogte > indices_zithoogte(iZithoogtes) & indices.stahoogte < indices_zithoogte(iZithoogtes+1)) ~= 0
        zithoogtes_goed(size(zithoogtes_goed,1)+1:size(zithoogtes_goed,1)+2,1) = [indices_zithoogte(iZithoogtes);indices_zithoogte(iZithoogtes+1)];
    end
end
zithoogtes_goed = unique(zithoogtes_goed);

% verwijder stahoogtes na de laatste zithoogte
if find(indices.stahoogte > zithoogtes_goed(end)) ~= 0
    index_teveel = find(indices.stahoogte > zithoogtes_goed(end));
    indices.stahoogte = indices.stahoogte(1:index_teveel(1)-1);
    peaks.stahoogte = peaks.stahoogte(1:index_teveel(1)-1);
end

% verwijder stahoogtes voor de eerste zithoogte
if find(indices.stahoogte < zithoogtes_goed(1)) ~= 0
    index_teveel = find(indices.stahoogte < zithoogtes_goed(1));
    indices.stahoogte = indices.stahoogte(index_teveel(1)+1:end);
    peaks.stahoogte = peaks.stahoogte(index_teveel(1)+1:end);
end

% verwijder een zithoogte als er zich twee zithoogtes na elkaar bevinden
% zonder stahoogte ertussen.

% maak variabelen klaar voor output
peaks.zithoogte = positie_verticaal(zithoogtes_goed);
indices.zithoogte = zithoogtes_goed;