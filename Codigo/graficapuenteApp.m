function graficapuenteApp (app,xrield,ycard,xg,yg,zg,nub,ov2)
%FUNCIÒN PARA GRAFICAR LA NUBES DE PUNTOS JUNTO CON RIEL, CARRO, GANCHO Y
%CARGA
%----------------------------------------------
%
%
%Dibujo nube de puntos
hold(app.UIAxes,'off');

app.UIAxes.XLim=[-15 7];
app.UIAxes.YLim=[2 14];
app.UIAxes.ZLim=[-5 3];
app.UIAxes.XLabel.String='x (m)';
app.UIAxes.YLabel.String='y (m)';
app.UIAxes.ZLabel.String='z (m)';

plot3(app.UIAxes,nub.Location(:,1),nub.Location(:,2),nub.Location(:,3),'.','Color',[0 0 0],'markersize',1);
hold(app.UIAxes,'on');

if ov2==1
    
    %dibujo del riel
    x1=[xrield-0.25/2,xrield+0.25/2,xrield+0.25/2,xrield-0.25/2, xrield-0.25/2];
    y1=[2, 2, 2, 2, 2];
    z1=[1.3, 1.3, 1.8, 1.8, 1.3];
    plot3 (app.UIAxes,x1,y1,z1,'Color',[0.97 0.85 0.09],'linewidth',1.5);
    
    x2=[xrield-0.25/2,xrield+0.25/2,xrield+0.25/2,xrield-0.25/2];
    y2=[11, 11, 11, 11];
    z2=[1.3, 1.3, 1.8, 1.8];
    plot3 (app.UIAxes,x2,y2,z2,'Color',[0.97 0.85 0.09],'linewidth',1.5);
    
    x3=[xrield-0.25/2,xrield-0.25/2,xrield-0.25/2,xrield-0.25/2];
    y3=[2, 11, 11, 2];
    z3=[1.3, 1.3, 1.8, 1.8];
    plot3 (app.UIAxes,x3,y3,z3,'Color',[0.97 0.85 0.09],'linewidth',1.5);
    
    x4=[xrield+0.25/2,xrield+0.25/2,xrield+0.25/2,xrield+0.25/2];
    y4=[2, 11, 11, 2];
    z4=[1.3, 1.3, 1.8, 1.8];
    plot3 (app.UIAxes,x4,y4,z4,'Color',[0.97 0.85 0.09],'linewidth',1.5);
    
    %Dibujo del carro
    x5=[xrield-0.525, xrield+0.525, xrield+0.525, xrield+0.25/2,xrield+0.25/2,xrield-0.25/2, xrield-0.25/2, xrield-0.525, xrield-0.525];
    y5=[ycard-0.4,ycard-0.4,ycard-0.4,ycard-0.4,ycard-0.4,ycard-0.4,ycard-0.4,ycard-0.4,ycard-0.4];
    z5=[1.05, 1.05, 1.55, 1.55, 1.3, 1.3, 1.55, 1.55, 1.05];
    plot3 (app.UIAxes,x5,y5,z5,'Color',[0 0.5 1],'linewidth',1.5);
    
    x6=[xrield-0.525, xrield+0.525, xrield+0.525, xrield+0.25/2,xrield+0.25/2,xrield-0.25/2, xrield-0.25/2, xrield-0.525, xrield-0.525];
    y6=[ycard+0.15,ycard+0.15,ycard+0.15,ycard+0.15,ycard+0.15,ycard+0.15,ycard+0.15,ycard+0.15,ycard+0.15];
    z6=[1.05, 1.05, 1.55, 1.55, 1.3, 1.3, 1.55, 1.55, 1.05];
    plot3 (app.UIAxes,x6,y6,z6,'Color',[0 0.5 1],'linewidth',1.5);
    
    x7=[xrield-0.525, xrield-0.25/2,xrield-0.25/2,xrield-0.525,xrield-0.525];
    y7=[ycard-0.4, ycard-0.4, ycard+0.15, ycard+0.15, ycard-0.4];
    z7=[1.55, 1.55, 1.55, 1.55, 1.55];
    plot3 (app.UIAxes,x7,y7,z7,'Color',[0 0.5 1],'linewidth',1.5);
    
    x7b=[xrield+0.525, xrield+0.25/2,xrield+0.25/2,xrield+0.525,xrield+0.525];
    y7b=[ycard-0.4, ycard-0.4, ycard+0.15, ycard+0.15, ycard-0.4];
    z7b=[1.55, 1.55, 1.55, 1.55, 1.55];
    plot3 (app.UIAxes,x7b,y7b,z7b,'Color',[0 0.5 1],'linewidth',1.5);
    
    x8=[xrield-0.25/2,xrield+0.25/2,xrield+0.25/2,xrield-0.25/2,xrield-0.25/2];
    y8=[ycard-0.4, ycard-0.4, ycard+0.15, ycard+0.15, ycard-0.4];
    z8=[1.3, 1.3, 1.3, 1.3, 1.3];
    plot3 (app.UIAxes,x8,y8,z8,'Color',[0 0.5 1],'linewidth',1.5);
    
    x9=[xrield-0.525,xrield+0.525, xrield+0.525,xrield-0.525, xrield-0.525];
    y9=[ycard-0.4, ycard-0.4, ycard+0.15, ycard+0.15, ycard-0.4];
    z9=[1.05, 1.05,1.05,1.05,1.05];
    plot3 (app.UIAxes,x9,y9,z9,'Color',[0 0.5 1],'linewidth',1.5);
    
    %Dibujo del gancho
    x10=[xg-0.1, xg-0.1, xg+0.1, xg+0.1, xg, xg];
    y10=[yg,yg,yg,yg,yg,yg];
    z10=[zg, zg-0.1, zg-0.1, zg+0.1, zg+0.1, zg+0.2];
    plot3 (app.UIAxes,x10,y10,z10,'Color',[1 0 0],'linewidth',1.5);
    
    x11=[xg-0.1,  xg+0.1];
    y11=[yg,yg];
    z11=[zg+0.2,zg+0.2];
    plot3 (app.UIAxes,x11,y11,z11,'Color',[1 0 0],'linewidth',1.5);
    
    %Dibujo del cable
    x12=[xg-0.1, xrield-0.1];
    y12=[yg,yg];
    z12=[zg+0.2,1.05];
    plot3 (app.UIAxes,x12,y12,z12,'Color',[0.5 0.5 0.5],'linewidth',1.5);
    
    x13=[xg+0.1, xrield+0.1];
    y13=[yg,yg];
    z13=[zg+0.2,1.05];
    plot3 (app.UIAxes,x13,y13,z13,'Color',[0.5 0.5 0.5],'linewidth',1.5);
end
