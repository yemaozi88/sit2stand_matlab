function StSnr = renumber(protocol, reqID)
% function StSnr = renumber(protocol, reqID)
% Na verwijderen NaN's klopt de StS nummering niet meer. Nummer Sit to
% Stands naar wat de MoveTest gemeten heeft.
% 
% Input: metadata.protocol
%        metadata.reqID
% Output:Nieuwe vector StS nummering.

% sampledata
% protocol = [1 1 2 2 2 1 1 1 1 2 2 2 4 4 4 4 5 3 3 3 3]';

% zoek posities waar óf de reqID verandert, óf het protocol verandert.
diffs = diff(protocol);
diffs2 = diff(reqID);
diffs = abs(diffs)+abs(diffs2);
% label de posities waar een nieuw protocol begint met een getal anders dan
% 0.
props = find(diffs);
% maak vector die rijen bevat met de hoeveelheid herhalingen die is
% uitgevoerd. bijv. [2 3 2].
props = [props(1);diff(props)];
props = [props;length(protocol)-sum(props)];

% maak Sit to Stand nummers. Dus [2 3 2] wordt [1 2 1 2 3 1 2]
StSnr = [];
for i = 1:length(props)
   StSnr(length(StSnr)+1:length(StSnr)+props(i),1) = (1:props(i))';
end

