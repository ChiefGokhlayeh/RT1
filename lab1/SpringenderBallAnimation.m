% Laborversuch: Simulation
% Regelungstechnik 1
% (C) 2019 W.Lindermeir, W.Zimmermann
% Hochschule Esslingen
%
% Animation für den springenden Ball
%
% Parameter:	t...aktuelle Zeit, x...aktuelle Höhe, y...aktuelle Höhe
%		init...1 bei Initialisierung, 0 normaler Zeitschritt
%		Tend...Zeitbereich
%		xmax...maximaler Weg, ymax...maximale Höhe für Diagramm
%		(Tend, xmax, ymax dürfen entfallen, wenn init=0 ist)
%
function SpringenderBallAnimation(t, x, y, init, Tend, xmax, ymax)
slCharacterEncoding('UTF-8')

global h r talt xalt yalt			% Statische (Globale) Variable, speichern Wert für den nächsten Zeitschritt
r = 0.5;					% Radius des Balls

if init==1					% Grafik initialisieren
    figure(1);					% Zeitdiagramm y(t) skalieren und beschriften
    clf
    axis([0 Tend 0 ymax]);
    title('Springender Ball : y(t)')
    xlabel('t [sec]')
    ylabel('y [m]');
    hold on;
    talt = t;
    xalt = x;
    yalt = y;
    
    figure(2)                               	% Animation initialisieren, skalieren und beschriften
    clf
    axis equal					% Seitenverhältnis 1:1, damit Ball kreisrund wird
    axis([-r xmax+r 0 ymax+r]);

    h = rectangle('Position',[x-r/2,y,r,r], 'Curvature',[1,1], 'FaceColor','b'); % Erzeugt den Ball (blauer Kreis)
    
    title('Springender Ball : Animation');
    xlabel('Weg  x [m]');
    ylabel('Höhe y [m]');
    hold on
else
    figure(1)
    plot([talt t], [yalt y],'b')			% Aktuelle Position in y(t)-Diagramm einzeichnen

    figure(2);
    set(h, 'Position',[x-r/2, y, r, r]);	% Animierten Ball an aktueller Position einzeichnen
    drawnow
end

pause(t-talt);					% warten bis zum nächsten Zeitschritt (damit die Animation nicht zu schnell läuft)

talt=t;						% Variablen-Update für den nächsten Zeitschritt
xalt=x;
yalt=y;

