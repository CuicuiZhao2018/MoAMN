% The code is for MoAMNIRCNN in the article "Adaptive variational Image Denoiser for a Mixture of 
% Additive and Multiplicative Noise based on TV,BM3D and IRCNN regularizations"
% the authors are Cuicui Zhao, Jun Liu, Jie Zhang  
% Corresponding author: Jun Liu (e-mail: jliu@bnu.edu.cn).
clc;clear all;close all;
fprintf("Running MoAMNIRCNN code. It will take a few seconds.\n");
%% ADD NOISE
vl_setupnn
addpath('../utilities')
Ima= im2double(imread('../images/cameraman.tif'));
alpha_true=0.4;
L_true=10;
sigma2_true=0.005;
[f,true_w]=NoisyImagf(Ima,alpha_true,L_true,sigma2_true);
%% DENOISE
modelsigma=22;% large for smoother
lam=5;
r=20*lam; 
sigma2=.1;
L=15; 
u=f;
d=f;
q=zeros([size(f),2]);
p=zeros(size(f));
if alpha_true~=1
iter=10;
else 
iter =2;
end
load('modelgray.mat');
net = loadmodel(modelsigma,CNNdenoiser);
net = vl_simplenn_tidy(net);
if alpha_true~=1
w=rand(size(f));
else
w=ones(size(f));
end
t1=clock;
%tic;
for k=1:iter
    temp=u;
    %update u
    cnnoutput=vl_simplenn(net,single(d-p),[],[],'conserveMemory',1,'mode','test');
    u=d-p-cnnoutput(end).x;
    u(u<0)=0;
    u(u>1)=1;
    psnr(k)=Cal_psnr(u,Ima);
    ssim(k)=Cal_ssim(255*u,255*Ima);
    error=sqrt(sum((temp(:)-u(:)).^2))/sqrt(sum((temp(:)+eps).^2));
    if error< 1e-3
        break;
    end
    fprintf('The %d-th iteration model error :%.4f\n',k,error);
    figure(1),
    imshow(u,[]);
    title(['Iteration=',num2str(k)]);
    drawnow;
    %update d
    tempa=ones(size(u));
    A(1,:)=r+w(:)./(sigma2+1e-15);
    A(2,:)=-(r*u(:)+r*p(:)+f(:).*w(:)./(sigma2+1e-15)); 
    A(3,:)=L.*(1-w(:));
    A(4,:)=-L.*(1-w(:)).*f(:);
    d=CubEqSolver(A);
    d=reshape(d,size(u));
    %update p
    p=p+u-d;
    %update parameters
    if alpha_true~=1
    if mod(k,6)==5 
        sigma2 = Sigma2Step(w,u-f);
        alpha = UpdateAlpha(w);
        d2=f./(u+eps);
        L = LStep(w,d2);
       if alpha_true~=1 
        w= WStep(alpha,sigma2,L,u-f,f./(u+eps));
       end
    end
    end    
end
% toc;
t2=clock;
disp(['runing time:',num2str(etime(t2,t1)),'s']);
alpha = UpdateAlpha(w);
sigma2 = Sigma2Step(w,u-f);
d2=f./(u+eps);
L = LStep(w,d2);
figure(1),subplot(221),imshow(Ima,[]), title('Clean');
subplot(222),imshow(f,[]), title('Noisy');
subplot(223),imshow(u,[]), title('Restored u');
subplot(224),imshow(d,[]), title('Restored d');
mse=mean((u(:)-Ima(:)).^2);
fprintf("The estimation of alpha: %.2f\n",alpha);
fprintf("The estimation of sigma2: %.2f\n",sigma2);
fprintf("The estimation of L: %.2f\n",L);
figure(2),
subplot(211),plot(psnr),title('PSNR');
subplot(212),plot(ssim),title('SSIM');
final_psnr=Cal_psnr(u,Ima);
final_ssim=Cal_ssim(255*u,255*Ima);
fprintf("PSNR/SSIM=%.2f/%.4f\n",final_psnr,final_ssim);
