clear all; clc;
j=sqrt(-1);
f=1e6;%������� ������
fd=100e6;%������� �������������
td=1/fd;%���
lenght=3e8/f; % ������ �����
t=td:td:0.01;%�����
N=1:length(t);%������
sv=1;%����� ��������
fs=100e6/1023000;
omeg=0;%������� �������
ca_code = get_cacode(sv,fs);
n=1;
%���������� �������������� ������
for k=1:length(t)
x(k) = ca_code(n)*exp(j*omeg*k);
n=n+1;
    if(n>length(ca_code))
     n=1;
    end
end
%--------------------------
noise(1,:) = randn(1,length(t))+1i*randn(1,length(t));  % ����������������� ����������� ��� 1� ������
noise(2,:) = randn(1,length(t))+1i*randn(1,length(t));  % ����������������� ����������� ��� 2� ������
noise(3,:) = randn(1,length(t))+1i*randn(1,length(t));  % ����������������� ����������� ��� 3� ������
noise(4,:) = randn(1,length(t))+1i*randn(1,length(t));  % ����������������� ����������� ��� 4� ������

A=2;%���������
ph = 1+1i*0.4; %��������� ����
lambda=3e8/f;%������ �����
az=40;%������
zen=160;%�����
PH=Phase_jam(az,zen,lambda);%���� ��������� �� ����

jam1=exp(1i*2*pi*f*td*N);           % ������ ��������������� ������

jam=PH*jam1;

figure(8);
subplot(2,1,1); hold on;  grid on;
plot(real(jam(1,:)),'r'); plot(real(jam(2,:)),'b');  plot(real(jam(3,:)),'g');  plot(real(jam(4,:)),'k'); hold off;
title('�������������� ����� ������');
subplot(2,1,2); hold on; grid on;
plot(imag(jam(1,:)),'r'); plot(imag(jam(2,:)),'b');  plot(imag(jam(3,:)),'g');  plot(imag(jam(4,:)),'k'); hold off; 
title('������ ����� ������');

 s1=A*jam(1,:)+noise(1,:)+x;  % �������� ������ �� ������ 1� �������
 s2=A*jam(2,:)+noise(2,:)+x;  % �������� ������ �� ������ 2� �������
 s2_2 = circshift(s2,1); % �������� ������ � ��������� �� ������ 2� �������
 s2_3 = circshift(s2,2); % �������� ������ � ��������� �� ������ 2� �������
 s3=A*jam(3,:)+noise(3,:)+x;  % �������� ������ �� ������ 3� �������
 s3_2 = circshift(s3,1); % �������� ������ � ��������� �� ������ 3� �������
 s3_3 = circshift(s3,2); % �������� ������ � ��������� �� ������ 3� �������
 s4=A*jam(4,:)+noise(4,:)+x;  % �������� ������ �� ������ 4� �������
 s4_2 = circshift(s4,1); % �������� ������ � ��������� �� ������ 4� �������
 s4_3 = circshift(s4,2); % �������� ������ � ��������� �� ������ 4� �������

q=correlator(x,s1);%����� ��������� ������� �� ����������
figure(6);
plot(abs(q));
title('���������� �� ����������');

% ����������� ������� � 4� ������ ��� �����
figure(1)
plot(real(s1)); hold on; xlim([1 500]);
plot(real(s2),'r');
plot(real(s3),'g'); 
plot(real(s4),'k'); 
title('������� � 4� ������');
hold off;

Inter1=s1(1:1000); % �������� ������� x1
Inter2=s2(1:1000); % �������� ������� x2
Inter2_2=s2_2(1:1000); % �������� ������� x2_2
Inter2_3=s2_3(1:1000); % �������� ������� x2_3
Inter3=s3(1:1000); % �������� ������� x3
Inter3_2=s3_2(1:1000); % �������� ������� x3_2
Inter3_3=s3_3(1:1000); % �������� ������� x3_3
Inter4=s4(1:1000); % �������� ������� x4
Inter4_2=s4_2(1:1000); % �������� ������� x4_2
Inter4_3=s4_3(1:1000); % �������� ������� x4_3

d=Inter1;  % ��������� ������ �������
d2=s1; % ��������� ������
Uinter = [Inter2;Inter2_2;Inter2_3;Inter3;Inter3_2;Inter3_3;Inter4;Inter4_2;Inter4_3]; % ������������ ������� �������
U = [s2;s2_2;s2_3;s3;s3_2;s3_3;s4;s4_2;s4_3];  %������������ ������� ������������ �������

W=[0;0;0;0;0;0;0;0;0];%����������
step = 1000; %���������� �������� �������
mu = 2/10000000;   % ��� ����������
coef=zeros(3,step);
%���������������-���������  ������ ������������ ������
for n=1:step
    Y = W'*Uinter; %������� � ������������ ������ ����������� � ����������
    e = d - Y; % �������� ������ 
    W_ = mu*Uinter*e'; % ������ �����������
    W = W + W_;
    for k=1:3%������ � ������ ����������� ��� 3� ������������ �����
    coef(k,n)=W(k*3,1);
    end
end;
 w=zeros(3,1);
 for k=1:3
 w(k,1)=W(k*3,1);
 end 
 Y2=W'*U;
 e2=d2-Y2;
q2=correlator(x,e2);%���������� ����� ����������
figure(7);
plot(abs(q2));
title('���������� ����� ����������');
 
Noise(1,:)=noise(1,1:1000);
Noise(2,:)=noise(2,1:1000);
Noise(3,:)=noise(3,1:1000);

S=w'*Noise;
Z=abs(Y-S).^2;
figure(5);
plot(Z);

std(e)%������� ���������� ����������
figure(4);hold on
plot(real(coef(1,:)),'r');plot(real(coef(2,:)),'g');plot(real(coef(3,:)),'k');%����������� ��� ������ �����������
title('�����������');
%����������� ���������� �������, � ������������
figure(2);
plot(real(d)); hold on;
plot(real(Y),'r');
title('��������� ������, � ������ � ������������ ������');
hold off;

Y=W'*U;%���������� ����������� ����������� � ������� ������� ������������ ������
%����������� ��������� �������
figure(3);
subplot(2,1,2);plot(real(e),'r');title('�������� ������');
subplot(2,1,1);plot(real(noise(1,:)));xlim([1 1000]);title('����������� �� �������������� ���');
