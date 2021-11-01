% Update weight
function [w,lhf]= WStep(alpha,sigma2,L,d1,d2)
p1=alpha*normpdf(d1,0,sqrt(sigma2)+eps);
p2=(1-alpha)*gampdf(d2,L,1/(L+eps));
w=p1./(p1+p2+eps);
lhf=sum(-log(p1(:)+p2(:)+eps));
