function py_gen(keyword,y,outputfilename)
% global outputfilename

global library
global Entry
Rec=Entry;


num_key=size(keyword,2);

     Outputfilename = strcat(outputfilename,'.py');
      fileID = fopen(Outputfilename,'w');  
       for j=1:num_key
         keywordj=cell2mat(keyword(j));
         keywordname=keywordj(1:strfind(keywordj,'-')-1);
         matched_library=find(strcmp(keywordname, library(1,:)));
         matched_index=str2num(keywordj(strfind(keywordj,'-')+1:end));
       
         B=strfind(Rec,cell2mat(library(2,matched_library)));
         num1=length(cell2mat(library(3,matched_library))) ;
         firstloc=B(matched_index);
         newStr = Rec(firstloc:end);
         firloc=strfind(newStr,cell2mat(library(3,matched_library)));
         secloc=strfind(newStr,cell2mat(library(4,matched_library)));
          start=firloc(1)+num1-1+firstloc;
          amount= Rec(firloc(1)+num1-1+firstloc:secloc(1)-1+firstloc-1);
          rec1=Rec(1:firloc(1)+num1-2+firstloc);
          rec2=num2str(y(j));
          rec3=Rec(secloc(1)-1+firstloc:end);
          Rec=strcat(rec1,rec2,rec3);
          
          Rec(firloc(1)+num1-1+firstloc:end)  ;  

       end
       
       STRdata  = strsplit(Rec,'%%');
       for i=1:size(STRdata,2)
           B=cell2mat(STRdata(i));
           fprintf(fileID,'%s \n',B); 
       end
        fclose(fileID);
end

