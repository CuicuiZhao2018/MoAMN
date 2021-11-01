%% construct noisy image
function [f,w]=NoisyImagf(u,alpha,L,var)
[m,n]=size(u);
%% noise
d=round(alpha*numel(u));
randn('seed',0);
addgaussian=normrnd(0,sqrt(var),d,1);
d1=numel(u)-d;
randn('seed',0);
rand('seed',0);
mulgamma=gamrnd(L,1/L,[d1,1]);
%% random noise
ind=randperm(numel(u));
ind1=ind(1:d);
ind2=ind(d+1:end);
f=zeros(size(u));
w=zeros(size(u));
f=f(:);
w=w(:);
u=u(:);
f(ind1)=u(ind1)+addgaussian;
w(ind1)=ones(d,1);
f(ind2)=u(ind2).*mulgamma;
w=reshape(w,[m,n]);
f=reshape(f,[m,n]);
f(f>1)=1;
f(f<0)=0;

