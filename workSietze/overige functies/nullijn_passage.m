function frames = nullijn_passage(frames, romphoeksnelheid, iFrame, draw)
% function frames = nullijn_passage(frames, romphoeksnelheid, iFrame, draw)
% Functie bepaald om het signaal de 0-lijn passeert. Voor elke keer dat het
% signaal de 0-lijn passerd, worden de waarden van die frames opgeslagen in
% frames.transitie. Gebruik functie in een loop
% 
% Input: frames struct,
%        signaal romphoeksnelheid (Opti_angles.v2(:,2)),
%        iFrame (de loop-waarde)
%        draw (bepaalt of figuur getekend wordt of niet.)
% Output:frames struct

% Check of de 0-lijn in het hoeksnelheid signaal gepasseerd wordt:
if romphoeksnelheid(frames.All(iFrame)) >= 0 && romphoeksnelheid(frames.All(iFrame+1)) < 0
    % Check of de variabele frames.transitie al gevuld is:
    if size(frames.transitie,1) < 2
        frames.transitie(1:2,1) = [frames.All(iFrame); frames.All(iFrame+1)];
        % plot waardes
        %plot_func([frames.All(iFrame) frames.All(iFrame+1)],romphoeksnelheid([frames.All(iFrame) frames.All(iFrame+1)]),'ok',2, draw)
    else
        frames.transitie((size(frames.transitie,1)+1:size(frames.transitie,1)+2),1) = [frames.All(iFrame); frames.All(iFrame+1)];
        % plot waardes
        %plot_func([frames.All(iFrame) frames.All(iFrame+1)],romphoeksnelheid([frames.All(iFrame) frames.All(iFrame+1)]),'ok',2, draw)
    end
end