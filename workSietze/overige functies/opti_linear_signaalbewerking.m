function [Opti_linear] = opti_linear_signaalbewerking(coordinaten, fs)
% function [Opti_linear] = opti_linear_signaalbewerking(coordinaten, fs)
% Berekenen positie, snelheid en versnelling
% 
% Input:  Coordinaten,
%         samplefrequentie optitrack
% Output: Opti_linear struct

% volgorde: VT, ML, AP. positie van cm naar meters
Opti_linear.x(:,1) = ((coordinaten(:,2)+coordinaten(:,5)+coordinaten(:,8))/3)/100;
Opti_linear.x(:,2) = ((coordinaten(:,3)+coordinaten(:,6)+coordinaten(:,9))/3)/100;
Opti_linear.x(:,3) = ((coordinaten(:,1)+coordinaten(:,4)+coordinaten(:,7))/3)/100;
%Bereken rechtlijnige snelheid
Opti_linear.v(:,1) = gradient(Opti_linear.x(:,1),1)*fs;
%Bereken rechtlijnige versnelling
Opti_linear.a = gradient(Opti_linear.v,2)*fs;