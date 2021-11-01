function d=CubEqSolver(A)
%A=randn(4,256*256);
[m n]=size(A);
a=mat2cell(double(A),4,ones(1,n));
a=a';
b=cellfun(@roots,a,'UniformOutput',false);
c=cellfun(@qushishu,b,'UniformOutput',false);
d=cell2mat(c);

% d=c';
% y=@(x) x(find(imag(x)==0));
% e=cellfun(y,b,'UniformOutput',false);