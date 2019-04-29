function [X, y, info] = errorFeatures2x(errorFeatures)
% function [X, y, info] = errorFeaturs2x(errorFeatures)
%
% seperate a matrix errorFeatures into [X(input), y(label), info]
% 
% AUTHOR
% Aki Kunikoshi
% 428968@gmail.com
%

info = errorFeatures(:, 1:3);
y    = errorFeatures(:, 4);
X    = errorFeatures(:, 5:end);