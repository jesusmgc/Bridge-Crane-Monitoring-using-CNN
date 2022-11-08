function [xg,yg,zg,xc,yc,zc,vx,vy,vz,fallo,detectGan,acufalcon,hcarg,radcarg,obs] = detectCarga(nubfil,xriel,ycar,xg0,yg0,zg0,xc0,yc0,zc0,dt,vy,detectGan,acufalcon,hc0,rc0,tcarga)
% CÓDIGO PARA DETECTAR LA POSICIÓN DEL GANCHO A PARTIR DE LA POSICIÓN
% DEL CARRO SUPERIOR Y EL RIEL
%-------------------------------------------------
%PROCESO:
% 1) Seleccionar puntos en ventana 1x1 m hacia abajo a partir de la
%    posiciòn del carro (xriel,ycar)
%    Nota: A partir de la primera detección del gancho, se usa la posición
%          anterior del gancho para limitar los puntos de la ventana 1x1 m
%          (principalmente en coordenada Z)
% 2) Ubicar el Z mínimo para estos puntos seleccionados
%--------------------------------------------------
% ENTRADAS
% nubfil = nube de puntos depurada
% xriel = Coordenada X del eje del riel
% ycar = coordenada y del carro
% (x0g,y0g,z0g) = posición del gancho en la nube anterior
% (x0c,y0c,z0c) = posición del gancho en la nube anterior
% dt= diferencial de tiempo entre la nube anterior y la actual
% vy = velocidad de avance del gancho en direcciòn Y
% detectGan= variable que indica si se ha detectado el gancho al menos una vez
%           (a partir de la segunda iteración)
% acufalcon= variable de control para indicar si de detectò gancho en la 
%            iteraciòn anterior (0= si se detectó; 1= no se detectó)
% hc0 = altura de la carga en la iteraciòn anterior
% rc0 = radio de la carga en la iteración anterior
% tcarga = Tamaño màximo de busqueda en la carga (ventana: 2tcarga*2tcarga)
%
% SALIDAS
% (xg,yg,zg) = posición actual del gancho 
% (xc,yc,zc) = posición actual de la carga (centro del cilindro)
% vx,vy,vz = velocidad de avance actual del gancho en direcciòn X, Y y Z 
% fallo= vairable de análisis estadístico: va sumando la cantidad de fallos
%        en la detección del gancho
% hcarg = altura de la carga actualizado
% radcarg = radio de la carga actualizado
% obs = nubes de puntos de posibles obstàculos

n2=0;
n3=0;
obs=zeros;
k=0;
m=nubfil.Count;
xcarg=zeros; ycarg=zeros; zcarg=zeros;

if detectGan==0 % No se ha detectado el gancho previamente
    for i=1:m   % 1era depuración: dimensiones de la ventana proyectada hacia abajo: 2mx2m
        if abs(nubfil.Location(i,1)-xriel)<=tcarga && abs(nubfil.Location(i,2)-ycar)<=tcarga && nubfil.Location(i,3)<0.8 && nubfil.Location(i,2)>2 
            n2=n2+1;
            k=k+1;
            xcarg(k)=nubfil.Location(i,1);
            ycarg(k)=nubfil.Location(i,2);
            zcarg(k)=nubfil.Location(i,3);
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

else % Se ha detectado el gancho al menos una vez
    for i=1:m   % 1era depuración: dimensiones de la ventana proyectada hacia abajo: 2mx2m
        if abs(nubfil.Location(i,1)-xriel)<=tcarga && abs(nubfil.Location(i,2)-ycar)<=tcarga && nubfil.Location(i,3)<0.8 && nubfil.Location(i,3)>zc0-(hc0+1) && nubfil.Location(i,2)>2 
            n2=n2+1;
            k=k+1;
            xcarg(k)=nubfil.Location(i,1);
            ycarg(k)=nubfil.Location(i,2);
            zcarg(k)=nubfil.Location(i,3);
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

if n2>0    
    [numclus,xclus,yclus,zclus,distxy] = clusterPoint(xcarg,ycarg,zcarg);
    
    maxsepar=0;
    
    if numclus>=2
        for i=1:numclus-1
            separ=(distxy(i+1)-distxy(i));
            if abs(separ)>=maxsepar
                maxsepar=abs(separ);
                xg=xclus(i);
                yg=yclus(i);
                ind1nubcarg=i+1;
            end
        end
        
    else
        xg=(xg0+xclus)/2;
        yg=(yg0+yclus)/2;    
        ind1nubcarg=1;
    end
    xc=xg;
    yc=yg;

    if numclus-ind1nubcarg>0        
        acuz=0; contz=0;
        for jj=ind1nubcarg:numclus
            acuz=acuz+zclus(jj);
            contz=contz+1;
        end
        zcaprox=acuz/contz;
    else        
        zcaprox=zclus(numclus);
    end
    zmin=min(zcarg);
    if zcaprox-hc0/3<zmin
        zc=zcaprox;
    else
        zc=zmin+hc0/3;
    end
 
    fallo=0;
    acufalcon=0;

    
    if numclus-ind1nubcarg>0        
        hcprev=3*max(abs(zclus(ind1nubcarg)-zc),abs(zc-zmin));
    else        
        if numclus>=2
            hcprev=zclus(numclus-1)-zclus(numclus)-0.2;
        else
            hcprev=hc0;
        end
   end

    distgan=zeros;

    for i=1:k
        distgan(i)=sqrt((xcarg(i)-xg)^2+(ycarg(i)-yg)^2);
    end
    rcprev=max(distgan);

     if  detectGan==1 % primera detecciòn del gancho
        hcarg=hcprev;
        radcarg=rcprev;
     else             % Detecciones posteriores (una vez detectada la primera vez)
        if hcprev-hc0<0.2 && hcprev>hc0
            hcarg=(2*hc0+hcprev)/3;
        else
          hcarg=hc0;  
        end         
        radcarg=(3*rc0+rcprev)/4;
     end
     zg=zc+hcarg/2+0.2;
end



if detectGan==0 %Primeras entradas hasta detectar el gancho
        xg=0;
        yg=0;
        zg=0;
        xc=0;
        yc=0;
        zc=0;
        hcarg=hc0;
        radcarg=rc0;
        fallo=1;
        acufalcon=0;
end

if n2==0 && detectGan>=1 %Entradas posteriores (ya detectó gancho previamente) y no detectó gancho
    if acufalcon<1
        xc=xc0;
        yc=yc0+vy*dt;
        zc=zc0;
        xg=xc;
        yg=yc;
        zg=zg0;
        hcarg=hc0;
        radcarg=rc0;
        acufalcon=acufalcon+1;
    else    
        xc=xc0;
        yc=yc0;
        zc=zc0;
        xg=xc;
        yg=yc;
        zg=zg0;
        hcarg=hc0;
        radcarg=rc0;
        acufalcon=acufalcon+1;
    end  
    fallo=1;
end

if detectGan<=1
    vx=0;
    vy=0;
    vz=0;
else
    vx=(xc-xc0)/dt;
    vy=(yc-yc0)/dt;
    vz=(zc-zc0)/dt;
end

