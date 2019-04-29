function [Opti_angles] = opti_angles_signaalbewerking(Opti_angles, fs)
% function [Opti_angles] = opti_angles_signaalbewerking(Opti_angles, fs)
% Berekenen snelheid en versnelling
% 
% Input:  Opti_angles struct, 
%         samplefrequentie optitrack
% Output: Opti_angles struct

% Bereken hoeksnelheid
Opti_angles.v(:,1) = gradient(Opti_angles.x(:,1),1)*fs;
Opti_angles.v(:,2) = gradient(Opti_angles.x(:,2),1)*fs;
Opti_angles.v(:,3) = gradient(Opti_angles.x(:,3),1)*fs;
% [~, Opti_angles.v3] = gradient(Opti_angles.x(:,1:3), 1, 1/fs.opti);, voor
% alles in 1 keer???

% Bereken hoekversnelling
Opti_angles.a(:,1) = gradient(Opti_angles.v(:,1),1)*fs;
Opti_angles.a(:,2) = gradient(Opti_angles.v(:,2),1)*fs;
Opti_angles.a(:,3) = gradient(Opti_angles.v(:,3),1)*fs;

% assen goede kant op richten
Opti_angles.v(:,3) = -Opti_angles.v(:,3);

