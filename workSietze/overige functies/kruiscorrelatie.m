function [tau, kruiscorr] = kruiscorrelatie(fs, x, y)
% function [tau, kruiscorr] = kruiscorrelatie(fs, x, y)
% Voert kruiscorrelatie uit.
% 
% Inputparameters:
% fs = samplefrequentie
% x = signaal 1
% y = signaal 2
% 
% Outputparameters:
% tau = tijdverschuiving
% kruiscorr = mate van correlatie. 1 en -1 zijn perfecte correlatie, 0 is
% geen correlatie.
% Visueel resultaat kan worden verkregen met: plot(tau,kruiscorr)

kruiscorr=xcorr(x,y,'biased'); % bepaal kruiscorrelatie
dt=1/fs; % fs: bemonsteringsfrequentie
n=length(x);
tau=(-n+1:n-1)*dt; % bepaal tau’s