function [x,d,c]= NWCR(a,b,c,s)
% performs the northwest corner rule algorithm
% x ----> shipments using n-w corner rule
% d ----> 1 for basic variable and 0 for non-basic
% a ----> supply
% b ----> demand
% c ----> cost matrix

% check for the balanced transportation problem
[m n]=size(c);
s=s(:);
if (sum(a)~=sum(b))
    disp('Error: unbalanced transportation problem')
    if(sum(a)>sum(b))
        disp('supply is greater than demand, SO add a dummy destination')
        fprintf('dummy destination added b(%d)= %d\n ', n+1,sum(a)-sum(b))
        b = [b sum(a)-sum(b)];
        c =[c s];
        disp('Balanced network is')
        disp(sum(b))
    else
        disp('supply is smaller than demand, SO add a dummy source')
        fprintf('dummy source added b(%d)= %d \n', m+1,sum(b)-sum(a))
        a = [a sum(b)-sum(a)];
        c = [c;s];
        disp('balanced network is')
        disp(sum(a))
    end           
else
    disp('Balanced transportation problem')
    disp(sum(a))
end
m=length(a);
n=length(b);
i=1;
j=1;
x=zeros(m,n);
d=zeros(m,n);
while ((i<=m) & (j<=n))
    if (a(i)< b(j))
        x(i,j)=a(i);
        d(i,j)=1;
        b(j)=b(j)-a(i);
        i=i+1;
    else
        x(i,j)=b(j);
        d(i,j)=1;
        a(i)=a(i)-b(j);
        j=j+1;
    end
end