import scipy.ndimage as spimg
from scipy.misc import imsave
import glob
import os
import pywt
import numpy as np
from abc import abstractmethod
import numbers
from itertools import accumulate
import numpy.linalg as la


class WT():
    '''wavelet transform... under construction'''

    def __init__(self, shape, wavelet='db6', level=5, amplify=None):
        self.shape = shape
        self.wavelet = wavelet
        self.level = level
        self.cMat_shapes = []
        # build amplification vector of length 3*level
        if amplify is None:
            self.amplify = np.ones(3 * self.level + 1)
        else:
            self.amplify = amplify
        if isinstance(amplify, numbers.Number):
            self.amplify = np.ones(3 * self.level + 1)
            self.amplify[0] = amplify

    def __call__(self, image):
        coeffs = pywt.wavedec2(image, wavelet=self.wavelet, level=self.level)
        # format: [cAn, (cHn, cVn, cDn), ...,(cH1, cV1, cD1)] , n=level

        # to list of np.arrays
        # multiply with self.amplify[0] to have them more strongly weighted in compressions
        # tbd: implement others
        cMat_list = [coeffs[0]]
        for c in coeffs[1:]:
            cMat_list = cMat_list + list(c)
        # memorize all shapes for inv
        self.cMat_shapes = list(map(np.shape, cMat_list))

        # array vectorization
        vect = lambda array: np.array(array).reshape(-1)

        # store coeffcient matrices as vectors in list
        # cVec_list = map(vect,cMat_list)

        # apply amplification
        cVec_list = [vect(cMat_list[j]) * self.amplify[j] for j in range(3 * self.level + 1)]

        return np.concatenate(cVec_list)

    def inv(self, wavelet_vector):
        '''Inverse WT
            cVec_list: vector containing all wavelet coefficients as vectrized in __call__'''

        # check if shapes of the coefficient matrices are known
        if self.cMat_shapes == []:
            print("Call WT first to obtain shapes of coefficient matrices")
            return None

        cVec_shapes = list(map(np.prod, self.cMat_shapes))

        split_indices = list(accumulate(cVec_shapes))

        cVec_list = np.split(wavelet_vector, split_indices)

        # reverse amplification
        cVec_list = [cVec_list[j] / self.amplify[j] for j in range(3 * self.level + 1)]

        # back to level format
        coeffs = [np.reshape(cVec_list[0], self.cMat_shapes[0])]
        for j in range(self.level):
            triple = cVec_list[3 * j + 1:3 * (j + 1) + 1]
            triple = [np.reshape(triple[i], self.cMat_shapes[1 + 3 * j + i])
                      for i in range(3)]
            coeffs = coeffs + [tuple(triple)]

        return pywt.waverec2(coeffs, wavelet=self.wavelet)


class hardTO(object):
    '''Hard thresholding operator:
            takes vector x, returns hard thresholded vector'''

    def __init__(self, sparsity):
        '''s: sparsity (integer number)'''
        self.s = int(sparsity)

    def __call__(self, x):
        x[cL(self.s, x)] = 0
        return x

def cL(s,x):
    '''returns n-s abs-smallest indices of vector x'''
    ns = len(x)-s
    return np.argpartition(abs(x),ns)[:ns]

def compress(T, TO, image):
    '''returns compressed image by appyling thresholding to coeffcients in dictionary T:
    T: transformation taking image to vector, subclass of AbstractOperator
    thresholding = (H,thresholding_parameter):
        H(v,thresholding_parameter) gives a vector for a vector v
    image: matrix of black-white values'''
    x = T(image)
    x = TO(x)
    Cimage = T.inv(x)
    # print error
    rel_error = la.norm(Cimage-image,'fro')/la.norm(image,'fro')
    print("Relative compression error: {}".format( rel_error ))
    return Cimage

pic_file = "./pics/copii_frumosi.jpg"

Xorig = spimg.imread(pic_file, flatten=True, mode='L')

x = pywt.wavedec2(Xorig, wavelet='db1', level=1)
# Genereaza o serie ortonormata pentru imaginea data, folosind transformarea wavelet
# Cum un wavelet defineste baza ortonormata a unui spatiu Hilbert, obtin fix baza de care am nevoie
# https://en.wikipedia.org/wiki/Wavelet_transform
Xorig = pywt.waverec2(x, wavelet='db1')
# Inverse wavelet transform

shape = Xorig.shape
n = np.prod(shape)

L = 3
amp = np.linspace(1,.5,L)
amp = np.kron(amp, np.ones(3) )
amp = np.insert(amp,0, 10 ) #prepend (position 0)

# Alegere parametrii wavelet
T = WT(shape, wavelet='db6',level=L, amplify=amp)

# Alege cu norma l1 (the magic of l1)
s = int( np.prod(shape)/20 )
TO = hardTO(s)

# compression test
cXorig = compress(T,TO,Xorig)

imsave("./pics/original.jpg", Xorig)
imsave("./pics/original_reconstruit.jpg", cXorig)
