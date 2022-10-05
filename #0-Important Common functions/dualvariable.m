function [u,v,i,j]=dualvariable(x,d,c)
%[u v] ----> dual variable corresponding to supply and demand
% x ----> the current solution from N_W corner rule
% d ----> indices correspond to basic varibles
% c ----> initial cost matrix
% u ----> correspond to supply
% v ----> correspond to demand

[m n]=size(x);
if(sum(sum(d))~= m+n-1)
    disp('Error in N-W corner output')
    return
else
    u=Inf*ones(m,1); % assigning an arbitrary values for the u and v
    v=Inf*ones(n,1);  % for the future 
    v(n)=0;          % assuming first element of u=0 possessses redundancy
    k=1;
    while k<m+n        % checking the condition with number of basic variables
        for i= m:-1:1
            for j=n:-1:1
                if(d(i,j)>0)
                    if(u(i)~=Inf & v(j)==Inf)
                        v(j)=c(i,j)-u(i);
                        k=k+1;
                    elseif(u(i)==Inf & v(j)~= Inf)
                        u(i)=c(i,j)-v(j);
                        k=k+1;
                    end
                end
            end
        end
    end    
end
