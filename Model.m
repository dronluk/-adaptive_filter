clear all; clc; close all;
j=sqrt(-1);
fd=80e6; % ������� �������������
td=1/fd; %������ ������������� 
fc=10e6; % ������� ������� (������� ��������� ������� carr(t) ),
T=0.001; %����� ������������� � ��������
f=1e6;%������� ������
lenght=3e8/f; % ������ ����� ������
t=td:td:T;%�����
N=1:length(t);%������ �������
sv=1;%����� ��������
fs=100e6/1023000;
lambda=3e8/f;%������ �����
az=160;%������
zen=40;%�����
A=2;%��������� ������
step = 1000; %���������� �������� �������
mu = 2/10000000;   % ��� ����������
k=6;%���������� ����������� �����
[s,noise]=get_signal(fd,td,fc,T);%������ ((�/� ���* �������),���)

jam=Phase_jam(f,td,T,A,az,zen,lambda);%������

signal=s+jam+noise;
signal(5,:)=circshift(signal(2,:)',1);
signal(6,:)=circshift(signal(2,:)',2);
signal(7,:)=circshift(signal(3,:)',1);
signal(8,:)=circshift(signal(3,:)',2);
signal(9,:)=circshift(signal(4,:)',1);
signal(10,:)=circshift(signal(4,:)',2);

Inter=signal(:,1:1000);%�������� �������

d=Inter(1,:);  % ��������� ������ �������
d2=signal(1,:); % ��������� ������
Uinter = Inter(2:10,:); % ������������ ������� �������
U = signal(2:10,:);  %������������ ������� ������������ �������
W=[1;1;1;1;1;1;1;1;1];%����������
[e,W,Y]=LMS_metod(d,Uinter,mu,step);%LMS �����
%[e,W,Y]=SMI_metod(d,Uinter);%SMI �����
 Y=W'*Uinter; 
 Y2=W'*U;
 e2=d2-Y2; 
s = circshift(s',10000)';
q2=correlator(s(1,:),e2);%���������� ����� ����������

 
Plots(signal,jam,d,Y,e2,noise,q2,W,U);
