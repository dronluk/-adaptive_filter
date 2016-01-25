j=sqrt(-1);
fileID = fopen('wide_75dBm_#2_gn32.txt');%чтение из файла
data1 = textscan(fileID, '%10.1f   %10.1f   %10.1f   %10.1f', 1200000);
fclose(fileID);
data=cell2mat(data1);
%-------Фильтр Гильберта-----
d=0.01; w_L=0.1*pi; w_H=0.9*pi; N=27;
h=firpm(N-1,[w_L/pi w_H/pi],[1,1],'hilbert');
[H w] = freqz(h,1);
figure; stem(0:length(h)-1,h)
figure; plot(w/pi, abs(H));
%----------------------------
%-------Окно Хемминга--------
Wn=hamming(N);
for i=1:N
    Hw(1,i)=h(1,i).*Wn(i,1);
end
%---------------------------
for i=1:size(data,1)
x1(1,i)=data(i,1);
x2(1,i)=data(i,2);
x3(1,i)=data(i,3);
x4(1,i)=data(i,4);
end
Inter1=x1(1:100); % интервал выборки x1
Inter2=x2(1:100); % интервал выборки x2
Inter3=x3(1:100); % интервал выборки x3
Inter4=x4(1:100); % интервал выборки x4

y1=zeros(1,length(Inter1));
y2=zeros(1,length(Inter2));
y3=zeros(1,length(Inter3));
y4=zeros(1,length(Inter4));
%-------Свертка-----
for k=N:length(Inter1)
for m=0:N-1
    y1(1,k)=y1(1,k)+Hw(1,m+1)*Inter1(1,k-m);
    y2(1,k)=y2(1,k)+Hw(1,m+1)*Inter2(1,k-m);
    y3(1,k)=y3(1,k)+Hw(1,m+1)*Inter3(1,k-m);
    y4(1,k)=y4(1,k)+Hw(1,m+1)*Inter4(1,k-m);
end
end
%-------------------
%----Добавление мнимой части---
z1=Inter1+j*y1;
z2=Inter2+j*y2;
z3=Inter3+j*y3;
z4=Inter4+j*y4;
%------------------
d=z1;  % Эталонный сигнал выборки
Uinter = [z2; z3; z4]; % переферийные антены выборки
W = [ 1; 1; 1];
step = 100;%Кол.итераций
mu = 1/700000000;%Шаг сходимости
for n=1:step
    Y = W'*Uinter;
    e = d - Y;%Коэффицент ошибки
    W_ = mu*Uinter*e';
    W = W + W_;
end;
std(e);
figure;
plot(real(d)); hold on;%Синий-эталонный сигнал
plot(real(Y),'r');%Приближенный к эталонному
figure;
plot(real(e));