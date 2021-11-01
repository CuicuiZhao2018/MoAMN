% The code is for ROF mode in the article " L. I. Rudin, S. Osher, and E. Fatemi, 
%Nonlinear total variation based noisevremoval algorithms, Physica D: Nonlinear Phenomena,
%vol. 60, no. 1, pp.259–268, 1992."
clc;clear all;close all;
fprintf("Running ROF code. It will take a few seconds.\n");
%% ADD NOISE
addpath('../utilities')
Ima= im2double(imread('../images/cameraman.tif'));
alpha_true=0.4;
L_true=10;
sigma2_true=0.005;
[f,true_w]=NoisyImagf(Ima,alpha_true,L_true,sigma2_true);
%% DENOISE
MN=numel(Ima);
lam=1.1;% large for smoother.
r=20*lam;
sigma2=.1;
tau=0.248;
u=f;
d=f;
L=L_true;
q=repmat(0,[size(f),2]);
p=zeros(size(f));
w=repmat(1,size(f));
iter=100;
iiter=2;
t1=clock;
%tic;
for k=1:iter
    temp=u;  
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
    tempa=ones(size(u));
    A(1,:)=r+w(:)./(sigma2+1e-15);
    A(2,:)=-(r*u(:)+r*p(:)+f(:).*w(:)./(sigma2+1e-15)); 
    A(3,:)=L.*(1-w(:));
    A(4,:)=-L.*(1-w(:)).*f(:);
    d=CubEqSolver(A);
    d=reshape(d,size(u));
    p=p+u-d;
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
end
%toc;
t2=clock;
disp(['runing time:',num2str(etime(t2,t1)),'s']);
figure(1),
subplot(221),imshow(Ima),title('Original');
subplot(222),imshow(f,[]),title('Noisy');
subplot(223),imshow(u,[]);title('ROF'); drawnow;
subplot(224),imshow(f-u,[]),title('Noise');
final_psnr=Cal_psnr(u,Ima);
final_ssim=Cal_ssim(255*u,255*Ima);
fprintf("PSNR/SSIM=%.2f/%.4f\n",final_psnr,final_ssim);
figure(2),
subplot(211),plot(psnr),title('PSNR');
subplot(212),plot(ssim),title('SSIM');
