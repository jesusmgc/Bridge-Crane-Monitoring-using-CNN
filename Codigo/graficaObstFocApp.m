function graficaObstFocApp (app,riesg,ptRies,ptColis,priscar,priscab,fleVsisM)
%FUNCIÒN PARA GRAFICAR VOLUMEN DE BÙSQUEDA DE FOCALIZADA DE OBSTÀCULOS
%(PRISMA) Y EL VECTOR DE VELOCIDAD
%----------------------------------------------

hold(app.UIAxes,'on');

if riesg==1
    plot3(app.UIAxes,ptRies(:,1),ptRies(:,2),ptRies(:,3),'.','Color',[1 0.5 0],'markersize',5);
end

if riesg==2
    plot3(app.UIAxes,ptColis(:,1),ptColis(:,2),ptColis(:,3),'.','Color',[1 0 0],'markersize',6);
end

%Dibujo prisma de bùsqueda alrededor de la carga

x1=[priscar(1,1), priscar(2,1), priscar(3,1), priscar(4,1), priscar(1,1)];
y1=[priscar(1,2), priscar(2,2), priscar(3,2), priscar(4,2), priscar(1,2)];
z1=[priscar(1,3), priscar(2,3), priscar(3,3), priscar(4,3), priscar(1,3)];
plot3 (app.UIAxes,x1,y1,z1,'Color',[0.9 0.9 0.9]);

x2=[priscar(5,1), priscar(6,1), priscar(7,1), priscar(8,1), priscar(5,1)];
y2=[priscar(5,2), priscar(6,2), priscar(7,2), priscar(8,2), priscar(5,2)];
z2=[priscar(5,3), priscar(6,3), priscar(7,3), priscar(8,3), priscar(5,3)];
plot3 (app.UIAxes,x2,y2,z2,'Color',[0.9 0.9 0.9]);

plot3(app.UIAxes,[priscar(1,1), priscar(5,1)],[priscar(1,2), priscar(5,2)],[priscar(1,3), priscar(5,3)],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[priscar(2,1), priscar(6,1)],[priscar(2,2), priscar(6,2)],[priscar(2,3), priscar(6,3)],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[priscar(3,1), priscar(7,1)],[priscar(3,2), priscar(7,2)],[priscar(3,3), priscar(7,3)],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[priscar(4,1), priscar(8,1)],[priscar(4,2), priscar(8,2)],[priscar(4,3), priscar(8,3)],'Color',[0.9 0.9 0.9]);

%Dibujo prisma de bùsqueda alrededor del cable
x4=[priscab(1,1), priscab(2,1), priscab(3,1), priscab(4,1), priscab(1,1)];
y4=[priscab(1,2), priscab(2,2), priscab(3,2), priscab(4,2), priscab(1,2)];
z4=[priscab(1,3), priscab(2,3), priscab(3,3), priscab(4,3), priscab(1,3)];
plot3 (app.UIAxes,x4,y4,z4,'Color',[0.9 0.9 0.9]);

x5=[priscab(5,1), priscab(6,1), priscab(7,1), priscab(8,1), priscab(5,1)];
y5=[priscab(5,2), priscab(6,2), priscab(7,2), priscab(8,2), priscab(5,2)];
z5=[priscab(5,3), priscab(6,3), priscab(7,3), priscab(8,3), priscab(5,3)];
plot3 (app.UIAxes,x5,y5,z5,'Color',[0.9 0.9 0.9]);

plot3(app.UIAxes,[priscab(1,1), priscab(5,1)],[priscab(1,2), priscab(5,2)],[priscab(1,3), priscab(5,3)],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[priscab(2,1), priscab(6,1)],[priscab(2,2), priscab(6,2)],[priscab(2,3), priscab(6,3)],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[priscab(3,1), priscab(7,1)],[priscab(3,2), priscab(7,2)],[priscab(3,3), priscab(7,3)],'Color',[0.9 0.9 0.9]);
plot3(app.UIAxes,[priscab(4,1), priscab(8,1)],[priscab(4,2), priscab(8,2)],[priscab(4,3), priscab(8,3)],'Color',[0.9 0.9 0.9]);

%Dibujo flecha de velocidad
plot3(app.UIAxes,[fleVsisM(1,1), fleVsisM(2,1)],[fleVsisM(1,2), fleVsisM(2,2)],[fleVsisM(1,3), fleVsisM(2,3)],'Color',[0 0 0.5],'linewidth',1.5);
plot3(app.UIAxes,[fleVsisM(3,1), fleVsisM(2,1)],[fleVsisM(3,2), fleVsisM(2,2)],[fleVsisM(3,3), fleVsisM(2,3)],'Color',[0 0 0.5]);
plot3(app.UIAxes,[fleVsisM(4,1), fleVsisM(2,1)],[fleVsisM(4,2), fleVsisM(2,2)],[fleVsisM(4,3), fleVsisM(2,3)],'Color',[0 0 0.5]);
