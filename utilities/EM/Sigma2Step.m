function sigma2 = Sigma2Step(w,d)
temp=w.*d.^2;
sigma2=sum(temp(:))/(sum(w(:))+eps);




%w=w(:);
%u=u(:);
%f=f(:);
%var=sum(w.*(u-f).^2)./(sum(w)+1e-15);
%var(var<1e-15)=1e-15;
%var(var>1e2)=1e2;
