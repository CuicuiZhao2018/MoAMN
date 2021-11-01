function L = LStep(w,d2)
d2(d2>2)=3;
d2(d2<0.33)=0.33;
temp1=(d2-log(d2+eps)-1).*(1-w);
temp2=1-w;
M=sum(temp1(:))/(sum(temp2(:))+eps);
L=(3-M+sqrt((M-3)^2+24*M))/(12*M+eps);
L=real(L);





