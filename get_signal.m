function [s,noise] = get_signal( FD,TD,FC,Time )

fd=FD; % ������� �������������
td=TD;%������ ������������� 
fc=FC;% ������� ������� (������� ��������� ������� carr(t) ),
T=Time;%����� ������������� � ��������
Nms=T*1000; %���������� ����������� ������������� ( Nms = T*1000 ),
t=td:td:T; % �������� ���
N=1:length(t);
f_psp=fd/1023000;
sv=1;
 noise(1,:) = randn(1,length(t))+1i*randn(1,length(t));  % ����������������� ����������� ��� 1� ������
 noise(2,:) = randn(1,length(t))+1i*randn(1,length(t));  % ����������������� ����������� ��� 2� ������
 noise(3,:) = randn(1,length(t))+1i*randn(1,length(t));  % ����������������� ����������� ��� 3� ������
 noise(4,:) = randn(1,length(t))+1i*randn(1,length(t));  % ����������������� ����������� ��� 4� ������  
carr=sin(2*pi*fc*td*N);%�������
psp = get_cacode(sv,f_psp);%���

figure(1);
plot(carr); hold on;xlim([1 500]);ylim([-2 2]);
plot(psp);
m=1;
for k=1:length(t)
    psp2(k)=psp(m);
    m=m+1;
    if m>length(psp)
        m=1;
    end
end
psp=psp2;
s=(psp.*carr);
S=fft(s);
s = [s; s; s; s];
CARR=fft(carr);
PSP=fft(psp);
figure(2);
plot(abs(CARR)); 
hold on 
plot(abs(S),'r');
title('������ ������� ��� ������');
% figure(2);
% plot(s);xlim([1 500]);ylim([-2 2]);
% hold on; plot(noise,'r');

end

