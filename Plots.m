function  Plots(signal,jam,d,Y,e2,noise,q2,W,U)

figure(3);
subplot(2,1,1); hold on;  grid on;
plot(real(jam(1,:)),'r'); plot(real(jam(2,:)),'b');  plot(real(jam(3,:)),'g');  plot(real(jam(4,:)),'k'); hold off;
title('�������������� ����� ������');
subplot(2,1,2); hold on; grid on;
plot(imag(jam(1,:)),'r'); plot(imag(jam(2,:)),'b');  plot(imag(jam(3,:)),'g');  plot(imag(jam(4,:)),'k'); hold off; 
title('������ ����� ������');

% ����������� ������� � 4� ������ ��� �����
figure(4)
plot(real(signal(1,:))); hold on; xlim([1 500]);
plot(real(signal(2,:)),'r');
plot(real(signal(3,:)),'g'); 
plot(real(signal(4,:)),'k'); 
title('������� � 4� ������');
hold off;

%����������� ���������� �������, � ������������
figure(5);
plot(real(d)); hold on;
plot(real(Y),'r');
title('��������� ������, � ������ � ������������ ������ ����� ����������');
hold off;


%����������� ��������� �������
figure(6);
subplot(2,1,2);plot(real(e2),'r');xlim([1 1000]);title('�������� ������');
subplot(2,1,1);plot(real(noise(1,:)));xlim([1 1000]);title('����������� �� �������������� ���');



figure(8);
plot(abs(q2));
title('���������� ����� ����������');

end

