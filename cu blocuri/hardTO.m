classdef hardTO
    properties
        Sparsity
    end
    methods
        function obj = hardTO(sparsity)
           obj.Sparsity = sparsity;
        end
        
        function x = call(wvn)
            x(cL(wvn.Sparsity, x)) = 0;
        end
    end    
end
        