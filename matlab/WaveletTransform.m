classdef WaveletTransform
    %WAVELET_TRANSFORM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    shape
    wavelet
    level
    cMat_shape
    amplify
    Cs
    Ss
    end
    
    methods
        function obj = WaveletTransform(shape, wavelet, level, amplify)
            
            obj.shape = shape;
            obj.wavelet = wavelet;
            obj.level = level;
            obj.amplify = amplify;
            
            if isequal(wavelet, 'None')
                obj.wavelet = 'db6';
            end
            
            if isequal(level, 'None')
                obj.level = 5;
            end
            
            if isequal(amplify, 'None')
                obj.amplify = ones(1, 3 * obj.level + 1);
            else
                obj.amplify = amplify;
            end
            
            if isequal(size(amplify), [1 1])
                obj.amplify = ones(1, 3 * obj.level + 1);
                obj.amplify(0) = amplify;
            end
        end
        
        function [cVec_list, S, new_shapes] = call(obj, image)
            [C, S] = wavedec2(image, obj.level, obj.wavelet);
            
            obj.Cs = C;
            obj.Ss = S;
            
            obj.cMat_shape = S(:, 1) .* S(:, 2);
            
            new_shapes = zeros(1, 1 + 3 * (length(obj.cMat_shape) - 1));
            new_shapes(1) = obj.cMat_shape(1);
            current_j = 2;
            for i = 2 : 3 : length(new_shapes)
                new_shapes(i) =  obj.cMat_shape(current_j);
                new_shapes(i + 1) = obj.cMat_shape(current_j);
                new_shapes(i + 2) = obj.cMat_shape(current_j);
                current_j = current_j + 1;
            end
           
            initial_idx = 1;
            for i = 1:length(obj.amplify)
                for j = initial_idx:initial_idx + new_shapes(i)
                    C(j) = C(j) * obj.amplify(i);
                end
            end
            
            cVec_list = C;
        end
       
        function recovered_image = inverse(obj, x, S, new_shapes)
%             new_shapes = zeros(1, 1 + 3 * (length(obj.cMat_shape) - 1));
%             new_shapes(1) = obj.cMat_shape(1);
%             current_j = 2;
%             for i = 2 : 3 : length(new_shapes)
%                 new_shapes(i) = obj.cMat_shape(current_j);
%                 new_shapes(i + 1) = obj.cMat_shape(current_j);
%                 new_shapes(i + 2) = obj.cMat_shape(current_j);
%                 current_j = current_j + 1;
%             end
            
            initial_idx = 1;
            for i = 1:length(obj.amplify)
                for j = initial_idx:initial_idx + new_shapes(i)
                    x(j) = x(j) / obj.amplify(i);
                end
            end
            
            recovered_image = waverec2(x, S, obj.wavelet);
        end
        
    end
    
end

