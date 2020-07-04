% Laborversuch: Simulation
% Regelungstechnik 1
% (C) 2019 W.Lindermeir, W.Zimmermann
% Hochschule Esslingen
%

slCharacterEncoding('UTF-8')
clear all		% Alle Variablen löschen

g=9.81;			% Erdbeschleunigung
T=0.04;			% Simulationsschrittweite
Tend = 10;		% Simulationsdauer

S=0.8;			% Stoßfaktor plastisch=0 ... 1=elastisch

t=0;			% Zeit
y=0;			% Höhe (Anfangshöhe 4m)
vy=8;			% Geschwindigkeit in y-Richtung
vx=8;			% Geschwindigkeit in y-Richtung
x=0;			% Horizontale Position

SpringenderBallAnimation(t, x, y, 1, Tend, 1, 5);	% Zeitdiagramm und Animation initialisieren

disp('Verschieben Sie die Fenster so, dass beide Grafikfenster sichtbar sind');
disp('Drücken Sie die Leertaste, um die Simulation zu starten');
%pause			% Warten auf Tastendruck

for t = 0 : T : Tend	% Simulationsschleife
    vy = vy - g * T;	% --- Geschwindigkeit
    y  =  y  + T * vy;	% --- Höhe
    
    if y <= 0	        % Falls Boden erreicht
    	vy = -vy * S;	% --- Teilelastischer Stoß
    	y =  0;		% --- Höhe
    end
    SpringenderBallAnimation(t, x, y, 0);    		% Zeitdiagramm und Animation zeichnen
end
