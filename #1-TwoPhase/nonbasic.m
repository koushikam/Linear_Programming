function [row,col,Rd]=nonbasic(u,v,c,d)
% this program is to find the location of the most negative non-basic 
% element Rd
% INPUTS:
% u -----> dual variable of supply
% v -----> dual varible of demand
% c -----> cost matrix
% d -----> indicies of the basic variable
% OUTPUTS:
% row ---> row of the entering variable
% column ---> colummn of the entering varioable
[m,n]=size(d);
Rd=zeros(m,n);

for i=m:-1:1
    for j=n:-1:1
        if (d(i,j)~=1)
            Rd(i,j)=c(i,j)-(u(i)+v(j));
        end
    end
end
%x=min(Rd<0);
[row col]=find(Rd<0);
if ~isempty(col)
    row=row(1);
    col=col(1);
else
    row = [];
    col = [];
end
