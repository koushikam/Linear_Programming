function twophase 
%This alogorithm solves the linear programming using 2-phase method
% as per the standard linear programming (LP)
% (LP):          min(or max) z = c'x
%                       Subject to Ax=b
%                           x >= 0
%  Since the 2-phase method is used to find the optimal basic feasible
%  solution along with finding the initial basic feasible solution using
%  phase-1.
% Phase-2: used to find the final optimal solution

[type,c,A,rel,b]=Input();

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

if length(c) < n    % if number of elements in the cost function is not equal to the number of columns in the matrix A
    c = [c zeros(1,n-length(c))]; % add the zero elements to make the number of elements in the cost function equal to column of A i.e. n
end


for i=1:m            % m represents the number of constraint equations
    if(rel(i) == '<')    % for each constraint equation checking the constraint type like >= , = or <=
        A = [A vr(m,i)];     % if constraint type is < then add the positive identity matrix using the function vr  , this is similar to adding the slack variable
        les = les + 1;       % Update the variable which has count of contraints of type <
    elseif(rel(i) == '>')
        A = [A -vr(m,i)];    % if constraint type is > then add the negative identity matrix using the function vr , this is similar to adding the surplus variable
    else
        neq = neq + 1;       % counts the number of contraint equations of type '=' 
    end
end

ncol = length(A);    %updating the number of columns after adding or without adding the identity matrix or slack or surplus variables

if les == m          % if the number of slack variables is equal to the total number of constraint equations
    c = [c zeros(1,ncol-length(c))];   % again adding zero cost elemements to make the lenth of c equal to ncol of A after adding slack or surplus varibles
    A = [A;c];                    % adding cost equation c as the extra row to matrix A to form the canonical representation
    A = [A [b;0]];                % adding b also to form complete canonical representation of the given linear program
    [subs, A, z] = loop(A, n1+1:ncol, mm, 1, 1);  % function to solve the given linear program which is in the canonical form n using simplex procedure
    
    disp('           End of primal simplex ')                    
    disp(' *********************************')
    
else
    A = [A eye(m) b];      % if number  of < type constraints is not equal to total number of contraint equations add the identity matrix for those of constraint type '<'  
    w = -sum(A(1:m,1:ncol)); % building the artificial cost function for phase-1 by multiplying the sum of each column by negative 1 to make the cost value of the identity matix zero
    c = [c zeros(1,length(A)-length(c))]; %adding zero cost functions to added identity matrix
    A = [A;c];                            % appending to form canonical form in phase 1
    A = [A;[w zeros(1,m) -sum(b)]];       % appending the calculated artificial cost values w to form complete canonical retresentation of the given linear program
    subs = ncol+1:ncol+m;                 %  this indicates column number which has identity matrix possess as basic variables
    av = subs;                            % to compare in the future for the redundancy
    [subs, A, z] = loop(A, subs, mm, 2, 1);  % function to solve the given linear program which is in the canonical form n using simplex procedure
    
    disp('           End of Phase-1')
    disp(' *********************************')
    
    nc = ncol + m + 1;                    % total number of columns including [A I:b]
    x = zeros(nc-1,1);                    %  initalizing the values of x to zero to update them in the phase-2;  Ax=b
    x(subs) = A(1:m,nc);                 % transfering the x values from the output of phase-1  
    xa = x(av);                          % extracting the initial z value which is zero at the beginning of phase-2
    com = intersect(subs,av);            % to check whether the non-basic elemnts are removed eleminated after the pivot operation
    if (any(xa) ~= 0)                    % if the initial z value after phase-1 is not zero then
        disp(sprintf('\n\n infeasible solution exist \n'))  % declaring the problem as infeasble linear program
        return
    else
        if ~isempty(com)                 % to check whether the non-basic elements varibles are zero if not this results in redundancy          
            red = 1;                     % if com variable is not empty then it denotes the non-basic elements are not yet been removed so there is redundancy
        end
    end
    A = A(1:m+1,1:nc);                   % removing last row which represented as the artifical cost function in the phase-1
    A =[A(1:m+1,1:ncol) A(1:m+1,nc)];    % appending original A with the final b value of phase-1
    [subs, A, z] = loop(A, subs, mm, 1, 2);  % pivot operation in phase-2
    disp(' End of Phase-2')
    disp(' *********************************')
    
end

if (z == inf | z == -inf)                 % if the final cost is infinity then stop the process
    return
end

[m, n] = size(A);                         % final size of the tableu at the end of phase-2
x = zeros(n,1);                           % flushing out the old values stored for the variable x
x(subs) = A(1:m-1,n);                      % Updating the final basic variable values
x = x(1:n1);                               % obtaining the optimal x values for the actual number of variables
if mm == 0                                 
    z = -A(m,n);                           % if the objective is minimum then obtain positive optimal cost value
else
    z = A(m,n);                            % if the objective is maximum then obtain negative optimal cost value
end
disp(sprintf('\n\n Problem has a finite optimal solution\n'))
disp(sprintf('\n The values of the basic variables are:\n'))
for i=1:n1
    disp(sprintf(' x(%d)= %f ',i,x(i)))                  
end
disp(sprintf('\n Optimal Objective value:\n'))
disp(sprintf(' z= %f',z))

t = find(A(m,1:n-1) == 0);     % testing for the total number of solutions
if length(t) > m-1             % if the number of feasible variables is grater than the number of constraint equation
    str = 'Problem has infinitely many solutions'; 
    msgbox(str,'Warning Window','warn')
end

if red == 1                    % if the slack or surplus elements are not reduced at the end then declare problem is redundant
    disp(sprintf('\n Constraint system is redundant\n\n'))
end
        varargout(1)={subs(:)}; % if the row is positive , gives te location of the basic variables
        varargout(2)={A};                % final A value
        varargout(3) = {x};      % flush all the  basic variables x*
        varargout(4) = {z};              % final cost value z*