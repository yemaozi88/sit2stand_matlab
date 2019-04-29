function [hoek1] = PositionToAngles(refFrame, coordinaten, sequentie)
% function [hoek1] = PositionToAngles(refFrame, coordinaten, sequentie)

% Maak transformatiematix
nSamples = size(coordinaten,1);
Tref = CalcTransMat(coordinaten(refFrame, 1:3)', coordinaten(refFrame, 4:6)', coordinaten(refFrame, 7:9)');

T = zeros(4,4,nSamples);
for iFrame = 1:nSamples
    T(:,:,iFrame) = CalcTransMat(coordinaten(iFrame,1:3)', coordinaten(iFrame,4:6)', coordinaten(iFrame,7:9)');
end

% Bereken transformatiematrix tov referentieframe. 
for iFrame = 1:nSamples
    T(1:4,1:4,iFrame) =  T(1:4,1:4,iFrame)*inv(Tref(1:4,1:4));
end

% Bereken euler hoeken en reken om van radialen naar graden
hoek1 = zeros(nSamples, size(coordinaten,2)/3);
hoek2 = zeros(nSamples, size(coordinaten,2)/3);
for iFrame = 1:nSamples
    [hoek1(iFrame,:),hoek2(iFrame,:)] = RotationMatrixToCardanicAngles(T(:,:,iFrame), sequentie); % y z x
end

hoek1 = unwrap(hoek1);
hoek1 = (hoek1/pi)*180;
