picture_path = './pics/copii_frumosi.jpg';
compression_factor = 20;

picture = imread(picture_path);
picture = rgb2gray(picture); % Convert to grayscale
% TODO: missing L parameter from Python
% imshow(picture);

%%%%%%%%%%%%%%%%%%%%%%

decomp_level = 1;
wavelet_type = 'db1';

x = wavedec2(picture, decomp_level, wavelet_type);

% size(x)Initial code - working, Python

original_shape = size(picture);

no_pixels = original_shape(1) * original_shape(2);

L = 3;
amp = linspace(1, .5, L);
amp = kron(amp, ones(1, 3)); %Kronecker tensor product
amp = [10, amp];

wavelet_trans = WaveletTransform(original_shape, 'db6', L, amp);

s = no_pixels / compression_factor;
s = int32(s);

threshold_operator = HardThreshold(s)



