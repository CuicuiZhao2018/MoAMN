# MoAMN
This code is for "A Dual Model for Restoring Images Corrupted by Mixture of Additive and Multiplicative Noise"

the authors: Cuicui Zhao, Jun Liu, Jie Zhang  

The proposed method's codes : MoAMNTV, MoAMNBM3D, MoAMNIRCNN.

The existing codes: ROF, AA, BM3D, IRCNN

The codes for MoAMNIRCNN and IRCNN need the MatConvNet package. The IRCNN denoiser used in the proposed model is the same as [3], and it is trained and plugin-and-play. So one can apply the code directly to image denoising, which does not need to train.

Reference:

[1] L. I. Rudin, S. Osher, and E. Fatemi, “Nonlinear total variation based noise removal algorithms,” Physica D: Nonlinear Phenomena, vol. 60, no. 1, pp. 259–268, 1992.

[2] K. Dabov, A. Foi, V. Katkovnik, and K. Egiazarian, “Image denoising by sparse 3-D transform-domain collaborative filtering,” IEEE Trans. Image Process., vol. 16, no. 8, pp. 2080–2095, Aug. 2007.

[3] K. Zhang, W. Zuo, S. Gu, and L. Zhang, “Learning deep CNN denoiser prior for image restoration",in 2017 IEEE Conference on Computer Vision and Pattern Recognition (CVPR), 2017, pp. 2808–2817.
