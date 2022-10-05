function [m, j] = Br(d)
% this function finds the first negative number in the tableu to perform
% pivot operation since it is not mandatory to choose the most negative
% number
% Output parameters:
% m - first negative number in the array d
% j - index of the entry m.
%ind = find(d < 0);
x=min(d);
ind=find(d==x);
if ~isempty(ind)
    j = ind(1);
    m = d(j);
else
    m = [];
    j = [];
end