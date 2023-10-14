classdef sysBlock < handle
    properties
        sosSections = sosSec.empty;
        numSec;
    end
    
    methods 
        function obj = sysBlock(Am,Bm)
            obj.numSec = length(Am);
            for ii = 1:obj.numSec
                obj.sosSections(ii) = sosSec(Am(:,ii),Bm(:,ii));
            end
        end
        
        function out = calculateBlk(obj,x)
            out = 0;
            for ii = 1:obj.numSec
                out = out + obj.sosSections(ii).doFilt(x);
            end
        end
        
        function reset(obj)
            for ii = 1:obj.numSec
                obj.sosSections(ii).rst;
            end
        end
        
    end
end