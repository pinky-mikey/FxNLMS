classdef sosSec < handle
    properties
        y = [0,0];
        y1 = 0;
        y2 = 0;
        x = 0;
        a = [];
        b = [];
    end
    methods
        function obj = sosSec(a,b)
            obj.a = a;
            obj.b = b;
        end
        
        function out = doFilt(obj,x)
            out = obj.b(1)*x + obj.b(2)*obj.x - obj.a(2)*obj.y2 - obj.a(3)*obj.y1;
            obj.y1 = obj.y2;
            obj.y2 = out;
            
            obj.x = x;
        end
        
        function updateCoefs(obj,b)
            obj.b = b;
        end
        
        function rst(obj)
            obj.y = [0,0];
            obj.y1 = 0;
            obj.y2 = 0;
            obj.x = 0;
        end
        
    end
end