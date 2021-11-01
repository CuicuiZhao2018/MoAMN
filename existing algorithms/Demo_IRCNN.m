% The code is for ROF mode in the article " K. Zhang, W. Zuo, S. Gu, and L. Zhang, Learning deep CNN denoiser
%prior for image restoration,in 2017 IEEE Conference on Computer Vision
%and Pattern Recognition (CVPR), 2017, pp. 2808–2817
clc;clear all;close all;
fprintf("Running IRCNN code. It will take a few seconds.\n");
%% ADD NOISE
addpath('../utilities')
Ima= im2double(imread('../images/cameraman.tif'));
alpha_true=0.4;
L_true=10;
sigma2_true=0.005;
[f,true_w]=NoisyImagf(Ima,alpha_true,L_true,sigma2_true);
%% DENOISE
vl_setupnn
t1=clock;
modelsigma=38;% large for smoother. 46 (0); 42 (0.2);38 (0.4); 32 (0.6) 26(0.8)
load('modelgray.mat');
net = loadmodel(modelsigma,CNNdenoiser);
net = vl_simplenn_tidy(net);
cnnoutput=vl_simplenn(net,single(f),[],[],'conserveMemory',1,'mode','test');
u=f-cnnoutput(end).x;
t2=clock;
disp(['runing time:',num2str(etime(t2,t1)),'s']);
%%%%%%%%%%%
figure(1),
subplot(221),imshow(Ima),title('Original');
subplot(222),imshow(f,[]),title('Noisy');
subplot(223),imshow(u,[]);title('IRCNN'); drawnow;
subplot(224),imshow(f-u,[]),title('Noise');
mse=mean((u(:)-Ima(:)).^2);
final_psnr=Cal_psnr(u,Ima);
final_ssim=Cal_ssim(255*u,255*Ima);
fprintf("PSNR/SSIM=%.2f/%.4f\n",final_psnr,final_ssim);
