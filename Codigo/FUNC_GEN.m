%FUNCION GENERAL QUE ACTIVA EL SISTEMA DE DETECCIÒN DE GANCHO, CARGAS Y
%COLISIONES
%-----------------------------------------------------------------------

tipCarg=2;
%tipCarg=1: solo gancho
%tipCarg=2: gancho + carga

tipCol=1;
%tipCol=1: Detector de colisiones omnidireccional (con base en esfera)
%tipCol=2: Detector de colisiones focalizado (con base en la direcciòn de
%          desplazamiento

disSeg=1; 
%disSeg= distancia de seguridad en m, desde el borde de la carga.

nnub=400;
%nnub= número de nubes a analizar

tcarga=0.75;
%tcarga= tamaño estimado de la carga en ventana cuadrada 2*tcarga desde el centro
%--------------------------------------------------------

%Inicialización de variables
acufallo=0;
acufalcon=0;
detectGan=0;
y0car=0;
xriel0=0;
vx=0; vy=0; vz=0;
xg0=0;yg0=0;zg0=0;
xc0=0;yc0=0;zc0=0;
dt=0.2;
t=zeros;
xgat=zeros; ygat=zeros; zgat=zeros;
hc0=0;rc0=0; zini0=0;
riesgprev=0;

% Análisis de secuencia de nueves almacenadas previamente
if tipCarg==1 %Solo gancho
    for i=1:nnub
        tact=etime(datevec(timestamps(i)),datevec(timestamps(1)));
        t(i)=tact;
        if i>1
            dt=etime(datevec(timestamps(i)),datevec(timestamps(i-1)));
        end
        
        %Detección de riel y carro
        [xrield, ycar,nubfil]=EvaluaCNNsis (frames(i),y0car,xriel0,net,detectGan);
        
        %Detección y graficación puente grua con gancho
        [xg,yg,zg,vx,vy,vz,fallo,detectGan,acufalcon,obs] = detectGancho(nubfil,xrield,ycar,xg0,yg0,zg0,dt,vy,vz,detectGan,acufalcon);
        acufallo=acufallo+fallo;  
        y0car=yg;        
        xg0=xg; yg0=yg; zg0=zg;
        xgat(i)=xg;
        ygat(i)=yg;
        zgat(i)=zg;
        graficapuente (xrield,yg,xg,yg,zg,nubfil)

        % DETECCIÒN DE COLISIONES
        %-----------------------------------------------------------------
        hcarg=0.25;
        radcarg=0.1;
        xcen=xg;
        ycen=yg;
        zcen=zg;
        if tipCol==1
            [riesg,ptRies,ptColis,rcab,resf] = DetectColOmnid(obs,hcarg,radcarg,xcen,ycen,zcen,xrield,xg,zg,disSeg,riesgprev);
            graficaObstOmni (riesg,xcen,ycen,zcen,xrield,ptRies,ptColis,rcab,resf);
        else
            [riesg,ptRies,ptColis,priscab,priscar,fleVsisM] = DetectColFoc(obs,hcarg,radcarg,xcen,ycen,zcen,xrield,xg,zg,vx,vy,vz,disSeg,riesgprev);
            graficaObstFoc (riesg,ptRies,ptColis,priscar,priscab,fleVsisM);
        end
    end
    %plot3(xgat,ygat,zgat,'.','Color',[0 0.56 0.22],'markersize',5);
    PorcentajeAciertoCNN=(i-acufallo)/i*100;
    
else   %Gancho màs carga        
    for i=1:nnub
        
        tact=etime(datevec(timestamps(i)),datevec(timestamps(1)));
        t(i)=tact;
        if i>1
            dt=etime(datevec(timestamps(i)),datevec(timestamps(i-1)));
        end
        
        %Detección de riel y carro
        [xrield, ycard,nubfil]=EvaluaCNNsis (frames(i),y0car,xriel0,net,detectGan);
        
        %Detección y graficación puente grua con gancho
        [xg,yg,zg,xc,yc,zc,vx,vy,vz,fallo,detectGan,acufalcon,hcarg,radcarg,obs] = detectCarga(nubfil,xrield,ycard,xg0,yg0,zg0,xc0,yc0,zc0,dt,vy,detectGan,acufalcon,hc0,rc0,tcarga);
        acufallo=acufallo+fallo;  
        xriel0=xrield;
        y0car=yg;        
        xg0=xg; yg0=yg; zg0=zg;
        xc0=xc; yc0=yc; zc0=zc; hc0=hcarg; 
        xgat(i)=xc;
        ygat(i)=yc;
        zgat(i)=zc;
                        
        % DETECCIÒN DE COLISIONES
        %-----------------------------------------------------------------
        xcen=xc;
        ycen=yc;
        zcen=zc;
        if tipCol==1
            [riesg,ptRies,ptColis,rcab,resf] = DetectColOmnid(obs,hcarg,radcarg,xcen,ycen,zcen,xrield,xg,zg,disSeg,riesgprev);
            if riesg==2
                radcarg=rc0;
            end
            graficapuenteCarga (xrield,yg,radcarg,hcarg,xg,yg,zg,zc,nubfil)
            graficaObstOmni (riesg,xcen,ycen,zcen,xrield,ptRies,ptColis,rcab,resf);
        else
            [riesg,ptRies,ptColis,priscab,priscar,fleVsisM] = DetectColFoc(obs,hcarg,radcarg,xcen,ycen,zcen,xrield,xg,zg,vx,vy,vz,disSeg,riesgprev);
            if riesg==2
                radcarg=rc0;
            end
            graficapuenteCarga (xrield,yg,radcarg,hcarg,xg,yg,zg,zc,nubfil)
            graficaObstFoc (riesg,ptRies,ptColis,priscar,priscab,fleVsisM);
        end
        riesgprev=riesg;
        rc0=radcarg;
        
    end
    plot3(xgat,ygat,zgat,'.','color',[0 0.56 0.22],'markersize',5);
    PorcentajeAciertoCNN=(i-acufallo)/i*100;
end





