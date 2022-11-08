function [riesg,ptRies,ptColis,priscab,priscar,fleVsisM] = DetectColFoc(obs,hcarg,radcarg,xcen,ycen,zcen,xrield,xg,zg,vx,vy,vz,disSeg,riesgprev)
%PROGRAMA PARA DETECCIÒN DE COLISIONES EN FORMA FOCALIZADA (EN DIRECCIÒN DE
%LA VELOCIDAD)
%--------------------------------------------------------------------------
% PRINCIPIO DE FUNCIONAMIENTO
% Se busca en un prisma con centro de una cara en xcen,ycen,zcen. Dicha cara está contenida
% en un plano normal a la dirección de la velocidad de avance de la carga. Las dimensiones de
% dicha cara son las dimensiones de la carga. Dicha cara se proyecta en direcciòn de la 
% velocidad absoluta con una longitud correspondiente al radio de la carga màs una distancia
% de seguridad. Se detectan aquellos puntos que presenten riesgo de colisiòn (dentro del prisma)
% o que estén tocando o a punto de tocar la carga.
%
% Se toma en consideración la detecciòn del cable a través de un prisma con el cable 
% contenido en una cara normal a la velocidad de % avance en direcciòn XY, el prisma
% se proyecta en direcciòn a la velocidad en direcciòn XY a una distancia de seguridad.
%
%ENTRADAS:
% obs = nube de puntos por debajo de 0.8 m, incluye obstàculos, gancho, cable y carga
% hcarg = altura de la carga
% radcarg =radio de la carga
% (xcen,ycen,zcen) = posiciòn central de la carga o gancho (si no hay
%                    carga), es el centro de la esfera de búsqueda
% xrield = coordenada X del riel
% (xg, zg) = coordenadas X y Z de la carga
% (vx,vy,vz) = velocidad de avance de la carga en direcciones X,Y,Z
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
% ptRies = nube de puntos con riesgo de colisión = 1 (dentro de los prismas de búsqueda del cable y carga)
% ptColis = nube de puntos con riesgo de colisiòn = 2 (muy cercanos a la carga o al cable)
% priscab = Coordenadas de los puntos que formaràn el prisma de bùsqueda en el cable (para su posterior representaciòn gràfica)
% priscar = Coordenadas de los puntos que formaràn el prisma de bùsqueda en la carga (para su posterior representaciòn gràfica)
% fleVsisM = Coordenadas de la flecha del vector de velocidad absoluta (para su posterior representaciòn gràfica)


recuc=0.2; % recucrimiento hecho a la carga
recub=0.4; %radio de recubrimiento del par de cables desde el eje imaginario entre cables
priscar=zeros(8,4);
priscab=zeros(8,4);
fleVsisM=zeros(4,4);
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

%Obtención de velocidad

vt=sqrt(vx^2+vy^2+vz^2);

