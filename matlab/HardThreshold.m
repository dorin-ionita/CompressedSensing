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
            length_x = size(x);
            length_x = length_x(1);
            how_many_to_eliminate = length_x - obj.s;
            [~, indexes_x] = sort(abs(x), 'ascend');
            indexes_x = indexes_x(1:how_many_to_eliminate);
            x(indexes_x) = 0;
        end
    end
    
end

