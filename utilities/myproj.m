function q=myproj(p,lambda)
np=sqrt(sum(p.^2,3));
temp=max(np./lambda,1)+1e-10;
q=p./repmat(temp,[1 1 2]);
end