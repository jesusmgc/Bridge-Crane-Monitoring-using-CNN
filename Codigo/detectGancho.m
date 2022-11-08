function [xg,yg,zg,vx,vy,vz,fallo,detectGan,acufalcon,obs] = detectGancho(nubfil,xriel,ycar,xg0,yg0,zg0,dt,vy,vz,detectGan,acufalcon)
% CÓDIGO PARA DETECTAR LA POSICIÓN DEL GANCHO A PARTIR DE LA POSICIÓN
% DEL CARRO SUPERIOR Y EL RIEL
%-------------------------------------------------
%PROCESO:
% 1) Seleccionar puntos en ventana 1x1 m hacia abajo a partir de la
%    posiciòn del carro (xriel,ycar)
%    Nota: A partir de la primera detecciòn del gancho, se usa la posiciòn
%          anterior del gancho para limitar los puntos de la ventana 1x1 m
%          (principalmente en coordenada Z)
% 2) Ubicar el Z mínimo para estos puntos seleccionados
%--------------------------------------------------
% ENTRADAS
% nubfil = nube de puntos depurada
% xriel = Coordenada X del eje del riel
% ycar = coordenada y del carro
% (x0g,y0g,z0g) = posición del gancho en la nube anterior
% dt= diferencial de tiempo entre la nube anterior y la actual
% vy,vz = velocidad de avance del gancho en direcciòn Y y Z respectivamente
% detectGan= variable que indica si se ha detectado el gancho al menos una vez
%           (a partir de la segunda iteración)
% acufalcon= variable de control para indicar si de detectò gancho en la 
%            iteraciòn anterior (0= si se detectó; 1= no se detectó)
%
% SALIDAS
% (xg,yg,zg) = posición actual del gancho 
% vx,vy,vz = velocidad de avance actual del gancho en direcciòn X, Y y Z 
% fallo= vairable de análisis estadístico: va sumando la cantidad de fallos
%        en la detección del gancho
% obs = nubes de puntos de posibles obstàculos

    xgacum=0;
    ygacum=0;
    n2=0;
    zgap=1;
    n3=0;
    obs=zeros;
    m=nubfil.Count;
        if detectGan==0 
            for i=1:m   % 1era depuraciòn: dimensiones de la ventana proyectada hacia abajo: 1mx1m
                if abs(nubfil.Location(i,1)-xriel)<=0.5 && abs(nubfil.Location(i,2)-ycar)<=0.5 && nubfil.Location(i,3)<1 
                    n2=n2+1;
                    xgacum=xgacum+nubfil.Location(i,1);
                    ygacum=ygacum+nubfil.Location(i,2);
                    if nubfil.Location(i,3)<zgap
                        zgap=nubfil.Location(i,3);
                    end
                end
                if nubfil.Location(i,3)<0.8                        
                    n3=n3+1;
                    obs(n3,1)=nubfil.Location(i,1);
                    obs(n3,2)=nubfil.Location(i,2);
                    obs(n3,3)=nubfil.Location(i,3);
               end

            end
            if n2>0
                detectGan=detectGan+1;
            end
        else
             for i=1:m   % 1era depuraciòn: dimensiones de la ventana proyectada hacia abajo: 1mx1m
                if abs(nubfil.Location(i,1)-xriel)<=0.5 && abs(nubfil.Location(i,2)-ycar)<=0.5...
                        && nubfil.Location(i,3)<1 && abs(nubfil.Location(i,3)-zg0)<0.4
                    n2=n2+1;
                    xgacum=xgacum+nubfil.Location(i,1);
                    ygacum=ygacum+nubfil.Location(i,2);
                    if nubfil.Location(i,3)<zgap
                        zgap=nubfil.Location(i,3);
                    end
                end
                if nubfil.Location(i,3)<0.8                        
                    n3=n3+1;
                    obs(n3,1)=nubfil.Location(i,1);
                    obs(n3,2)=nubfil.Location(i,2);
                    obs(n3,3)=nubfil.Location(i,3);
               end
             end
            if n2>0
                detectGan=detectGan+1;
            end
        end

if n2~=0 %Entradas posteriores (ya detectó gancho previamente) y detectó gancho
    if  detectGan==1
        xg=xgacum/n2;
        yg=ygacum/n2;
        zg=zgap;
    else
        xg=xgacum/n2;
        yg=ygacum/n2;
        if abs (zgap-zg0)>0.5
            zg=zg0+vz*dt;
        else
          zg=zgap;  
        end 
    end
    fallo=0;
    acufalcon=0;
end

if detectGan==0 %Primeras entradas hasta detectar el gancho
        xg=0;
        yg=0;
        zg=0;
        fallo=1;
        acufalcon=0;
end

if n2==0 && detectGan>1 %Entradas posteriores (ya detectò gancho previamente) y no detectò gancho
    if acufalcon<1
        xg=xg0;
        yg=yg0+vy*dt;
        zg=zg0;
        acufalcon=acufalcon+1;
    else    
        xg=xg0;
        yg=yg0;
        zg=zg0;
        acufalcon=acufalcon+1;
    end  
    fallo=1;

end

if detectGan<=1
    vx=0;
    vy=0;
    vz=0;
else
    vx=(xg-xg0)/dt;
    vy=(yg-yg0)/dt;
    vz=(zg-zg0)/dt;
end

end