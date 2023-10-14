classdef CMA < handle
    properties 
        n=0;
        t=0;
    end 
    
    methods 
        function obj=CMA()
        end
        
        function out = calculate(obj,x)
            out=(x+obj.n*obj.t)/(obj.n+1);
            obj.t=out;
            obj.n=obj.n+1;
        end
    end
end
            
            
            