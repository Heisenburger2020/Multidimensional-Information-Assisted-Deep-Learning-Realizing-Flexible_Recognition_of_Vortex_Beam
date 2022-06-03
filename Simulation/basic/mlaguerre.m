function L = mlaguerre(n,p,x)
ret = 0;
for i=0:n
    sum1 = ret + (power(-1,i)* (factorial(n+p)/(factorial(n-i) * factorial(p+i) * factorial(i)))*power(x,i));
    ret=sum1;
end
L=ret;
end
