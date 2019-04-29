function transitieNr = vijf_graden_regel(romphoek, transitie)
% function transitieNr = vijf_graden_regel(romphoek, transitie)
% Indien de romphoek aan het eind van een sit-to-stand test nog meer dan
% 5 graden verandert nadat er al gedetecteerd is dat de romphoeksnelheid de
% 0-graden/s lijn heeft gepasseerd, wordt het volgende moment gepakt waarop
% de romphoeksnelheid de 0-lijn passeert.
% 

transitieNr = 1;
if length(transitie) > 2
    iTransitie = 1;
    if abs(romphoek(transitie(iTransitie))-romphoek(transitie(iTransitie+2))) > 5
        transitieNr = iTransitie+2;
    end
end

