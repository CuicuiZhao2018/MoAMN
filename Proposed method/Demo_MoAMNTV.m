% The code is for MoAMNIRCNN in the article "Adaptive variational Image Denoiser for a Mixture of 
% Additive and Multiplicative Noise based on TV,BM3D and IRCNN regularizations"
% the authors are Cuicui Zhao, Jun Liu, Jie Zhang  
% Corresponding author: Jun Liu (e-mail: jliu@bnu.edu.cn).
clc;clear all;close all;
fprintf("Running MoAMNTV code. It will take a few seconds.\n");
%% ADD NOISE
addpath('../utilities')
Ima=imread('../images/cameraman.tif');
Ima=im2double(Ima(:,:,1));
%Ima=mat2gray(Ima(:,:,1));

alpha_true=0.4;
L_true=10;
sigma2_true=0.005;
[f,true_w]=NoisyImagf(Ima,alpha_true,L_true,sigma2_true);
%f=imnoise(Ima,'gaussian',0,0.01);

%% DENOISE

lam=6.1;% large for smoother.

%%%%%%%%%%%
tau=0.248;
r=5*lam; 
sigma2=0.01;
L=15;
u=f;
d=f;

q=zeros([size(f),2]);
p=zeros(size(f));
iiter=2;
iter=12;
w=rand(size(f));
t1=clock;
%tic;
for k=1:iter
    temp=u;
    %update u
    for i=1:iiter
        tempq=q;
        q=myproj(q+tau*mygradient(mydiv(q)-(d-p)),lam/r);
        if sqrt(sum((tempq(:)-q(:)).^2))/sqrt(sum((tempq(:)+eps).^2))< 1e-3
            break;
        end
    end
    u=d-p-mydiv(q);
    u(u>1)=1;
    u(u<0)=0;
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
    if mod(k,6)==5    
        sigma2 = Sigma2Step(w,u-f);
        alpha = UpdateAlpha(w);
        d2=f./(u+eps);
        L = LStep(w,d2);
        [w,lhf(k)]= WStep(alpha,sigma2,L,u-f,f./(u+eps));
    end
    if k>=7
        lam=7;
        r=6*lam;
    end
       
end
%toc;
t2=clock;
disp(['runing time:',num2str(etime(t2,t1)),'s']);
sigma2 = Sigma2Step(w,u-f);
alpha = UpdateAlpha(w);
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