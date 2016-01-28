function  q  = correlator(x, s)
X=x;
S=s;
S=fft(S);
X=conj(fft(conj(X)));
q=S.*X;
q=ifft(q);
end

