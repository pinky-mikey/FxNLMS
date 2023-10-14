classdef FIR < handle
    properties
        inBuffer; % This is the input buffer
        W8s; % fir weights
    end
    
     methods
        function obj = FIR(wts)
            obj.inBuffer = zeros(length(wts),1);
            obj.W8s = wts;
        end

        function [y] = filterr(obj,n)
            obj.inBuffer = [obj.inBuffer(2:end);n];      
            y = obj.W8s' * obj.inBuffer;
        end
     end
end