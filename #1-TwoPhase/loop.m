function [subs, A, z]= loop(A, subs, mm, k, ph)
% Main loop of the simplex primal algorithm.
tbn = 0;  % initialize the tableu number

if  ph == 1   %if the loop is executing phase-1
    disp(sprintf('\n\n Initial tableau'))
    A
    disp(sprintf(' Press any key to continue ...\n\n'))
    pause
end

if ph == 2    % if the loop is executing phase-2
    tbn = 1;
    disp(sprintf('\n\n Tableau %g',tbn))
    A
    disp(sprintf(' Press any key to continue ...\n\n'))
    pause
end

[m, n] = size(A);  % number of rows and columns
[mi, col] = Br(A(m,1:n-1));  %Function to find the most negative pivot column

while ~isempty(mi) & mi < 0 & abs(mi) > eps % if the most negative number in that column is negative and the absolute value should be greater than the epsilon which a small value
    t = A(1:m-k,col);                       % extracting the elements corresponding to the pivot column
    if all(t <= 0)                          %if the elements in the pivot column are negative or zero
        if mm == 0                          % if the objective type is minimum
            z = -inf;                       % set objective value equal to negative infinite
        else
            z = inf;                        % if the objective type is maximum then set objective value as  positive infinity
        end
        disp(sprintf('\n Unbounded optimal solution with z=%s\n',z)) % print the linear program is unbounded
        return
    end
    [row, small] = MRT(A(1:m-k,n),A(1:m-k,col));  % MRT finds the pivot element by considering the b and the pivot column, A(1:m-k,n) gives the column containg b and A(1:m-k,col) is the pivot column
    if ~isempty(row)                              % if there is a pivot element
        if abs(small) <= 100*eps & k == 1         % if the smalles value is less than the eps vales i.e  2.2204e-16. This loop is called to avoid the cycling and to avoid having unbounded solution
            [s,col] = Br(A(m,1:n-1));             % Function to find the most negative pivot column
        end
        disp(sprintf(' pivot row-> %g pivot column->%g',row,col))
        A(row,:)= A(row,:)/A(row,col); % performing pivot operation for the row associated to pivot element . THis is to make pivot element value equal to one
        subs(row) = col;               % changing the column value in subs in which the column represent the pivot column which helps in  performing pivot opeartion to the whole [A I  = b]      
        for i = 1:m                     %  this is to build new canonical form after the pivot operation to the rest of the elements corresponding to the other rows
            if i ~= row
               A(i,:)= A(i,:)-A(i,col)*A(row,:); % making the rest of the elements in the pivot column equal to zero except pivot element
            end
        end
        [mi, col] = Br(A(m,1:n-1));    % again checking for the negative value in cost function i.e process of finding pivot column
    end
    tbn = tbn + 1;                     % updating the tableu number
    disp(sprintf('\n\n Tableau %g',tbn))
    A
    disp(sprintf(' Press any key to continue ...\n\n'))
    pause
    
end
z = A(m,n);