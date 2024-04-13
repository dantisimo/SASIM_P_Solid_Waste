clear
% ID Channel: 2499755
%data = thingSpeakRead(2499755,'Fields',[1,2]);
%tabla = data;

% In case of wanting to use datasets,
tabla = readtable('intento1.csv');       %table with column of time, weigh and capacity
tablaX = readtable('DatosTiempo.xlsx');  %table with time in minutes

xd = tablaX.Datos';                       %as a function of time
y1T = tabla(:,"field1");                  %filed1 = weight in kg
yd1 = y1T.field1';                        %transposed of table of weight
y2T = tabla(:,"field2");                  %filed2 = capacity in %
yd2 = y2T.field2'*100;                    %transposed of table of capacity                

%Visualization
scatter(xd,yd1,'blue','x'), grid on, hold on,   %weight
title('Visualization of original data')
xlabel('time in minutes') 
ylabel('wieght in kg or capacity % ') 
scatter(xd,yd2,'red','o'), hold off             %capacity



%Process for prediction of weight and capacity 
x1 = xd; x2 = xd.^2; y = yd1;  

N = [length(x1) sum(x1) sum(x2) sum(y);
    sum(x1) sum(x1.^2) sum(x1.*x2) sum(x1.*y);
    sum(x2) sum(x1.*x2) sum(x2.^2) sum(x2.*y)];
NN = rref(N);
a0 = NN(1,end);
a1 = NN(2,end);
a2 = NN(3,end); 

%Ecuation of weight
syms xs
ys = a0 + a1*xs + a2*xs^2
fplot(ys,[min(xd) max(xd)]), grid on, hold on,
title('Funcition for prediction of weight')
xlabel('Time in minutes') 
ylabel('Weight in kg') 
scatter(xd,yd1), hold off

% Cuantificacion del error
St = sum((yd1-mean(yd1)).^2)
Sr = sum((yd1-double(subs(ys,xd))).^2)
r2 = (St-Sr)/St


% Process for capacity
x1 = xd; x2 = xd.^2; y = yd2;
N = [length(x1) sum(x1) sum(x2) sum(y);
    sum(x1) sum(x1.^2) sum(x1.*x2) sum(x1.*y);
    sum(x2) sum(x1.*x2) sum(x2.^2) sum(x2.*y)];
NN = rref(N);
a0 = NN(1,end);
a1 = NN(2,end);
a2 = NN(3,end); 

syms xs
ys = a0 + a1*xs + a2*xs^2
title('Funcition for prediction of capacity')
xlabel('Time in minutes') 
ylabel('capacity %') 
fplot(ys,[min(xd) max(xd)]), grid on, hold on,
scatter(xd,yd2), hold off

% Cuantificacion del error
St = sum((yd2-mean(yd2)).^2)
Sr = sum((yd2-double(subs(ys,xd))).^2)
r2 = (St-Sr)/St
