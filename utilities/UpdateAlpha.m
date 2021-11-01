function [alpha] = UpdateAlpha(w)
[m,n]=size(w);
alpha=sum(w(:))/(m*n);
alpha(alpha<0)=0;
alpha(alpha>1)=1;

