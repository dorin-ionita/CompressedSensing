[phi, psi, xval] = wavefun('db6', 5);
subplot(211);
plot(xval, phi);
title('db6 scaling function');
subplot(212);
plot(xval, psi);
title('db4 Wavelet');