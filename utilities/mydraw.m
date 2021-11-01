clc;clear all;
filePaths=[];
filePaths = cat(1,filePaths, dir(fullfile('./','*.png')))

for i=1:length(filePaths)
filename=filePaths(i).name;

Ima=imread(filename);

[m,n]=size(Ima);
m1=round(m/2);
n1=round(n/2);

px = 145;
py = 75;
step = 15;
x1 = px - step;
x2 = px + step;
y1 = py - step;
y2 = py + step;
Ima1=Ima(y1:y2,x1:x2);
Ima2=imresize(Ima1,[m1,n1],'nearest');
Ima3=cat(3,Ima2,Ima2,Ima2);

I=cat(3,Ima,Ima,Ima);




color=[255,0,0];

linewidth=3;
ind1=y1:y2;
ind2=x1-linewidth:x1-1;
I(ind1,ind2,:)=repmat(reshape(color,[1 1 3]),[length(ind1) length(ind2) 1]);

ind1=y1:y2;
ind2=x2+1:x2+linewidth;
I(ind1,ind2,:)=repmat(reshape(color,[1 1 3]),[length(ind1) length(ind2) 1]);

ind1=y2+1:y2+linewidth;
ind2=x1-linewidth:x2+linewidth;
I(ind1,ind2,:)=repmat(reshape(color,[1 1 3]),[length(ind1) length(ind2) 1]);

ind1=y1-linewidth:y1-1;
ind2=x1-linewidth:x2+linewidth;
I(ind1,ind2,:)=repmat(reshape(color,[1 1 3]),[length(ind1) length(ind2) 1]);

ind1=m-linewidth+1:m;
ind2=n-n1-2*linewidth+1:n;
I(ind1,ind2,:)=repmat(reshape(color,[1 1 3]),[length(ind1) length(ind2) 1]);

ind1=m-m1-2*linewidth+1:m-m1-linewidth;
ind2=n-n1-2*linewidth+1:n;
I(ind1,ind2,:)=repmat(reshape(color,[1 1 3]),[length(ind1) length(ind2) 1]);

ind1=m-m1-linewidth+1:m;
ind2=n-linewidth+1:n;
I(ind1,ind2,:)=repmat(reshape(color,[1 1 3]),[length(ind1) length(ind2) 1]);

ind1=m-m1-linewidth+1:m;
ind2=n-n1-2*linewidth+1:n-n1-linewidth;

I(ind1,ind2,:)=repmat(reshape(color,[1 1 3]),[length(ind1) length(ind2) 1]);

I(end-m1+1-linewidth:end-linewidth,end-n1+1-linewidth:end-linewidth,:,:)=Ima3;
imwrite(I,['local_' filename]);
figure(1),imshow(Ima1)
figure(2),imshow(I);
end
