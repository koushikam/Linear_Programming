function [A,x,Z,p,subs]=revsimsolve(A,m,n,subs) 
% this function is to perfrom the pivot operations for
% solving the revised simplex method
    B=A(1:m,subs);
    invB=inv(B);
    Cb=A(m+1,subs);                 % basic variable cost
    x(subs)=inv(B)*A(1:m,n+m+1);    % basic varible vector
    p=Cb*inv(B);                     % dual vector
    Rd= A(m+1,1:n+m)- p*A(1:m,1:n+m) % reduced cost
    [j col]= Br(Rd);              % location and value of most negative number

while ~isempty(j) & j < 0 & abs(j) > eps                          % if there is any negative cost
 
Jin=Rd(col);
    % Compute the vector u (i.e., the reverse of the basic directions) 
    u = inv(B)*A(1:m,col);        % pivot column extraction
    I = find(u > 0);        
    if (isempty(I))
           f_opt = -inf;  % Optimal objective function cost = -inf
           x_opt = [];        % Produce empty vector []
           return         % Break from the function
    end
    [row, min] = MRT(A(:,n+m+1),u);  % find the minimum ratio
    x(subs)=x(subs)'-min*u; % pivot operation
    x(col)= min;          % add the new value of the basic varioable
    subs(row)=col          % update the location of the basic variable
    disp(sprintf(' pivot row-> %g pivot column->%g',row,col));
    disp(sprintf('initial B inverse and Xb tablue ----> '));
    A(1:m,n+1:end)
    A(row,:)= A(row,:)/A(row,col);% performing pivot operation for the row associated to pivot element . THis is to make pivot element value equal to one
    subs(row) = col;               % changing the column value in subs in which the column represent the pivot column which helps in  performing pivot opeartion to the whole [A I  = b]      
    for i = 1:m                      %  this is to build new canonical form after the pivot operation to the rest of the elements corresponding to the other rows
        if i ~= row
           A(i,:)= A(i,:)-A(i,col)*A(row,:); % making the rest of the elements in the pivot column equal to zero except pivot element
        end
    end
    invB=A(1:m,n+1:n+m) 
    Cb=A(m+1,subs);
    x(subs)= A(1:m,n+m+1);
    p=Cb*invB ;
    Rd= A(m+1,1:n+m)- Cb*A(1:m,1:n+m);   % reduced cost
    [j col]= Br(Rd);                % checking for the negative reduced cost 
end
x=x(1:n)';
Z=-Cb*A(1:m,n+m+1);

