function [numclus,xclus,yclus,zclus,distxy] = clusterPoint(xcarg,ycarg,zcarg)
%FUNCIÓN PARA AGRUPAR PUNTOS VECINOS DE ACUERDO A LA DISTANCIA ENTRE ELLOS
%
%ENTRADAS:
%(xcarg,ycarg,zcarg): Coordenadas XYZ de los puntos a agrupar
%
%SALIDAS:
%numclus: cantidad de clusters o agrupaciones realizadas
%xclus: coordenadas X de los centroides de los clusters logrados
%yclus: coordenadas Y de los centroides de los clusters logrados
%zclus: coordenadas Z de los centroides de los clusters logrados
%distxy: distancias sobre un plano XY desde los centroides de los clusters
%        al sistema de referencia global con coordenadas (0,0,0)
%
%NOTA: los centroides en la salida están organizados de manera descendente
%       desde Z mayor
%--------------------------------------------------------------------------

rb=0.3;
% rb: distancia de búsqueda entre puntos vecinos

n=length(zcarg);

nubBusq=[xcarg' ycarg' zcarg'];

Idx = rangesearch(nubBusq,nubBusq,rb,'SortIndices',false);
maxind=0;
for i=1:n
    ind=cell2mat(Idx(i));
    longind=length(ind);
    if longind>maxind
        maxind=longind;
    end
end
matind=zeros(maxind,n);

for i=1:n 
    ind=cell2mat(Idx(i));
    lind=length(ind);
    for ii=1:lind
        matind(i,ii)=ind(ii);
    end
end
np=n;
for i=1:np
    j=i+1;
    while j<=np
        inter=intersect(matind(i,:),matind(j,:));
        maxinter=max(inter);
        if maxinter>0
            filainter=union(matind(i,:),matind(j,:));
            lfil=length(filainter);
            matind(i,:)=zeros;
            for k=1:lfil
                matind(i,k)=filainter(k);
            end
            matind (j,:)=[];
            j=j-1;
            np=length( matind(:,1));
        end
        j=j+1;
    end

end
matpos=zeros;
for i=1:np
    npunt=0;
    acux=0; acuy=0; acuz=0;
    for j=1:n
        if matind (i,j)>0
            acux=acux+xcarg(matind (i,j));
            acuy=acuy+ycarg(matind (i,j));
            acuz=acuz+zcarg(matind (i,j));
            npunt=npunt+1;
        end
    end
    matpos(i,1)=acux/npunt;
    matpos(i,2)=acuy/npunt;
    matpos(i,3)=acuz/npunt;
    matpos(i,4)=sqrt(matpos(i,1)^2+matpos(i,2)^2);
end

[~, s] = sort(matpos(:, 3),'descend');
matposorg=matpos(s, :);

xclus=matposorg(:,1);
yclus=matposorg(:,2);
zclus=matposorg(:,3);
distxy=matposorg(:,4);
numclus=np;

end
