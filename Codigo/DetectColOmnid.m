function [riesg,ptRies,ptColis,rcab,resf] = DetectColOmnid(obs,hcarg,radcarg,xcen,ycen,zcen,xrield,xg,zg,disSeg,riesgprev)
%PROGRAMA PARA DETECCIÒN DE COLISIONES EN FORMA OMNIDRECCIONAL
%--------------------------------------------------------------------------
% PRINCIPIO DE FUNCIONAMIENTO
% Se busca en uns esfera con centro en xcen,ycen,zcen, radio: el correspondiente al maximo de la carga
% màs una distancia de seguridad, aquellos puntos que presenten riesgo de colisiòn (dentro de la esfera)
% o que estén tocando o a punto de tocar la carga.
%
% Se toma en consideraciòn un cilindro de radio 0.1 m + distancia de seguridad 
% para detectar colisiones con el cable tambièn.
%
%ENTRADAS:
% obs = nube de puntos por debajo de 0.8 m, incluye obstàculos, gancho, cable y carga
% hcarg = altura de la carga
% radcarg =radio de la carga
% (xcen,ycen,zcen) = posiciòn central de la carga o gancho (si no hay
%                    carga), es el centro de la esfera de búsqueda
% xrield = coordenada X del riel
% (xg, zg) = coordenadas X y Z de la carga
% disSeg = distancia de seguridad para definir la esfera (desde el màximo
%           tamaño de la carga.
% riesgprev = variable que mide el riesgo en la iteraciòn anterior (ùtil
%             evitar falsos positivos de colisión)
%
%SALIDAS:
% riesg = variable que mide el riesgo de colisión general. Esta puede ser:
%         0: no hay riesgo de colisión
%         1: riesgo de colisiòn (puntos dentro de la esfera de búsqueda)
%         2: riesgo inminente o colisiòn producièndose (puntos dentro del 
%            volumen de la carga)
% ptRies = nube de puntos con riesgo de colisión = 1 (dentro de la esfera o cilindro de busqueda del cable)
% ptColis = nube de puntos con riesgo de colisiòn = 2 (muy cercanos a la carga o al cable)
% rcab = radio del cilindro de bùsqueda que recucre el cable
% resf = radio de la esfera de bùsqueda con centro en (xcen,ycen,zcen)

recuc=0.2; % recucrimiento hecho a la carga
recub=0.4; %radio de recubrimiento del par de cables desde el eje imaginario entre cables
rcab=recub+disSeg;
resf=sqrt((radcarg+recuc)^2+(hcarg/2+recuc)^2)+disSeg;
n=length(obs(:,1));
k1=0;
k2=0;
ptColis=zeros;
ptRies=zeros;
conRies=zeros;

if disSeg>0.2
    disImp=0.1;
else
    disImp=0.5*disSeg;
end

for i=1:n
    riept=0;

    %Análisis de puntos pertenecientes a la carga o cable
    dispocarg=sqrt((obs(i,1)-xcen)^2+(obs(i,2)-ycen)^2);
    
    if dispocarg<=radcarg+recuc && obs(i,3)>=(zcen-hcarg/2-recuc)  && obs(i,3)<=(zcen+hcarg/2+recuc) % Punto perteneciente a la carga
        riept=3;
    end

    m=(xrield-xg)/(1.05-zg);
    xcab=m*(obs(i,3)-zg)+xg; %coordenada X del cable par una altura dada por un punto analizado
    dispocab=sqrt((obs(i,1)-xcab)^2+(obs(i,2)-ycen)^2);
    if dispocab<=recub && obs(i,3)>(zcen+hcarg/2+recuc) % Punto perteneciente al cable
        riept=3;
    end

    %Análisis del riesgo inminente o colisiòn producièndose (riesgo=2)
    
    if riept<3
        if dispocarg<=(radcarg+recuc+disImp) && obs(i,3)>=(zcen-hcarg/2-recuc-disImp) && obs(i,3)<=(zcen+hcarg/2+recuc+disImp) % respecto a la carga
            riept=2;
            k1=k1+1;
            ptColis(k1,1)=obs(i,1);
            ptColis(k1,2)=obs(i,2);
            ptColis(k1,3)=obs(i,3);
        end
    end

    if riept<2   
        if dispocab<=(recub+disImp) && obs(i,3)>(zcen+hcarg/2+recuc+disImp) && obs(i,3)<=1 % respecto al cable
            riept=2;
            k1=k1+1;
            ptColis(k1,1)=obs(i,1);
            ptColis(k1,2)=obs(i,2);
            ptColis(k1,3)=obs(i,3);
        end
    end
    %Análisis del riesgo de colision (riesgo=1)
    
    if riept<2
        dispocaesf=sqrt((obs(i,1)-xcen)^2+(obs(i,2)-ycen)^2+(obs(i,3)-zcen)^2);
         if dispocaesf<=resf % respecto a la carga
            riept=1;
            k2=k2+1;
            ptRies(k2,1)=obs(i,1);
            ptRies(k2,2)=obs(i,2);
            ptRies(k2,3)=obs(i,3);
         end
    end

    if riept<1
        if dispocab<=rcab && obs(i,3)>zcen+resf && obs(i,3)<=1 % respecto al cable
            riept=1;
            k2=k2+1;
            ptRies(k2,1)=obs(i,1);
            ptRies(k2,2)=obs(i,2);
            ptRies(k2,3)=obs(i,3);
        end
    end

    if riept==3
        riept=-1;
    end
    conRies(i)=riept;

end
riesg=max(conRies);

if riesgprev==0 && riesg==2
    riesg=0;
    ptColis=zeros;
end