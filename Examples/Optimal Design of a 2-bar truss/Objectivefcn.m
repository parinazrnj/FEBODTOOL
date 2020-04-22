function f = Objectivefcn(x) 

global Wmat Fmat Xmat 
u=9.144; 
weight = 9.81*2767.99*x*u*[1;sqrt(2)] 
f =  9.81*2767.99*x*u*[1;sqrt(2)] 
Fmat=[f; Fmat]; 
Wmat=[weight; Wmat]; 
Xmat=[x;Xmat]; 
end  
