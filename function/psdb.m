function [XPDB,F]=psdb(x,Fs)
%Logarithmic power spectrum plot.
% [DBX,F]=PDBPLOT(X,FV,FS);
% Power spectrum plot (dB) of the input signal x.
% The power spectrum is calculated through the FFT of input signal x
% power data is smoothed using 128 sample averaging.
% If the output arguments are not asked for, then it plots
% semilogx(F,XPDB); 

if (isrow(x))
    x=x';
end

NFFT=length(x);
f = Fs*(0:(NFFT/2-1))/NFFT;
F=logspace(0,log10(Fs/2),NFFT/2);


X = fftshift(fft(x,NFFT));
X1 = abs(X/NFFT);
X2=2*X1(NFFT/2+1:end);
X3 = pow2db(X2.^2);
X4 = movmean(X3,128);
XPDB= interp1(f,X4,F,'method','extrap');
if (nargout==0)
    semilogx(F,XPDB','LineWidth',1.5);
    xlim([20 22050]);
    title('Power spectrum.');
    xlabel('Frequency (Hz)','FontWeight','bold','Color','k');
    ylabel('Power (dB)','FontWeight','bold','Color','k'); 
    grid on;
end
end