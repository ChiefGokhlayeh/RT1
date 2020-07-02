% Laborversuch: Simulation
% Regelungstechnik 1
% (C) 2019 W.Lindermeir, W.Zimmermann
% Hochschule Esslingen
%
% Getriebe-Schaltstrategie für die Fahrgeschwindigkeitsregelung
%
function y = getriebe(v)

% Aktuelle Gangstufe als globale Variable, damit der Wert bis zum
% nächsten Aufruf gespeichert bleibt
global gang isInitalized

% Getriebeübersetzung vor dem Schaltvorgang
if gang == 5
        k1 =  8;
elseif gang == 4
        k1 = 10;
elseif gang == 3
        k1 = 13;
elseif gang == 2
        k1 = 20;
else
        gang = 1;
        k1 = 40;
end

% Motordrehzahl vor dem Schaltvorgang in 1/min
n = k1 * v / (2 * pi) * 60;

while n < 1500 || n > 4200
    % Schaltstrategie
    if n > 4200 
        if gang < 5
            gang = gang + 1;    %Hochschalten
        else
            gang = 5;
            break;
        end
    elseif n < 1500
        if gang > 1
            gang = gang - 1;    %Herunterschalten
        else
            gang = 1;
            break;
        end
    else
        gang = gang;            %Gangstufe unverändert
    end
    gang = floor(gang);

    % Getriebeübersetzung nach dem Schaltvorgang
    if gang == 5
        k1 =  8;
    elseif gang == 4
        k1 = 10;
    elseif gang == 3
        k1 = 13;
    elseif gang == 2
        k1 = 20;
    else
        k1 = 40;
    end
    % Motordrehzahl nach dem Schaltvorgang in 1/min
    n = k1 * v / (2 * pi) * 60;
end

% Zusammenfassung der Ausgangssignale in einem Vektor
% (muss in Simulink über Demultiplexer aufgelöst werden)
y(1) = k1;
y(2) = gang;    
y(3) = n;
end
