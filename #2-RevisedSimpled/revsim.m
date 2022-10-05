function revsim
%This alogorithm solves the linear programming revised simplex method
% as per the standard linear programming (LP)
% (LP):          min(or max) z = c'x
%                       Subject to Ax=b
%                           x >= 0
%  
%  solution along with finding the initial basic feasible solution using
%  phase-1.
%  
clc;
clear all;
[type,c,A,rel,b]=Input()
 
if (type == 'min')  % to check the type of the linear program
    mm = 0;             % variable mm=0 if the type of the problem is minimum   
else
    mm = 1;             % variable mm=0 if the type of the problem is maximum   
    c = -c;             % the cost function is multiplied with negative to convert it back to the type minimum form  
end
 
b = b(:);           % converting the b into column matrix b=transpose(b)
[m, n] = size(A);   % estimating the number of rows and columns of the matrix  
n1 = n;               
les = 0;             % variable to count the number of constraints of type <         
neq = 0;             % variable to count the number of constraints of type =
red = 0;             % variable to indicate redundant solution
 
if length(c) < n    % if length of c not equal to number of columns
    c = [c zeros(1,n-length(c))]; %   make the number of elements in the cost function equal to column of A  
end
 
 
for i=1:m            % m represents the number of constraint equations
    if(rel(i) == '<')    %  checking the constraint type like >= , = or <=
        A = [A vr(m,i)];     % if constraint type is < then add the slack variable  using function vr.  
        les = les + 1;       % Update the variable which has count of constraints of type <
    elseif(rel(i) == '>')
        A = [A -vr(m,i)];    % if constraint type is > then add the surplus variable using function vr,  
    else
        neq = neq + 1;       % counts the number of constraint equations of type '=' 
    end
end
 
ncol = length(A);    %updating the number of columns  


if les == m          % if the number of slack variables is equal to the total number of constraint equations
    c = [c zeros(1,ncol-length(c))];   %make the lenth of c equal to ncol of A after adding slack or surplus varibles
    A = [A;c];                    % adding cost equation c as the extra row to matrix A to form the canonical  
    A = [A [b;0]];                % adding b also to form complete canonical representation  
    subs = n+1:n+m;                % columns of the basic variables
    [A,x,Z,p,subs]=revsimsolve(A,m,n,subs); 
    disp(sprintf(' final tableu B inverse and xb is ----> '));
    A(1:m,n+1:end) 
    disp(sprintf(' final dual variables are labmda* ---->  '));
    lambda=p'
    disp(sprintf(' final Basic feasible solution is x* ---->  '));
    x
    disp(sprintf(' final Basic feasible solution is Z*---->  '));
    Z
end