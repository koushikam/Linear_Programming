function [y,bout]=cycle(x,row,col,b,c,Rd)
% [y,bout]=cycle(x,row,col)
% x: current solution (m*n)
% b: entering basic variables (m*n)
% row,col: index for element entering basis
% y: solution after cycle of change (m*n)
% bout: new basic variables after cycle of change (m*n)
y=x;
bout=b;
while (~isempty(row) & ~isempty(col))
    [m,n]=size(x);
    loop=[row col]; % describes the cycle of change
    disp('Element entering the basic')
    fprintf('R(%d,%d)= %d\n\n',loop(1,1),loop(1,2),Rd(loop(1,1),loop(1,2)))
    x(row,col)=Inf; % do not include (row,col) in the search
    b(row,col)=Inf;
    rowsearch=1; % start searching in the same row
    while (loop(1,1)~=row | loop(1,2)~=col | length(loop)==2),
        if rowsearch, % search in row
            j=1;
            while rowsearch
                if (b(loop(1,1),j)~=0) & (j~=loop(1,2))     % element is part of basic solution and not in the same column
                    loop=[loop(1,1) j ;loop]; % add indices of found element to loop
                    rowsearch=0; % start searching in columns
                elseif j==n, % no interesting element in this row
                    b(loop(1,1),loop(1,2))=0;
                    loop=loop(2:length(loop),:); % backtrack
                    rowsearch=0;
                else
                    j=j+1;                       % update the column
                end
            end
        else % column search  to find the elements which get affected by addition of new basic element
            i=1;
            while ~rowsearch
                if (b(i,loop(1,2))~=0) & (i~=loop(1,1)) % if the element is part of basic solution and not in the same row
                    loop=[i loop(1,2) ; loop];          % add the found element to loop to estimate theta
                    rowsearch=1;                        % start searching in rows
                elseif i==m
                    b(loop(1,1),loop(1,2))=0;
                    loop=loop(2:length(loop),:);        % backward
                    rowsearch=1;
                else
                    i=i+1;                              % update the row
                end
            end
        end
    end
    disp('Step-3')
    % compute maximal loop shipment
    l=length(loop);
    theta=Inf;
    minindex=Inf;
    for i=2:2:l
        if x(loop(i,1),loop(i,2))<theta,
            theta=x(loop(i,1),loop(i,2));   % calculating the minimum theta value
            minindex=i;
        end;
    end
    % compute new transport matrix
    y(row,col)=theta;
    disp('Update Tableu')
    for i=2:l-1
        y(loop(i,1),loop(i,2))=y(loop(i,1),loop(i,2))+(-1)^(i-1)*theta;
    end
    disp('x(updated) =')
    disp(y)
    bout(row,col)=1;
    bout(loop(minindex,1),loop(minindex,2))=0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %         COMPUTATION OF DUAL VARIABLE    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('Step-2(a)')
    [u,v]=dualvariable(y,bout,c);
    disp('dual of suplly u =')
    disp(u')
    disp('dual of demand v =')
    disp(v')

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   LOCATION OF BASIC ENTERING ELEMENT    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('Step-2(b)')
    [row,col,Rd]=nonbasic(u,v,c,bout);
    disp('Reduced cost, Rd =')
    disp(Rd)
end
