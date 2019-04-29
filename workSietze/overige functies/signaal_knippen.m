function frames = signaal_knippen(periode, indices)
% knip adhv de periode het signaal wat smaller
% 
% Input: periode,
%        indices struct
% Output:nieuwe frames scope

if periode < 180
    frames = round(indices.verticalspeed(1)-1.8*periode):round(indices.verticalspeed(end)+2.5*periode);
elseif periode >= 180 && periode <= 250
    frames = round(indices.verticalspeed(1)-1.8*periode):round(indices.verticalspeed(end)+2*periode);
elseif periode >= 250 && periode <= 350
    frames = round(indices.verticalspeed(1)-1.25*periode):round(indices.verticalspeed(end)+1.5*periode);
else
    frames = round(indices.verticalspeed(1)-0.7*periode):round(indices.verticalspeed(end)+1.2*periode);
end