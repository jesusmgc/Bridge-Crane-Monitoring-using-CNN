function graficapuenteCarga (xrield,ycard,rcarg,hcarg,xg,yg,zg,zc,nub)
%FUNCIÒN PARA GRAFICAR LA NUBES DE PUNTOS JUNTO CON RIEL, CARRO, GANCHO Y
%CARGA
%----------------------------------------------
%
%
%Dibujo nube de puntos
figure (1)
hold off

plot3(nub.Location(:,1),nub.Location(:,2),nub.Location(:,3),'.','Color',[0 0 0],'markersize',1);
axis([-15 7 2 14 -5 3])
xlabel ('x (m)'); ylabel ('y (m)');zlabel ('z (m)');
hold on

%dibujo del riel
x1=[xrield-0.25/2,xrield+0.25/2,xrield+0.25/2,xrield-0.25/2, xrield-0.25/2];
y1=[2, 2, 2, 2, 2];
z1=[1.3, 1.3, 1.8, 1.8, 1.3];
plot3 (x1,y1,z1,'Color',[0.97 0.85 0.09],'linewidth',1.5);

x2=[xrield-0.25/2,xrield+0.25/2,xrield+0.25/2,xrield-0.25/2];
y2=[11, 11, 11, 11];
z2=[1.3, 1.3, 1.8, 1.8];
plot3 (x2,y2,z2,'Color',[0.97 0.85 0.09],'linewidth',1.5);

x3=[xrield-0.25/2,xrield-0.25/2,xrield-0.25/2,xrield-0.25/2];
y3=[2, 11, 11, 2];
z3=[1.3, 1.3, 1.8, 1.8];
plot3 (x3,y3,z3,'Color',[0.97 0.85 0.09],'linewidth',1.5);

x4=[xrield+0.25/2,xrield+0.25/2,xrield+0.25/2,xrield+0.25/2];
y4=[2, 11, 11, 2];
z4=[1.3, 1.3, 1.8, 1.8];
plot3 (x4,y4,z4,'Color',[0.97 0.85 0.09],'linewidth',1.5);

%Dibujo del carro
x5=[xrield-0.525, xrield+0.525, xrield+0.525, xrield+0.25/2,xrield+0.25/2,xrield-0.25/2, xrield-0.25/2, xrield-0.525, xrield-0.525];
y5=[ycard-0.4,ycard-0.4,ycard-0.4,ycard-0.4,ycard-0.4,ycard-0.4,ycard-0.4,ycard-0.4,ycard-0.4];
z5=[1.05, 1.05, 1.55, 1.55, 1.3, 1.3, 1.55, 1.55, 1.05];
plot3 (x5,y5,z5,'Color',[0 0.5 1],'linewidth',1.5);

x6=[xrield-0.525, xrield+0.525, xrield+0.525, xrield+0.25/2,xrield+0.25/2,xrield-0.25/2, xrield-0.25/2, xrield-0.525, xrield-0.525];
y6=[ycard+0.15,ycard+0.15,ycard+0.15,ycard+0.15,ycard+0.15,ycard+0.15,ycard+0.15,ycard+0.15,ycard+0.15];
z6=[1.05, 1.05, 1.55, 1.55, 1.3, 1.3, 1.55, 1.55, 1.05];
plot3 (x6,y6,z6,'Color',[0 0.5 1],'linewidth',1.5);

x7=[xrield-0.525, xrield-0.25/2,xrield-0.25/2,xrield-0.525,xrield-0.525];
y7=[ycard-0.4, ycard-0.4, ycard+0.15, ycard+0.15, ycard-0.4];
z7=[1.55, 1.55, 1.55, 1.55, 1.55];
plot3 (x7,y7,z7,'Color',[0 0.5 1],'linewidth',1.5);

x7b=[xrield+0.525, xrield+0.25/2,xrield+0.25/2,xrield+0.525,xrield+0.525];
y7b=[ycard-0.4, ycard-0.4, ycard+0.15, ycard+0.15, ycard-0.4];
z7b=[1.55, 1.55, 1.55, 1.55, 1.55];
plot3 (x7b,y7b,z7b,'Color',[0 0.5 1],'linewidth',1.5);

x8=[xrield-0.25/2,xrield+0.25/2,xrield+0.25/2,xrield-0.25/2,xrield-0.25/2];
y8=[ycard-0.4, ycard-0.4, ycard+0.15, ycard+0.15, ycard-0.4];
z8=[1.3, 1.3, 1.3, 1.3, 1.3];
plot3 (x8,y8,z8,'Color',[0 0.5 1],'linewidth',1.5);

x9=[xrield-0.525,xrield+0.525, xrield+0.525,xrield-0.525, xrield-0.525];
y9=[ycard-0.4, ycard-0.4, ycard+0.15, ycard+0.15, ycard-0.4];
z9=[1.05, 1.05,1.05,1.05,1.05];
plot3 (x9,y9,z9,'Color',[0 0.5 1],'linewidth',1.5);

