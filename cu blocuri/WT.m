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
                wvl.Amplify(1) = amplify;
            end
        end
        
        function cVec_list = call(wvn)
            [C, S] = wavedec2(I_Mat, wvn.Level, wvn.Wavelet);
            
            cVec_list = [];
            temp = [];
            cMat_list = [];
            
            for i = 1:S(1,1)*S(1,2)
                temp = [temp C(i)];
            end
            
            cMat_list{1} = temp;
            temp = [];
            
            offset = i;
            
            for x = 2:wvn.Level+1
                for i=1:S(x,1)*S(x,2)*3
                    temp = [temp C(offset+i)];
                end
                    cMat_list{x} = temp;
                    offset = offset + i;
                    temp = [];
            end

            for i = 1:size(cMat_list,2)
               wvn.cMat_shapes = [cMat_shapes size(cMat_list{i},2)]
            end
            
            for i = 1:size(cMat_list{1},2)
                current = cMat_list{1}(i) * wvn.Amplify(1);
                cVec_list = [cVec_list current];
            end
            
            offset = i;
            joffset = 1;
            
            for i = 2:size(cMat_shapes, 2)
                chunk = cMat_shapes(i)/3;
                for j = 1:3
                   for  m = chunk*(j-1)+1:chunk*j
                       current = cMat_list{i}(m) * wvn.Amplify(joffset+j);
                       cVec_list = [cVec_list current];
                   end
                end
                joffset = joffset + 3;
            end
            
%             reshape(cVec_list, -1);
        end
        
        function waver = inv(wvn, wavelet_vector)
            if isempty(wvn.cMat_shapes)
                disp("Call WT first to obtain shapes of coefficient matrices")
                return
            end

            cVec_shapes = wvn.cMat_shapes;
            split_indices = cumsum(cVec_shapes);

            ind = 1;
            j = 1;
            current = [];

            for i=1:size(wavelet_vector, 2)
                current = [current wavelet_vector(i)];
                
                if ind > size(split_indices)
                    cVec_list{j} = current;
                else
                    if wavelet_vector(i) == split_indices(ind)
                        cVec_list{j} = current;
                        ind = ind + 1;
                        j = j + 1;
                        current = [];
                    end
                end
            end

%             cVec_list = split(wavelet_vector, split_indices);
            
            final_cVec_list = []

            for j = 1:(3*wvn.Level + 1)
                current = cVec_list{j} / wvn.Amplify(j);
                final_cVec_list = [final_cVec_list current];
            end

%             coeffs = reshape(cVec_list(1), wvn.cMat_shapes(1));

            waver = waverec2(cVec_list, self.Wavelet);
            
            
        end
     
    end
end
        