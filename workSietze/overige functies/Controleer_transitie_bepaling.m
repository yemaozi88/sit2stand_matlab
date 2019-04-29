function frames_transitie = Controleer_transitie_bepaling(iSTS, index_zithoogte, frames_transitie, romphoeksnelheid, draw)
% function frames_transitie = Controleer_transitie_bepaling(iSTS, index_zithoogte, frames_transitie, romphoeksnelheid, draw)
% Als de 0-lijn niet wordt gepasseerd in de loop met de functie
% 'nullijn_passage', dan kies deze functie het frame met de minimale zithoogte en
% het frame daarna als transitiemomenten
% 
% Input: iSTS,
%        indices.zithoogte,
%        frames.transitie
%        romphoeksnelheid (Opti_angles.v2(:,2))
%        draw (bepaalt of figuur moet worden getekend of niet)
% Output:frames.tranisite
% 
% Deze functie maakt ook gebruik van de functie 'plot_func'.

if frames_transitie(1) == 0
    frames_transitie = [index_zithoogte(iSTS) index_zithoogte(iSTS)+1];
    plot_func([index_zithoogte(iSTS) index_zithoogte(iSTS)+1],romphoeksnelheid([index_zithoogte(iSTS) index_zithoogte(iSTS)+1]),'ok',2, draw)
end