function [r,p]=zp2rp(z,p,g);

%ZP2RP converts the pole-zero form to residue form.
%   [R,P]=ZPK2RPK(Z,P,G) converts the pole-zero from given by
%   the poles P, zeros Z, and series constant gain G to the partial
%   fraction form with poles P and residues R.
%   
%   The partial fraction expansion is computed in the pole-zero form, 
%   therefore it is numerically more robust than converting it first
%   to direct form and then to parallel form.
%
%   The function requires that the number of zeros is smaller than the
%   number of poles length(Z)<length(P). If this is not the case, try
%   factoring out some of the zeros and add it later in series.
%
%   For the details, see:
%
%   Balázs Bank, "Converting IIR filters to parallel form," IEEE Signal Processing
%   Magazine, Tips and tricks, 2018.
%
%   http://www.mit.bme.hu/~bank/parconv
%
%   C. Balazs Bank, 2017.

M=length(z);
N=length(p);

if M>=N,
    error('The number of zeros must be smaller than the number of poles.');
end;
    
r=zeros(size(p));
for l=1:N,
    r(l)=g*p(l).^(N-M-1);
    for i=1:M,
        r(l)=r(l)*(p(l)-z(i));
    end;
    for i=1:N,
        if l ~= i,
            r(l)=r(l)/(p(l)-p(i));
        end;
    end;
end;

