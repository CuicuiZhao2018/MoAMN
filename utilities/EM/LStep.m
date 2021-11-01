function L = LStep(w,d)
d(d>10)=10;
d(d<0.1)=0.1;
temp1=(d-log(d+eps)-1).*(1-w);
temp2=1-w;
M=sum(temp1(:))/(sum(temp2(:))+eps);
L=(3-M+sqrt((M-3)^2+24*M))/(12*M+eps);
L=real(L);





