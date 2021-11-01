clc;
clear;
u=ones(256,256);
alpha_true=0.83;
sigma2_true=0.02;
L_true=10;

d=round(alpha_true*numel(u));
randn('seed',0);
n1=normrnd(0,sqrt(sigma2_true),d,1);
d1=numel(u)-d;
randn('seed',0);
rand('seed',0);
n2=gamrnd(L_true,1/L_true,[d1,1]);

n=[n1;n2];
tempw=[ones(size(n1));zeros(size(n2))];

%ind=randperm(numel(u));
ind=1:numel(u);
d=n(ind);
w_true=tempw(ind);

d=reshape(d,size(u));
d=reshape(d,[128,128,1,4]);
w_true=reshape(w_true,size(u));

alpha(:,:,:,:,1)=0.5;
sigma2(:,:,:,:,1)=0.1;
L(:,:,:,:,1)=10;

w=rand(size(d));


for iter=1:50
    sigma2 = Sigma2Step(w,d);
    [alpha] = UpdateAlpha(w);
    L = LStep(w,d);
    [w,lhf(iter)]= WStep(alpha,sigma2,L,d,d);
    fprintf('iter=%d,lh=%.4f,sigma2=%.4f,alpha=%.4f,L=%.4f\n',iter,lhf(iter),sigma2,alpha,L);
end


