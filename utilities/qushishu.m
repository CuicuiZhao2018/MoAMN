function y=qushishu(x)
temp=x(find(abs(imag(x))<1e-5));
temp1=real(temp);
temp1(temp1<0)=0;
temp1(temp1>1)=1;

if numel(temp1)==1
   temp1(temp1<0)=0;
   temp1(temp1>1)=1;
   y=temp1;
end

if numel(temp1)==3
    y=-100;
    for k=1:3
        if temp1(k)>0&&temp1(k)<1
           y=temp1(k);
        end
    end
    if y==-100
        y=temp1(1);
    end
end
end


 % temp=a(find((imag(a)==0)&(a>0)&(a<1)))