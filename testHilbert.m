f=10;
t=0:0.01:2;
j=sqrt(-1);
x=cos(2*pi*t*f);
s=sin(2*pi*t*f);
figure; plot(t,x);
d=0.01; w_L=0.1*pi; w_H=0.9*pi; N=27;
h=firpm(N-1,[w_L/pi w_H/pi],[1,1],'hilbert');
[H w] = freqz(h,1);
figure; plot(abs(H));
y=zeros(1,length(x));
for k=N:length(x)
for m=0:N-1
    y(1,k-13)=y(1,k-13)+h(1,m+1)*x(1,k-m);
end
end
y_Im=imag(y);
y_Re=real(y);
figure; plot(t,y_Re,'r'); hold on; plot(t,x); plot(t,s,'m');
z=x+j*y;
z=z(13:end);