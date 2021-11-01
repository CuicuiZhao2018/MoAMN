% The code is for ROF mode in the article " G. Aubert and J.-F. Aujol,
% A variational approach to removing multiplicative noise, SIAM Journal 
%on Applied Mathematics, vol. 68, no. 4, pp. 925–946, Jul. 2008."
clc;clear all;close all;
fprintf("Running AA code. It will take a few seconds.\n");
%% ADD NOISE
addpath('../utilities')
Ima= im2double(imread('../images/cameraman.tif'));
alpha_true=0.4;
L_true=10;
sigma2_true=0.005;
[f,true_w]=NoisyImagf(Ima,alpha_true,L_true,sigma2_true);
%% DENOISE
tau=0.248;
lam=4.2;% large for smoother.
r=20*lam; % small for smoother.
L=L_true;
u=f;
d=f;
q=zeros([size(f),2]);
p=zeros(size(f));
iiter=2;
iter=100;
t1=clock;
for k=1:iter
    temp=u;
%update q
    for i=1:iiter
        q=myproj(q+tau*mygradient(mydiv(q)-(d-p)),lam/r);
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
    A(1,:)=r.*tempa(:);
    A(2,:)=-(r*u(:)+r*p(:));
    A(3,:)=L*tempa(:);
    A(4,:)=-L*f(:);
    d=CubEqSolver(A);
    d=reshape(d,size(u));
    %update pp
    p=p+(u-d);
    %update u
end
t2=clock;
disp(['runing time:',num2str(etime(t2,t1)),'s']);
figure(1),
subplot(221),imshow(Ima),title('Original');
subplot(222),imshow(f,[]),title('Noisy');
subplot(223),imshow(u,[]);title('AA'); drawnow;
subplot(224),imshow(f./(u+eps)),title('Noise');
final_psnr=Cal_psnr(u,Ima);
final_ssim=Cal_ssim(255*u,255*Ima);
fprintf("PSNR/SSIM=%.2f/%.4f\n",final_psnr,final_ssim);
figure(2),
subplot(211),plot(psnr),title('PSNR');
subplot(212),plot(ssim),title('SSIM');