if vt>0.01


    va=[vx/vt vy/vt vz/vt]; %Càlculo de velocidad y matriz transformaciòn carga
    if vz~=0
        nx=va(1); ny=va(2);
        nz=-(va(1)^2+va(2)^2)/va(3);
        modn=sqrt(nx^2+ny^2+nz^2);
        vn=[nx/modn ny/modn nz/modn];
    else
        vn=[0 0 1];

    end

    vo=cross(va,vn);
    vp=[xcen ycen zcen];
    mat=[vn(1) vn(2) vn(3) -vn*vp'; vo(1) vo(2) vo(3) -vo*vp'; va(1) va(2) va(3) -va*vp'; 0 0 0 1 ];

    vtxy=sqrt(vx^2+vy^2);
    vac=[vx/vtxy vy/vtxy 0]; %Càlculo de velocidad y matriz transformaciòn cable
    vnc=[0 0 1];
    voc=cross(vac,vnc);
    matc=[vnc(1) vnc(2) vnc(3) -vnc*vp'; voc(1) voc(2) voc(3) -voc*vp'; vac(1) vac(2) vac(3) -vac*vp'; 0 0 0 1 ];
    
    fi=acos(vtxy/vt);  
    lonPrisHorC=(radcarg+recuc+disImp+disSeg)*cos(fi)-sign(vz)*(hcarg/2+recuc+disImp)*sin(fi);
    lonPrisHorB=recub+disImp+disSeg;
    maxZcab=min(lonPrisHorB,lonPrisHorC); %màxima Z de busqueda en el cable (sistema local cable)

    for i=1:n
        riept=0;
    
        %Análisis de puntos pertenecientes a la carga o cable
        dispocarg=sqrt((obs(i,1)-xcen)^2+(obs(i,2)-ycen)^2);
        
        if dispocarg<=radcarg+recuc && obs(i,3)>=(zcen-hcarg/2-recuc) && obs(i,3)<=(zcen+hcarg/2+recuc) % Punto perteneciente a la carga
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
            ptoV=mat*[obs(i,1) obs(i,2) obs(i,3) 1]';
            if ptoV(1)<=(hcarg+recuc+disImp) && ptoV(1)>=-(hcarg+recuc+disImp) && ptoV(2)<=(radcarg+recuc+disImp) && ptoV(2)>=-(radcarg+recuc+disImp) && ptoV(3)<=(radcarg+recuc+disImp) && ptoV(3)>=-(radcarg+recuc+disImp)% respecto a la carga
                riept=2;
                k1=k1+1;
                ptColis(k1,1)=obs(i,1);
                ptColis(k1,2)=obs(i,2);
                ptColis(k1,3)=obs(i,3);
            end
        end
    
        if riept<2
            ptoC=matc*[obs(i,1) obs(i,2) obs(i,3) 1]';
            if ptoC(1)<=0.8 && ptoC(1)>=hcarg/2 && ptoC(2)<=(recub+disImp) && ptoC(2)>=-(recub+disImp) && ptoC(3)<=(recub+disImp)&& ptoC(3)>=-(recub+disImp) % respecto al cable
                riept=2;
                k1=k1+1;
                ptColis(k1,1)=obs(i,1);
                ptColis(k1,2)=obs(i,2);
                ptColis(k1,3)=obs(i,3);
            end
        end
    
        %Análisis del riesgo de colision (riesgo=1)
        
        if riept<2
             if ptoV(1)<=(hcarg/2+recuc+disImp) && ptoV(1)>=-(hcarg/2+recuc+disImp) && ptoV(2)<=(radcarg+recuc+disImp) && ptoV(2)>=-(radcarg+recuc+disImp) && ptoV(3)<=(radcarg+recuc+disImp+disSeg) && ptoV(3)>(radcarg+recuc+disImp) % respecto a la carga
                riept=1;
                k2=k2+1;
                ptRies(k2,1)=obs(i,1);
                ptRies(k2,2)=obs(i,2);
                ptRies(k2,3)=obs(i,3);
             end
        end
    
        if riept<1
            dx=sign(vz)*ptoC(3)*tan(fi);

            if ptoC(1)<=(0.8-zcen) && ptoC(1)>=(hcarg/2+recuc+disImp+dx) && ptoC(2)<=(recub+disImp) && ptoC(2)>=-(recub+disImp) && ptoC(3)>(recub+disImp)&& ptoC(3)<=maxZcab % respecto al cable
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

    %Coordenadas de los puntos para el dibujo de volumen de bùsqueda
    dxx=sign(vz)*maxZcab*tan(fi);
    
    posXprisCab=(hcarg/2+recuc+disImp)/cos(fi);
    if posXprisCab>0.8-zcen
        posXprisCab=0.8-zcen;
    end

    priscabZ=[0.8-zcen recub+disImp 0 1;...
        0.8-zcen -(recub+disImp) 0 1;...
        posXprisCab -(recub+disImp) 0 1;...
        posXprisCab recub+disImp 0 1;...
        0.8-zcen recub+disImp maxZcab 1;...
        0.8-zcen -(recub+disImp) maxZcab 1;...
        (hcarg/2+recuc+disImp)/cos(fi)+dxx -(recub+disImp) maxZcab 1;...
        (hcarg/2+recuc+disImp)/cos(fi)+dxx recub+disImp maxZcab 1];
    
    matc_1=[vnc(1) voc(1) vac(1) vp(1);vnc(2) voc(2) vac(2) vp(2);vnc(3) voc(3) vac(3) vp(3) ; 0 0 0 1 ];
    
    priscarZ=[hcarg/2+recuc+disImp radcarg+recuc+disImp 0 1;...
            hcarg/2+recuc+disImp -(radcarg+recuc+disImp) 0 1;...
            -(hcarg/2+recuc+disImp) -(radcarg+recuc+disImp) 0 1;...
            -(hcarg/2+recuc+disImp) radcarg+recuc+disImp 0 1;...
            hcarg/2+recuc+disImp radcarg+recuc+disImp radcarg+recuc+disImp+disSeg 1;...
            hcarg/2+recuc+disImp -(radcarg+recuc+disImp) radcarg+recuc+disImp+disSeg 1;...
            -(hcarg/2+recuc+disImp) -(radcarg+recuc+disImp) radcarg+recuc+disImp+disSeg 1;...
            -(hcarg/2+recuc+disImp) radcarg+recuc+disImp radcarg+recuc+disImp+disSeg 1];
    matg_1=[vn(1) vo(1) va(1) vp(1);vn(2) vo(2) va(2) vp(2);vn(3) vo(3) va(3) vp(3) ; 0 0 0 1 ];
    
    for k=1:8
        priscab(k,:)=(matc_1*priscabZ(k,:)')';
        priscar(k,:)=(matg_1*priscarZ(k,:)')';
    end
    
    % Coordenadas de los puntos para el dibujo de flecha de velocidad
    
    fleVsisC=[0 0 0 1; 0 0 vt 1; 0 0.1*vt 0.8*vt 1; 0 -0.1*vt 0.8*vt 1];
    for k=1:4
        fleVsisM(k,:)=(matg_1*fleVsisC(k,:)')';
    end
    
end
riesg=max(conRies);

if riesgprev==0 && riesg==2
    riesg=0;
    ptColis=zeros;
end





