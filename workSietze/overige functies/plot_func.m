function plot_func(x, y, type, sub, draw)
% plot_func(x, y, sub, type)
% plot functie
%
% Input: x,
%        y,
%        type. vul hier de kleur en symbool in dat geplot moet worden.
%           vb: 'or', voor een rood rondje
%        subplot nr

if draw(1) == 1
    subplot(2,1,sub)
    hold on
    plot(x, y, type)
end