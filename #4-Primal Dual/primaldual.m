function primaldual
% this function perform the primaldual  method for a linear program
% the standard linear program of ---->  type  c'x
%                                       subject to Ax rel b
%                                        x>0
% where type represent the type of the cost function min or max
% where rel could be <,> or = sign in the cosntraint equation
% c is the cost column matrix
% x is the basic variable column matrix

clc;
clear all;
 [type,c,A,rel,b,ld]=InputPrimar();   % function to input the initial parameters

if (type == 'min')  % to check the type of the linear program
    mm = 0;             % variable mm=0 if the type of the problem is minimum   
else
    mm = 1;             % variable mm=0 if the type of the problem is maximum   
    c = -c;             % the cost function is multiplied with negative to convert it back to the type minimum form  
end

b = b(:);           % converting the b into column matrix b=transpose(b)
[m, n] = size(A);   % estimating the number of rows and columns of the matrix A which helps in building the simplex algorithm
n1 = n;               
les = 0;             % variable to count the number of constraints of type <         
neq = 0;             % variable to count the number of constraints of type =
red = 0;             % variable to indicate redundant solution
eq = 0;
if length(c) < n    % if number of elements in the cost function is not equal to the number of columns in the matrix A
    c = [c zeros(1,n-length(c))]; % add the zero elements to make the number of elements in the cost function equal to column of A i.e. n
end


for i=1:m            % m represents the number of constraint equations
    if(rel(i) == '<')    % for each constraint equation checking the constraint type like >= , = or <=
        les = les + 1;       % Update the variable which has count of contraints of type <
    elseif(rel(i) == '>')
        A(i,1:n)= -A(i,1:n);
        b(i)= -b(i);          % changing the sign of the RHS of Ax>=b
        neq=neq+1;  % counts the number of contraint equations of type '=' 
    else
        eq=eq+1;        % number of equality constraints
        
    end
end

A=[A eye(m)];          % adding the identity marix for whole A
ncol = length(A);    %updating the number of columns after adding or without adding the identity matrix or slack or surplus variables
c = [c zeros(1,ncol-length(c))];   % again adding zero cost elemements to make the lenth of c equal to ncol of A after adding slack or surplus varibles
cld= c-ld*A;                 % calculate ct - Lambda*A
A = [A b];                % adding b also to form complete canonical representation of the given linear program
ncol=length(A)
cin=[zeros(1,n) ones(1,m) zeros(1,1)];
w = -sum(A(1:m,1:ncol))+ cin;  % (r)ARP
cld = [cld zeros(1,ncol-length(cld))];
A=[A;w;cld]; % initial tableu
P = n+1:n+m;                  %  this indicates column number which has identity matrix posses as basic variables
Pc= setdiff((1:ncol-1),P);     % column number which has non basic elements
disp(sprintf('\n\n Initial tableau'))
A
disp(sprintf(' Press any key to continue ...\n\n'))
pause

tbn = 0;                            % intialize the number of tableu

[A,P,Pc]=primaldualsolver(A,P,Pc,m,n);   % calling function to solve and update the tableau

x = zeros(m+n,1);                   % flushing out the old values stored for the variable x
x(P) = A(1:m,m+n+1);             %% Updating the final basic variable values
x = x(1:n);   
c=c(1:n);
if mm == 0                                 
    z = (c*x);                           % if the objective is minimum then obtain positive optimal cost value
else
    z = -(c*x);                           % if the objective is maximum then obtain negative optimal cost value
end

disp(sprintf('\n\n Problem has a finite optimal solution\n\n'))
disp(sprintf('\n Values of the legitimate variables:\n'))

for i=1:n
    disp(sprintf(' x(%d)= %f ',i,x(i)))    %print the basic variables
end

disp(sprintf('\n Objective value at the optimal point:\n'))
disp(sprintf(' z= %f',z))
