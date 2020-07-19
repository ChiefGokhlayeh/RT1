% Regelunstechnik 1 und 2
% (C) 2019 W.Lindermeir, W.Zimmermann
% Hochschule Esslingen
%
% Analyse von Sprungantworten [a,Tan,Taus]=Analyse(y,t,tol)
%  Eingangsgrößen:     
%               y=y(t)  Sprungantwort
%               t       Zeitvektor
%               tol     optional: relative Toleranz (Default 0.05) bzw. absolute Toleranz 
%  Ausgangsgrößen:
%               a       relative Überschwingweite bzw. absolute Überschwingweite 
%               Tan     Anregelzeit
%               Taus    Ausregelzeit
%
%  Anwendungsbeispiel:      
%               z=[1];              %PT2-Glied - Zähler der Übertragungsfunktion
%               n=[1 2 1];          %      - Nenner der Übertragungsfunktion
%               [y,x,t]=step(z,n);  %Sprungantwort
%               analyse(y,t,0.1);   %Analyse bei einem Toleranzbereich von 0.1=10%
%
%  alternativ, wenn das Systemobjekt G für Übertragungsfunktionen verwendet wird:
%               z=...
%               n=...
%               G = tf(z,n);        %Systemobjekt für Übertragungsfunktionen
%               [y,t]=step(G);      %Achtung: Rückgabewerte [y,t]= statt [y,x,t]=... !!!
%               analyse(y,t,0.1);
%
%  ACHTUNG: analyse() liefert nur dann korrekte Werte, wenn
%	    - das Signal y am rechten Ende des Zeitbereichs eingeschwungen ist
%     - der Sprung, auf den sich Tan und Taus beziehen, bei t=0 stattgefunden hat.
%

function [a,Tan,Taus]=Analyse(y,t,tol)
slCharacterEncoding('UTF-8')
if nargin<3
   tol=0.05;
end

w=mean( y((length(t)-10): length(t)));
ymax=max( y((length(t)-10): length(t)));
ymin=min( y((length(t)-10): length(t)));

if (ymax > w+tol) || (ymin < w-tol)
    fprintf(2,'Warnung Analyse.m: Regelkreis ist nicht eingeschwungen - a, Tan, Taus können nicht zuverlässig bestimmt werden.\n\r'); 
    fprintf(2,'Hinweis: Versuchen Sie die Simulationszeit zu verlängern.\n\r'); 
    return;
end

Tan=0;
Taus=0;
foundTan=0;

if abs(w)==0
   a=max(y);
   utol=-tol;
   otol= tol;
else
   a=max(y)/abs(w)-1;
   if a<0
      a=0;
   end;
   utol=(1-tol)*w;
   otol=(1+tol)*w;
end;
for k=1:length(t),
   if (foundTan==0) && (y(k)>utol)
    if k==1
           Tan=t(k);
        else 
           Tan=t(k-1);
        end;
    foundTan=1;
   end;
   if (y(k)<utol) || (y(k)>otol)
    Taus=t(k);
   end;
end;

if nargout==0
  figure
  plot(t,y);
  hold on
  plot([Tan Tan],[0 utol],'b',[Taus Taus],[0 otol],'b')
  plot([0 t(length(t))],[utol utol],'b--',[0 t(length(t))],[otol otol],'b--',[0 t(length(t))],[w w],'b--')
  hold off
  if abs(w)==0
      if Tan > 0
	title(['ANALYSE: ymax=' num2str(a,3)  '   Tan=' num2str(Tan,3) 's    Taus=' num2str(Taus,3) 's'])
      else
	title(['ANALYSE: Istwert'])
      end
  else
    title(['ANALYSE: a=' num2str(a*100,3) '%   Tan=' num2str(Tan,3) 's    Taus=' num2str(Taus,3) 's'])
  end
end;
