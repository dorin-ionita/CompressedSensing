classdef WaveletTransform
    %WAVELET_TRANSFORM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    shape
    wavelet
    level
    cMat_shape
    amplify
    end
    
    methods
        function obj = WaveletTransform(shape, wavelet, level, amplify)
            
            obj.shape = shape;
            obj.wavelet = wavelet;
            obj.level = level;
            obj.amplify = amplify;
            
            if isequal(wavelet, 'None')
                obj.wavelet = 'db6'
            end
            
            if isequal(level, 'None')
                obj.level = 5
            end
            
            if isequal(amplify, 'None')
                obj.amplify = ones(1, 3 * obj.level + 1);
            else
                obj.amplify = amplify;
            end
            
            if isequal(size(amplify), [1 1])
                obj.amplify = ones(1, 3 * obj.level + 1);
                obj.amplify(0) = amplify
            end
        end
        
    end
    
end

