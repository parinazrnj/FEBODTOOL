%This function is used to write the constraint function for our program
function  Create_objfunc(Objective) % tt tf te  w
fileID = fopen('Objectivefcn.m','w');  
fprintf(fileID,'%s \n','function f = Objectivefcn(x)');

fprintf(fileID,'\n'); 
       for i=1: size(Objective,2)
           Command=cell2mat(Objective(i));
           fprintf(fileID,'%s \n',Command); 
       end
fprintf(fileID,'%s  \n','end');
fclose('all');
end