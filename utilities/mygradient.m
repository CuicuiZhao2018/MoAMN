function gu=mygradient(u)
gu=repmat(0,[size(u),2]);
gu(1:end-1,:,1)=u(2:end,:)-u(1:end-1,:);
gu(:,1:end-1,2)=u(:,2:end)-u(:,1:end-1);
end