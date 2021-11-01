function dp=mydiv(p)
p1x=repmat(0,[size(p,1), size(p,2)]);
p2y=p1x;
p1x(2:end-1,:)=p(2:end-1,:,1)-p(1:end-2,:,1);
p1x(1,:)=p(1,:,1);
p1x(end,:)=-p(end-1,:,1);

p2y(:,2:end-1)=p(:,2:end-1,2)-p(:,1:end-2,2);
p2y(:,1)=p(:,1,2);
p2y(:,end)=-p(:,end-1,2);
dp=p1x+p2y;
end