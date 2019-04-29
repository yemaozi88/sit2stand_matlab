function [vierkant] = plotvierkant(t_input, t_input_index, signaal)
% function [vierkant] = plotvierkant(t_input, t_input_index, signaal)
% Plot een rood vierkant om het signaal heen waar de synchronisatie
% plaatsvindt dmv de input die door de gebruiker is ingevoerd.
% 
% Input: t_input
%        t_input_index
%        signaal
% Output:vierkant (1e kolom = x, 2e kolom = y)

vierkant(:,1) = [t_input(1) t_input(2) t_input(2) t_input(1) t_input(1)];
ymin = min(signaal(t_input_index(1):t_input_index(2)));
ymax = max(signaal(t_input_index(1):t_input_index(2)));
vierkant(:,2) = [ymax ymax ymin ymin ymax];
