function [indexnoisy,indexproc]=stoi(speech,d,e,Fs)

% Returns the speech intelligibililty index for both the noisy and  
% noise removed speech signals. The  function utilizes the Short-Term Objective Intelligibility Measure 
% described in Taal et.al. (2010)&(2011). 
% A higher index denotes better intelligible speech.

if (isrow(speech))
    speech=speech';
end

if (isrow(d))
    d=d';
end

if (isrow(e))
    e=e';
end

indexnoisy=taal2011(speech,speech+d,Fs);
indexproc=taal2011(speech,speech+e,Fs);

end

  
