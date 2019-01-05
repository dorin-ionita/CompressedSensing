classdef WT
    properties
        Shape
        Wavelet
        Level
        Amplify
        cMat_shapes
    end
    methods
        function wvl = WT(shape, amplify)
            wvl.Shape = shape;
            wvl.Wavelet = 'db6';
            wvl.Level = 5;
            
            if isnan(amplify)
                wvl.Amplify = ones(3 * wvl.Level + 1);
            else
                wvl.Amplify = amplify;
            end
            
            if isnumeric(amplify)
                wvl.Amplify = ones(3 * wvl.Level + 1);
                wvl.Amplify(0) = amplify;
            end
        end
        
        function cVec_list = call(wvn)
            [C, S] = wavedec2(I_Mat, wvn.Level, wvn.Wavelet);
            
            cMat_list = C(0);
            for i = 1:length(C)
                cMat_list = cMat_list + list(C(i));
            end
            
            wvn.cMat_shapes = vectorize(cMat_list);
            
            for j = 0:(3*wvn.Level + 1)
                current = cMat_list(j) * wvn.Amplify(j);
                cVec_list = [cVec_list current];
            end
            
            reshape(cVec_list, -1);
        end
        
        function waver = inv(wvn, wavelet_vector)
            if isempty(wvn.cMat_shapes)
                print("Call WT first to obtain shapes of coefficient matrices")
                return
            end
            
            cVec_shapes = prod(wvn.cMat_shapes);
            split_indices = list(cumsum(cVec_shapes));
            
            cVec_list = split(wavelet_vector, split_indices);
            
            
            for j = 0:(3*wvn.Level + 1)
                current = cMat_list(j) / wvn.Amplify(j);
                cVec_list = [cVec_list current];
            end            
            
            coeffs = reshape(cVec_list(0), wvn.cMat_shapes(0));
            
            for j = 0:wvn.Level
                triple = cVec_list(3*j + 1:3*(j+1)+1);
                for i = 0:3
                    triple = reshape(triple(i), wvn.cMat_shapes(1 + 3*j + i));
                end
                coeffs = coeffs + tuple(triple);
            end
            
            waver = waverec2(coeffs, self.Wavelet);
        end
     
    end
end
        