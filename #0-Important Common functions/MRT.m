function [row, mi] = MRT(b,a)
% The Minimum Ratio Test (MRT) performed on vectors a and b.
% Output parameters:
% row – index of the pivot row
% mi – value of the smallest ratio.
 m = length(b); % gives the length of the pivot element a 
c = 1:m;       % contains the total number of elements in the column of b
l = c(a > 0);  % takes the element position which has the positive value inorder to find the pivot element
[mi, row] = min(b(l)./a(l));  % finding the pivot element by the equation min { b / pivot column elements}
row = l(row);                 % gives the row containg the pivot element