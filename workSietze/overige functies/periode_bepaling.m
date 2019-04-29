function [indices, periode] = periode_bepaling(trial_naam, frames, SignaalVerticaleSnelheid)
% function [indices, periode] = periode_bepaling(trial_naam, frames, SignaalVerticaleSnelheid)
% bepaal de lengte van een periode
% 
% Input: naam huidige trial,
%        frames (breed geknipt),
%        signaal verticale snelheid Optitrack
% Output:indices van de pieken in het verticale snelheid signaal,
%        de lengte van 1 periode in frames

if strcmp(trial_naam,'5x STS Slow') || strcmp(trial_naam,'30sec STS Slow')
    [~, indices.verticalspeed] = findpeaks(SignaalVerticaleSnelheid(frames),'minpeakdistance',150,'minpeakheight',0.15);
else
    [~, indices.verticalspeed] = findpeaks(SignaalVerticaleSnelheid(frames),'minpeakdistance',80,'minpeakheight',0.3);
end
indices.verticalspeed = indices.verticalspeed+frames(1)-1;
periode = mean([indices.verticalspeed(2)-indices.verticalspeed(1) indices.verticalspeed(3)-indices.verticalspeed(2)]);