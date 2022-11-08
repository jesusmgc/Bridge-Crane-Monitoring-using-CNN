function [xriel, ycar,nubfil]=EvaluaCNNsis (frames,y0car,xriel0,net,detectGan)
% CÓDIGO PARA DEPURAR Y SEGMENTAR NUBES DE PUNTOS Y EVALUARLAS CON LA RED 
% NEURONAL CNN PARA ENCONTRAR POSICIÒN DEL RIEL Y CARRO
%-------------------------------------------------
%PROCESO:
% 1) Limpieza y segmentación
        % a) Remoción de puntos NaN
        % b) Filtrado de nube
        % c) Segmentar nube para Z>=1 && z<=2 m (Observar zona superior-carro)
        % d) Uniformizar nubes con 2500 puntos
% 2) Detecciòn con la CNN
        % a) Normalizaciòn de la nube
        % b) Acondicionamiento
        % c) Evaluación de los puntos con la CNN
%--------------------------------------------------
% ENTRADAS
% frames = Nube de puntos leida del Lidar
% y0car = Coordenada Y del eje del carro en un istante anterior
% xriel0 = Coordenada X del eje del riel en un instante anterior
% net = red neuronal entrenada
% detectGan= variable que indica si se ha detectado el gancho al menos una vez
%           (a partir de la segunda iteración)
% SALIDAS
% xriel = Coordenada X del eje del riel
% ycar = coordenada y del carro
% nubfil = nube de puntos depurada

    clear nub
    clear nubN
    clear nubfil
    nub=frames;
    %Remoción de puntos Nan
    nubN = removeInvalidPoints(nub);
    %filtrado
    nubfil=pcdenoise(nubN);
    %segmentación para Z>=1
    m=nubfil.Count;
    k=0;
    xyzseg=zeros;
    for j=1:m
       if nubfil.Location(j,3)>=1 && nubfil.Location(j,3)<=2
           k=k+1;
           xyzseg(k,1)=nubfil.Location(j,1);
           xyzseg(k,2)=nubfil.Location(j,2);
           xyzseg(k,3)=nubfil.Location(j,3);
       end     
    end
    
    %---------------------------------------------
    %Muestreo de nube 
    xyzuni=xyzseg;
        if k>2500 %Si hay más de 2500 puntos se eliminarán aleatoriamente
            for j=k:-1:2501
            vecx=xyzuni(1:end,1); 
            xyzuni(randi([1 length(vecx)],1,1),:) = []; 
            end
        end
    
    if k<=2500 %Si hay menos de 2500 se duplicará el más lejanos en X
        vecx=xyzuni(1:end,1);
        [~, idx] = min(vecx);
        nvecx=length(vecx);
        for j=nvecx+1:1:2500
           xyzuni(j,1)=xyzuni(idx,1);
           xyzuni(j,2)=xyzuni(idx,2);
           xyzuni(j,3)=xyzuni(idx,3);            
        end
    end

    nubuni = pointCloud(xyzuni);
    %---------------------------------------------
    % Normalizar la nube
    ptCloudNorm = helperNormalizePointCloud(nubuni);
    %Covierte la nube en un arreglo compatible con la red
    ptCloudPrep = helperConvertPointCloud(ptCloudNorm);
    
    % Detección usando la red neuronal
    labelsPred = semanticseg(ptCloudPrep{1,1},net,'OutputType','uint8');

    %----------------------------------------------
    % Localización del eje del riel (xriel)

    acumXriel=0;
    criel=0;
    xrielpre=zeros;
    for i=1:2500   % 1era depuraciòn
        if labelsPred(i)==2 && xyzuni(i,2)<11
            acumXriel=acumXriel+xyzuni(i,1);
            criel=criel+1;
            xrielpre(criel)=xyzuni(i,1);
        end
    end
    Xrielprom=acumXriel/criel; % Coordenada X del riel preliminar
    
    acumXriel2=0;
    criel2=0;
    xrielpre2=zeros;
    for i=1:criel   % 2da depuraciòn
        if abs(xrielpre(i)-Xrielprom)<=1
            acumXriel2=acumXriel2+xrielpre(i);
            criel2=criel2+1;
            xrielpre2(criel2)=xrielpre(i);
        end
    end

    Xrielprom2=acumXriel2/criel2; % Coordenada X del riel preliminar dep

    acumXriel3=0;
    criel3=0;
    for i=1:criel2   % 2da depuraciòn
        if abs(xrielpre2(i)-Xrielprom2)<=0.5
            acumXriel3=acumXriel3+xrielpre2(i);
            criel3=criel3+1;
            %xrielpre3(criel3)=xrielpre2(i);
        end
    end
    
    xriel=acumXriel3/criel3; % Coordenada X del riel
    
    tipDat=isnan(xriel);
    if tipDat==1
        xriel=xriel0;
    end
      
    %-----------------------------------------------------
    %Localizaciòn del carro
    acumYcar=0;
    ccar=0;
    ycarpre=zeros;
    if detectGan==0
        for i=1:2500   % 1era depuración: etiqueta=Carro, distancia al eje del riel<1 y coordenada y<11
            if labelsPred(i)==3 && abs(xyzuni(i,1)-xriel)<1 && xyzuni(i,2)<11 && xyzuni(i,2)>2  
                acumYcar=acumYcar+xyzuni(i,2);
                ccar=ccar+1;
                ycarpre(ccar)=xyzuni(i,2);
            end
        end
    else
        for i=1:2500 % 1era depuración: etiqueta: Carro, distancia al eje del riel<1, coordenada y<11, Distancia respecto a "y" anterior<0.5
            if labelsPred(i)==3 && abs(xyzuni(i,1)-xriel)<1 && xyzuni(i,2)<11 && xyzuni(i,2)>2 && abs(xyzuni(i,2)-y0car)<=0.5 %%% ultima condiciòn añadida 
                acumYcar=acumYcar+xyzuni(i,2);
                ccar=ccar+1;
                ycarpre(ccar)=xyzuni(i,2);
            end
        end
    end

    Ycarprom=acumYcar/ccar; % Coordenada X del riel preliminar
   
    ii=0;
    puntElim=floor(ccar*0.2);  
    while ii<puntElim   % 2da depuración: eliminar el 20% de puntos más lejanos del centroide en coordenada y
        dist=zeros;
        for i=1:length(ycarpre)  
            dist(i)=abs(Ycarprom-ycarpre(i));
        end        
        [~,I] = max(dist);
        ycarpre(I)=[];
        ii=ii+1;
    end 

    acumYcar2=0;
    ccar2=0;
    for i=1:ccar-puntElim   
        acumYcar2=acumYcar2+ycarpre(i);
        ccar2=ccar2+1;
    end 
    Ycarprom2=acumYcar2/ccar2; % Coordenada X del riel preliminar

    if ccar2==0
         ycar=y0car;%+vy*dt;
    else
         ycar=Ycarprom2;
    end 
