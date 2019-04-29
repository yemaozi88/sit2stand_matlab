function [peaks, indices] = index_correctie_stahoogte(peaks, indices)
% function [peaks, indices] = index_correctie_stahoogte(peaks, indices)
% Corrigeert de eerste en laatste zithoogte.
% 
% Input: indices struct,
%        peaks struct
% Output:indices struct,
%        peaks struct

% controleren of er meerdere stahoogtes achter elkaar zitten in het midden
% van het signaal
for iZitten = 1:length(indices.zithoogte)-1
    range = [indices.zithoogte(iZitten) indices.zithoogte(iZitten+1)];
    if length(find(indices.stahoogte > range(1) & indices.stahoogte < range(2))) > 1
        index_teveel = find(indices.stahoogte > range(1) & indices.stahoogte < range(2));
        index_teveel = index_teveel(2:end);
        index = 1:length(indices.stahoogte);
        index(index_teveel) = [];
        indices.stahoogte = indices.stahoogte(index);
        peaks.stahoogte = peaks.stahoogte(index);
    end
end
