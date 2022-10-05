function [A,P,Pc]=primaldualsolver(A,P,Pc,m,n)
% performs the operation of updating the tableu by performing the pivot
% operation for the primal-dual operaton
%Input:
% A: Initial Tableau
% P: Position of the basic variables
% Pc: Postion of the non-basic variables
%Output:
% X: final basic solution
% P: location of the final basic variables
% Z*: final optimal cost 
ncol=length(A)
tbn = 0;                            % intialize the number of tableu

while any(A(m+1,n+1:ncol-1)== 0) | any(A(m+1,1:n)< 0) 
    epsi=(A(m+2,1:n)./(-A(m+1,1:n )));
    [bmin, col] = Br(epsi) ;               % to find the min b of RHS in Ax>=b
    A(m+2,1:n) = A(m+2,1:n) + bmin*(A(m+1,1:n ));  %update ct - lamda*A= ct-lamda*A + epsi(r(d))
    row = MRT(A(1:m+1,ncol),A(1:m+1,col));            %to find the pivot elemet
    disp(sprintf(' pivot row-> %g pivot column-> %g and pivot element is---> %d',row,col,A(row,col)))
    P(row) = col;                   % the pivot element gets added to basic
    Pc= setdiff((1:ncol-1),P);         % 
      A(row,:)= A(row,:)/A(row,col);  % making pivot element equal to 1
    for i = 1:m+1                   %this is to build new canonical form after the pivot operation to the rest of the elements corresponding to the other rows
        if i ~= row                 
            A(i,:)= A(i,:)-A(i,col)*A(row,:);  % making the rest of the elements in the pivot column equal to zero except pivot element
        end
    end
    tbn = tbn + 1;               %update the number of tableu
    disp(sprintf('\n\n Tableau %g',tbn))
    A
    disp(sprintf(' Press any key to continue ...\n\n'))
    pause
end
