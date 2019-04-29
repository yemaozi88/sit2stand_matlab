function [peaks, indices] = bepaal_stahoogtes(positie_verticaal, frames, periode)
% function [peaks, indices] = bepaal_stahoogtes(positie_verticaal, frames, periode)
% input: Opti_linear.x2 (positie over y-as),
%        frames.All,
%        periode
% output:peaks, indices

% peaks en indices bepalen van zithoogtes. 
if periode < 150
    [peaks.stahoogte, indices.stahoogte] = findpeaks(positie_verticaal(frames,1),'minpeakheight',0.8,'minpeakdistance',75);
elseif periode >= 150 && periode < 200
    [peaks.stahoogte, indices.stahoogte] = findpeaks(positie_verticaal(frames,1),'minpeakheight',0.8,'minpeakdistance',100);
elseif periode >= 200 && periode < 350
    [peaks.stahoogte, indices.stahoogte] = findpeaks(positie_verticaal(frames,1),'minpeakheight',0.8,'minpeakdistance',125);
elseif periode >= 350 && periode < 500
    [peaks.stahoogte, indices.stahoogte] = findpeaks(positie_verticaal(frames,1),'minpeakheight',0.8,'minpeakdistance',250);
else
    [peaks.stahoogte, indices.stahoogte] = findpeaks(positie_verticaal(frames,1),'minpeakheight',0.8,'minpeakdistance',300);
end

% gevonden indices omrekenen naar de indices die gebruikt kunnen worden om
% zitmomenten te plotten in main script. 
indices.stahoogte = indices.stahoogte+frames(1)-1;