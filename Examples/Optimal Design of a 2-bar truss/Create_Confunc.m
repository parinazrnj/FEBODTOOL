%This function is used to write the constraint function for our program
function  Create_Confunc(outputfilename,keyword,param_val,output_variables,Constraints) % tt tf te  w
fileID = fopen('Constraintfcn.m','w');  
fprintf(fileID,'%s \n','function [c,ceq] = Constraintfcn(x)');
fprintf(fileID,'%s \n','global  Xmat Cmat');
fprintf(fileID,'%s \n','global flagg flagg1 flagg2 flagg4 flagg5 ');
fprintf(fileID,'\n'); 
fprintf(fileID,'%s \n',outputfilename); 
fprintf(fileID,'%s \n',keyword); 
fprintf(fileID,'%s \n',param_val); 

% fprintf(fileID,'%s \n',output_variables); 
fprintf(fileID,'\n');     
fprintf(fileID,'%s  \n','py_gen(keyword,y,outputfilename);');% Construct the Abaqus script
fprintf(fileID,'\n'); 

% Run the input file Job-1.py with Abaqus
fprintf(fileID,'%s  \n','!abaqus cae noGUI=Job-1.py');
fprintf(fileID,'\n'); 

fprintf(fileID,'%s  \n','pause(20)');% Pause Matlab execution to give Abaqus enough time to create the .lck file
fprintf(fileID,'\n'); 

% If the .lck file exists then halt Matlab execution
fprintf(fileID,'%s  \n','while exist(''.lck'',''file'')==2');
fprintf(fileID,'%s  \n','    pause(0.1)');
fprintf(fileID,'%s  \n','    flagg1=flagg1+1');
fprintf(fileID,'%s  \n','end');
fprintf(fileID,'\n'); 

fprintf(fileID,'%s  \n','flagg2=flagg2+1');
fprintf(fileID,'\n'); 

% Delete the files of last Abaqus run to avoid Abaqus abort when it
% tries to rewrite them
% Calculate the maximum nodal stress
fprintf(fileID,'\n'); 
       for i=1: size(Constraints,2)
           Command=cell2mat(Constraints(i));
           fprintf(fileID,'%s \n',Command); 
       end
 fprintf(fileID,'\n'); 

fprintf(fileID,'%s  \n','delete(strcat(outputfilename,''.fil''));');
fprintf(fileID,'%s  \n','delete(strcat(outputfilename,''.prt''));');
fprintf(fileID,'%s  \n','delete(strcat(outputfilename,''.com''));');
fprintf(fileID,'%s  \n','delete(strcat(outputfilename,''.sim''));');
fprintf(fileID,'\n');  

fprintf(fileID,'%s  \n','flagg5=flagg5+1');

fprintf(fileID,'%s  \n',' Xmat=[x;Xmat];');
fprintf(fileID,'%s  \n',' Cmat=[c;Cmat];');

fprintf(fileID,'%s  \n','flagg=flagg+1 ');
fprintf(fileID,'%s  \n','end');
fclose('all');
end