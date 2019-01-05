classdef HardThreshold
    %HARDTHR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        s
    end
    
    methods
        function obj = HardThreshold(sparsity)
            obj.s = int32(sparsity);
        end
        
        function x = call(x)
            x = x[cL(obj.s, x)] = 0;
        end
        
        function aggregate = cL(s, x)
            ns = size(x);
            ns = ns(1) - s;
            aggregate = 
        end
        
    end
    
end

