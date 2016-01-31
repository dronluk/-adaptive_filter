function  q  = correlator(usefulsignal, signal)
x=usefulsignal;
s=signal;
s=fft(s);
x=conj(fft(conj(x)));
q=s.*x;
q=ifft(q);
end

