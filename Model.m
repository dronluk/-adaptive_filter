clear all; clc; close all;
j=sqrt(-1);
fd=80e6; % частота дискретизации
td=1/fd; %период дискретизации 
fc=10e6; % частота несущей (частота синусойды сигнала carr(t) ),
T=0.001; %время моделирования в секундах
f=1e6;%частота помехи
lenght=3e8/f; % длинна волны помехи
t=td:td:T;%Время
N=1:length(t);%длинна сигнала
sv=1;%Номер спутника
fs=100e6/1023000;
lambda=3e8/f;%длинна волны
az=160;%Азимут
zen=40;%Зенит
A=2;%Амплитуда помехи
step = 1000; %Количество итераций фильтра
mu = 2/10000000;   % шаг сходимости
k=6;%количество виртуальных антен
[s,noise]=get_signal(fd,td,fc,T);%сигнал ((с/а код* несущая),шум)

jam=Phase_jam(f,td,T,A,az,zen,lambda);%помеха

signal=s+jam+noise;
signal(5,:)=circshift(signal(2,:)',1);
signal(6,:)=circshift(signal(2,:)',2);
signal(7,:)=circshift(signal(3,:)',1);
signal(8,:)=circshift(signal(3,:)',2);
signal(9,:)=circshift(signal(4,:)',1);
signal(10,:)=circshift(signal(4,:)',2);

Inter=signal(:,1:1000);%Интервал выборки

d=Inter(1,:);  % Эталонный сигнал выборки
d2=signal(1,:); % Эталонный сигнал
Uinter = Inter(2:10,:); % Периферийные антенны выборки
U = signal(2:10,:);  %Периферийные антенны полноценного сигнала
W=[1;1;1;1;1;1;1;1;1];%коэффицент
[e,W,Y]=LMS_metod(d,Uinter,mu,step);%LMS метод
%[e,W,Y]=SMI_metod(d,Uinter);%SMI метод
 Y=W'*Uinter; 
 Y2=W'*U;
 e2=d2-Y2; 
s = circshift(s',10000)';
q2=correlator(s(1,:),e2);%корреляция после фильтрации

 
Plots(signal,jam,d,Y,e2,noise,q2,W,U);
