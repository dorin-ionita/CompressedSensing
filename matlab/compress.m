function [ compressed_image ] = compress(wavelet_operator, threshold_operator, orig_pic)
%COMPRESS Summary of this function goes here
%   Detailed explanation goes here
%     size(orig_pic)
    [x, new_shapes, S] = wavelet_operator.call(orig_pic);
%     compressed_image = x;
    x = threshold_operator.call(x);
    compressed_image = wavelet_operator.inverse(x, new_shapes, S);
%     
%     disp(size(compressed_image))
%     
%     disp(compressed_image(1:50, 1:50))
%     disp(orig_pic(1:50, 1:50))
%     
%     disp(size(orig_pic))
    disp(class(orig_pic))
    compressed_image = uint8(compressed_image);
    
    relative_error = norm(double(compressed_image) - double(orig_pic), 'fro') / norm(double(orig_pic), 'fro');
    disp("Relative Error:");
    disp(relative_error);
end

