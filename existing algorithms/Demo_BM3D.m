% The code is for ROF mode in the article "  K. Dabov, A. Foi, V. Katkovnik, and K. Egiazarian, 
%Image denoising by sparse 3-D transform-domain collaborative filtering, IEEE Trans. Image
%Process., vol. 16, no. 8, pp. 2080–2095, Aug. 2007."
clc;clear all;close all;
fprintf("Running BM3D code. It will take a few seconds.\n");
%% ADD NOISE
addpath('../utilities')
Ima= im2double(imread('../images/cameraman.tif'));
alpha_true=0.4;
L_true=10;
sigma2_true=0.005;
[f,true_w]=NoisyImagf(Ima,alpha_true,L_true,sigma2_true);
%% DENOISE
t1=clock;
tic;
modelsigma=34;% large for smoother.

u=BM3D(f,modelsigma);
toc;
t2=clock;
disp(['runing time:',num2str(etime(t2,t1)),'s']);

%%%%%%%%%%%
figure(1),
subplot(221),imshow(Ima),title('Original');
subplot(222),imshow(f,[]),title('Noisy');
subplot(223),imshow(u,[]);title('BM3D'); drawnow;
subplot(224),imshow(f-u,[]),title('Noise');
final_psnr=Cal_psnr(u,Ima);
final_ssim=Cal_ssim(255*u,255*Ima);
fprintf("PSNR/SSIM=%.2f/%.4f\n",final_psnr,final_ssim);
