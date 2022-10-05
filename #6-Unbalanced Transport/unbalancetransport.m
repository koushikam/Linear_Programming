function unbalancetransport
% input parameters
% a ---> supply  (m*1)
% b ---> demand  (n*1) 
% c ---> cost    (m*n)
% s ---> storage cost (m*1)
%
% output parameters
% x* ---> optimal solution (m*n) 
% c* ---> minimum transportation cost
clc;
clear all;
disp('Enter the input parametrs')
disp('-------------------------')
a = input('Enter the supply, a :')
b = input('Enter the demand, b :')
c = input('Enter the cost values, c:')
s = input('Enter the storage cost, s:')


disp('Input parameters are entered')
disp('----------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           NORTH WEST CORNER RULE        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[x,d,c]= NWCR(a,b,c,s);
disp('Initial basic solution ')
disp('x(initial) =')
disp(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         COMPUTATION OF DUAL VARIABLE    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Step-2(a)')
[u,v]=dualvariable(x,d,c);
disp('dual of suplly u =')
disp(u')
disp('dual of demand v =')
disp(v')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   LOCATION OF BASIC ENTERING ELEMENT    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Step-2(b)')
[row,col,Rd]=nonbasic(u,v,c,d);
disp('Reduced cost, Rd =')
disp(Rd)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           UPDATING THE TABLEU        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x,bout]=cycle(x,row,col,d,c,Rd);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           FINAL OUTPUT        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp(' the optimal solution is')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('x* =')
[m n]=size(x);
for i=1:m
    for j=1:n
        if(bout(i,j)~=0)
            disp(sprintf('x(%d%d)= %d ',i,j,x(i,j)))
        end
    end
end

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('Minimum transportation cost is')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
sprintf('Z*= %d\n',sum(sum(x.*c))) 