%Dibujo del gancho
x10=[xg-0.1, xg-0.1, xg+0.1, xg+0.1, xg, xg];
y10=[yg,yg,yg,yg,yg,yg];
z10=[zg, zg-0.1, zg-0.1, zg+0.1, zg+0.1, zg+0.2];
plot3 (x10,y10,z10,'Color',[1 0 0],'linewidth',1.5);

x11=[xg-0.1,  xg+0.1];
y11=[yg,yg];
z11=[zg+0.2,zg+0.2];
plot3 (x11,y11,z11,'Color',[1 0 0],'linewidth',1.5);

%Dibujo del cable
x12=[xg-0.1, xrield-0.1];
y12=[yg,yg];
z12=[zg+0.2,1.05];
plot3 (x12,y12,z12,'Color',[0.5 0.5 0.5],'linewidth',1.5);

x13=[xg+0.1, xrield+0.1];
y13=[yg,yg];
z13=[zg+0.2,1.05];
plot3 (x13,y13,z13,'Color',[0.5 0.5 0.5],'linewidth',1.5);

%Dibujo de la carga

x14=[xg+rcarg, xg+rcarg*cosd(30), xg+rcarg*cosd(60), xg, xg+rcarg*cosd(120), xg+rcarg*cosd(150), xg-rcarg, xg+rcarg*cosd(210), xg+rcarg*cosd(240), xg, xg+rcarg*cosd(300), xg+rcarg*cosd(330),xg+rcarg];
y14=[yg, yg+rcarg*sind(30), yg+rcarg*sind(60), yg+rcarg, yg+rcarg*sind(120), yg+rcarg*sind(150), yg, yg+rcarg*sind(210), yg+rcarg*sind(240), yg-rcarg, yg+rcarg*sind(300), yg+rcarg*sind(330), yg];
z14= [zc+hcarg/2, zc+hcarg/2, zc+hcarg/2, zc+hcarg/2, zc+hcarg/2, zc+hcarg/2, zc+hcarg/2, zc+hcarg/2, zc+hcarg/2, zc+hcarg/2, zc+hcarg/2, zc+hcarg/2, zc+hcarg/2];
plot3 (x14,y14,z14,'Color',[0.5 0.25 0]);

z15= [zc-hcarg/2, zc-hcarg/2, zc-hcarg/2, zc-hcarg/2, zc-hcarg/2, zc-hcarg/2, zc-hcarg/2, zc-hcarg/2, zc-hcarg/2, zc-hcarg/2, zc-hcarg/2, zc-hcarg/2, zc-hcarg/2];
plot3 (x14,y14,z15,'Color',[0.5 0.25 0]);

plot3([xg+rcarg, xg+rcarg],[yg, yg],[zc-hcarg/2, zc+hcarg/2],'Color',[0.5 0.25 0]);
plot3([xg+rcarg*cosd(30), xg+rcarg*cosd(30)],[yg+rcarg*sind(30), yg+rcarg*sind(30)],[zc-hcarg/2, zc+hcarg/2],'Color',[0.5 0.25 0]);
plot3([xg+rcarg*cosd(60), xg+rcarg*cosd(60)],[yg+rcarg*sind(60), yg+rcarg*sind(60)],[zc-hcarg/2, zc+hcarg/2],'Color',[0.5 0.25 0]);
plot3([xg, xg],[yg+rcarg, yg+rcarg],[zc-hcarg/2, zc+hcarg/2],'Color',[0.5 0.25 0]);
plot3([xg+rcarg*cosd(120), xg+rcarg*cosd(120)],[yg+rcarg*sind(120), yg+rcarg*sind(120)],[zc-hcarg/2, zc+hcarg/2],'Color',[0.5 0.25 0]);
plot3([xg+rcarg*cosd(150), xg+rcarg*cosd(150)],[yg+rcarg*sind(150), yg+rcarg*sind(150)],[zc-hcarg/2, zc+hcarg/2],'Color',[0.5 0.25 0]);
plot3([xg-rcarg, xg-rcarg],[yg, yg],[zc-hcarg/2, zc+hcarg/2],'Color',[0.5 0.25 0]);
plot3([xg+rcarg*cosd(210), xg+rcarg*cosd(210)],[yg+rcarg*sind(210), yg+rcarg*sind(210)],[zc-hcarg/2, zc+hcarg/2],'Color',[0.5 0.25 0]);
plot3([xg+rcarg*cosd(240), xg+rcarg*cosd(240)],[yg+rcarg*sind(240), yg+rcarg*sind(240)],[zc-hcarg/2, zc+hcarg/2],'Color',[0.5 0.25 0]);
plot3([xg, xg],[yg-rcarg, yg-rcarg],[zc-hcarg/2, zc+hcarg/2],'Color',[0.5 0.25 0]);
plot3([xg+rcarg*cosd(300), xg+rcarg*cosd(300)],[yg+rcarg*sind(300), yg+rcarg*sind(300)],[zc-hcarg/2, zc+hcarg/2],'Color',[0.5 0.25 0]);
plot3([xg+rcarg*cosd(330), xg+rcarg*cosd(330)],[yg+rcarg*sind(330), yg+rcarg*sind(330)],[zc-hcarg/2, zc+hcarg/2],'Color',[0.5 0.25 0]);