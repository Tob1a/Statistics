close all
clear
clc


z=0;
lambda=5

p=@(x)((lambda.^x .* exp(-lambda))./factorial(x));
for I=0:300
  z=z+p(I);
end
z
z=0;
for I=0:300
  z=z+p(I)*I;
end
z

