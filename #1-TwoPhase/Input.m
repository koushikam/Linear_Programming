function [type,c,A,rel,b]=Input(type,c,A,rel,b) 
%This function is made to enter the input parameters which represents the
%standard linear program
%(LP): min c'x
%       subject to Ax=b, x>0
clc;
clear all;
clc;
disp('Enter the input parametrs')
disp('-------------------------')
type = input('Please enter type of the objective function:')
c = input('Enter the cost values,c:')
A = input('Enter the constraint matrix A:')
rel = input('Enter the type of the constraint equations,rel:')
b = input('Enter the right side of the constraint equation, b :')

disp('Input parameters are entered')
disp('----------------------------')