function dualsimplex
% this function perform the dualsimplex method for a linear program
% the standard linear program of ---->  type  c'x
%                                       subject to Ax rel b
%                                        x>0
% where type represent the type of the cost function min or max
% where rel could be <,> or = sign in the cosntraint equation
% c is the cost column matrix
% x is the basic variable column matrix

clc;
[type,c,A,rel,b]=Input()   % function to input the initial parameters

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
        b =[b; -b(i)];  % add one -b(i) to b vector
        A= [A;-A(i,1:n)];  % update the A after adding a row correspond to the equality constraint
    end
end
A=[A eye(m+eq)];          % adding the identity marix for whole A
ncol = length(A);    %updating the number of columns after adding or without adding the identity matrix or slack or surplus variables
c = [c zeros(1,ncol-length(c))];   % again adding zero cost elemements to make the lenth of c equal to ncol of A after adding slack or surplus varibles
A = [A ;c];                    % adding cost equation c as the extra row to matrix A to form the canonical representation
A = [A [b;0]];                % adding b also to form complete canonical representation of the given linear program
subs = ncol+1:ncol+m;                 %  this indicates column number which has identity matrix posses as basic variables
disp(sprintf('\n\n Initial tableau'))
A
disp(sprintf(' Press any key to continue ...\n\n'))
pause
[bmin, row] = Br(b);                % to find the min b of RHS in Ax>=b
tbn = 0;                            % intialize the number of tableu


while ~isempty(bmin) & bmin < 0 & abs(bmin) > eps
    if A(row,1:m+eq+n) >= 0            % checking whether the row particular to negative b is not positve
        disp(sprintf('\n\n Empty feasible region\n'))
        varargout(1)={subs(:)};          % if the row is positive , gives te location of the basic variables
        varargout(2)={A};                % final A value
        varargout(3) = {zeros(n,1)};      % flush all the  basic variables to zeros  
        varargout(4) = {0};              % final cost value set as zero
        return
    end
    col = MRTD(A(m+1+eq,1:m+eq+n),A(row,1:m+eq+n));     %to find the pivot elemet
    disp(sprintf(' pivot row-> %g pivot column-> %g',row,col))
    subs(row) = col;               % the pivot element gets added to basic
      A(row,:)= A(row,:)/A(row,col);  % making pivot element equal to 1
    for i = 1:m+eq+1                   %this is to build new canonical form after the pivot operation to the rest of the elements corresponding to the other rows
        if i ~= row                 
            A(i,:)= A(i,:)-A(i,col)*A(row,:);  % making the rest of the elements in the pivot column equal to zero except pivot element
        end
    end
    tbn = tbn + 1;               %update the number of tableu
    disp(sprintf('\n\n Tableau %g',tbn))
    A
    disp(sprintf(' Press any key to continue ...\n\n'))
    pause
    [bmin, row] = Br(A(1:m+eq,m+eq+n+1));  % again checking for the negative value in b function i.e process of finding pivot column
end

x = zeros(m+n+eq,1);                   % flushing out the old values stored for the variable x
x(subs) = A(1:m+eq,m+eq+n+1);             %% Updating the final basic variable values
x = x(1:n);

if mm == 0                                 
    z = -A(m+eq+1,n+m+eq+1);                           % if the objective is minimum then obtain positive optimal cost value
else
    z = A(m+eq+1,n+m+eq+1);                            % if the objective is maximum then obtain negative optimal cost value
end

disp(sprintf('\n\n Problem has a finite optimal solution\n\n'))
disp(sprintf('\n Values of the legitimate variables:\n'))

for i=1:n
    disp(sprintf(' x(%d)= %f ',i,x(i)))    %print the basic variables
end

disp(sprintf('\n Objective value at the optimal point:\n'))
disp(sprintf(' z= %f',z))
