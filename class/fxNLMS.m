classdef fxNLMS < handle
    properties
        mu; %adaptation step
        filterLength; %adaptive fir filter length
        regularizationFactor = eps(); % small positive constant to prevent division by zero condition 
        adaptWe; % adaptive fir filter weights
        debarWe; % DE approximation fir filter weights
        inBuffer; % input buffer
        adaptBuffer; % buffer for adaptation process
        debarBuffer; % DE approximation buffer
        ider; %identification error
        rn;   %random noise sample     
    end
    
    
    methods
        function obj = fxNLMS(mu,FilterLength)
            obj.mu = mu;
            obj.filterLength = FilterLength;
            obj.inBuffer = zeros(FilterLength,1);
            obj.adaptBuffer = zeros(FilterLength,1);
            obj.debarBuffer = zeros(1024,1);
            obj.adaptWe = zeros(FilterLength,1);
            obj.debarWe = zeros(1024,1);   
            obj.ider=[0,0];
        end

  
        function updateW(obj,e,xbar) %update the coefficients of the adaptive fir filter W.
            obj.adaptBuffer = [obj.adaptBuffer(2:end); xbar];
            nu =  obj.mu / (obj.regularizationFactor + obj.adaptBuffer' * obj.adaptBuffer);
            obj.adaptWe = obj.adaptWe + nu * obj.adaptBuffer * e;
        end

      
        function [c] = generatenoise(obj) %generate random noise sample for DE identification.
             c = -0.2 + (0.4).*rand();
             obj.rn=c;
        end
            
        function updateDEbar(obj,e) %update the coefficients of the DE path estimation filter DEbar.
            obj.debarBuffer = [obj.debarBuffer(2:end);obj.rn];
            cbar = obj.debarWe' * obj.debarBuffer;
            obj.ider = [obj.ider(2:end);e-cbar];
            moo =  1.2 / (obj.regularizationFactor + obj.debarBuffer' * obj.debarBuffer); 
            obj.debarWe = obj.debarWe + moo * obj.debarBuffer * obj.ider(2);
        end 
        
        function [y] = Wfilt(obj,x) %filtering of one sample with the adaptive fir filter W.
            obj.inBuffer = [obj.inBuffer(2:end);x];
            y = obj.adaptWe' * obj.inBuffer;
        end
        
        function [exb] = debarfilt(obj,n) %filtering one sample with the DEbar fir filter.
            obj.debarBuffer = [obj.debarBuffer(2:end);n];
            exb = obj.debarWe'* obj.debarBuffer;
        end
         
        function W = getWeights(obj,char)%output current filter coefficients for either W or DEbar.
            if strcmp(char,'W')
                W = flip(obj.adaptWe);
            else
                W = flip(obj.debarWe);
            end
        end
            
    end
end