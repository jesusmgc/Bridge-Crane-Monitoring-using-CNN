function graficaObstOmniApp (app,riesg,xcen,ycen,zcen,xrield,ptRies,ptColis,rcab,resf)
%FUNCIÒN PARA GRAFICAR SUPERFICIE DE BÙSQUEDA OMNIDIRECCIONAL DE OBSTÀCULOS
%(PRISMA)
%----------------------------------------------

hold(app.UIAxes,'on');

if riesg==1
    plot3(app.UIAxes,ptRies(:,1),ptRies(:,2),ptRies(:,3),'.','Color',[1 0.5 0],'markersize',5);
end

if riesg==2
    plot3(app.UIAxes,ptColis(:,1),ptColis(:,2),ptColis(:,3),'.','Color',[1 0 0],'markersize',6);
end

%Dibujo esfera de bùsqueda alrededor de la carga

x1=[xcen+resf, xcen+resf*cosd(30), xcen+resf*cosd(60), xcen, xcen+resf*cosd(120), xcen+resf*cosd(150), xcen-resf, xcen+resf*cosd(210), xcen+resf*cosd(240), xcen, xcen+resf*cosd(300), xcen+resf*cosd(330),xcen+resf];
y1=[ycen, ycen+resf*sind(30), ycen+resf*sind(60), ycen+resf, ycen+resf*sind(120), ycen+resf*sind(150), ycen, ycen+resf*sind(210), ycen+resf*sind(240), ycen-resf, ycen+resf*sind(300), ycen+resf*sind(330), ycen];
z1= [zcen, zcen, zcen, zcen, zcen, zcen, zcen, zcen, zcen, zcen, zcen, zcen, zcen];
plot3 (app.UIAxes,x1,y1,z1,'Color',[0.9 0.9 0.9]);

z2=[zcen+resf, zcen+resf*cosd(30), zcen+resf*cosd(60), zcen, zcen+resf*cosd(120), zcen+resf*cosd(150), zcen-resf, zcen+resf*cosd(210), zcen+resf*cosd(240), zcen, zcen+resf*cosd(300), zcen+resf*cosd(330),zcen+resf];
x2=[xcen, xcen+resf*sind(30), xcen+resf*sind(60), xcen+resf, xcen+resf*sind(120), xcen+resf*sind(150), xcen, xcen+resf*sind(210), xcen+resf*sind(240), xcen-resf, xcen+resf*sind(300), xcen+resf*sind(330), xcen];
y2= [ycen, ycen, ycen, ycen, ycen, ycen, ycen, ycen, ycen, ycen, ycen, ycen, ycen];
plot3 (app.UIAxes,x2,y2,z2,'Color',[0.9 0.9 0.9]);

y2=[ycen+resf, ycen+resf*cosd(30), ycen+resf*cosd(60), ycen, ycen+resf*cosd(120), ycen+resf*cosd(150), ycen-resf, ycen+resf*cosd(210), ycen+resf*cosd(240), ycen, ycen+resf*cosd(300), ycen+resf*cosd(330),ycen+resf];
z2=[zcen, zcen+resf*sind(30), zcen+resf*sind(60), zcen+resf, zcen+resf*sind(120), zcen+resf*sind(150), zcen, zcen+resf*sind(210), zcen+resf*sind(240), zcen-resf, zcen+resf*sind(300), zcen+resf*sind(330), zcen];
x2= [xcen, xcen, xcen, xcen, xcen, xcen, xcen, xcen, xcen, xcen, xcen, xcen, xcen];
plot3 (app.UIAxes,x2,y2,z2,'Color',[0.9 0.9 0.9]);

%Dibujo cilindro de bùsqueda alrededor del cable
x3=[xrield+rcab, xrield+rcab*cosd(30), xrield+rcab*cosd(60), xrield, xrield+rcab*cosd(120), xrield+rcab*cosd(150), xrield-rcab, xrield+rcab*cosd(210), xrield+rcab*cosd(240), xrield, xrield+rcab*cosd(300), xrield+rcab*cosd(330),xrield+rcab];
y3=[ycen, ycen+rcab*sind(30), ycen+rcab*sind(60), ycen+rcab, ycen+rcab*sind(120), ycen+rcab*sind(150), ycen, ycen+rcab*sind(210), ycen+rcab*sind(240), ycen-rcab, ycen+rcab*sind(300), ycen+rcab*sind(330), ycen];
z3= [1.05, 1.05, 1.05, 1.05, 1.05, 1.05, 1.05, 1.05, 1.05, 1.05, 1.05, 1.05, 1.05];
plot3 (app.UIAxes,x3,y3,z3,'Color',[0.9 0.9 0.9]);


zaux=sqrt(resf^2-rcab^2)+zcen;
x4=[xcen+rcab, xcen+rcab*cosd(30), xcen+rcab*cosd(60), xcen, xcen+rcab*cosd(120), xcen+rcab*cosd(150), xcen-rcab, xcen+rcab*cosd(210), xcen+rcab*cosd(240), xcen, xcen+rcab*cosd(300), xcen+rcab*cosd(330),xcen+rcab];
z4= [zaux, zaux, zaux, zaux, zaux, zaux, zaux, zaux, zaux, zaux, zaux, zaux, zaux];
plot3 (app.UIAxes,x4,y3,z4,'Color',[0.9 0.9 0.9]);

plot3(app.UIAxes,[xcen+rcab, xrield+rcab],[ycen, ycen],[zaux, 1.05],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[xcen+rcab*cosd(30), xrield+rcab*cosd(30)],[ycen+rcab*sind(30), ycen+rcab*sind(30)],[zaux, 1.05],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[xcen+rcab*cosd(60), xrield+rcab*cosd(60)],[ycen+rcab*sind(60), ycen+rcab*sind(60)],[zaux, 1.05],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[xcen, xrield],[ycen+rcab, ycen+rcab],[zaux, 1.05],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[xcen+rcab*cosd(120), xrield+rcab*cosd(120)],[ycen+rcab*sind(120), ycen+rcab*sind(120)],[zaux, 1.05],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[xcen+rcab*cosd(150), xrield+rcab*cosd(150)],[ycen+rcab*sind(150), ycen+rcab*sind(150)],[zaux, 1.05],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[xcen-rcab, xrield-rcab],[ycen, ycen],[zaux, 1.05],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[xcen+rcab*cosd(210), xrield+rcab*cosd(210)],[ycen+rcab*sind(210), ycen+rcab*sind(210)],[zaux, 1.05],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[xcen+rcab*cosd(240), xrield+rcab*cosd(240)],[ycen+rcab*sind(240), ycen+rcab*sind(240)],[zaux, 1.05],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[xcen, xrield],[ycen-rcab, ycen-rcab],[zaux, 1.05],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[xcen+rcab*cosd(300), xrield+rcab*cosd(300)],[ycen+rcab*sind(300), ycen+rcab*sind(300)],[zaux, 1.05],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[xcen+rcab*cosd(330), xrield+rcab*cosd(330)],[ycen+rcab*sind(330), ycen+rcab*sind(330)],[zaux, 1.05],'Color',[0.9 0.9 0.9]);





