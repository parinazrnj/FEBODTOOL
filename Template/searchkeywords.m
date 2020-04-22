% This function returns the possible parameters in an input model (.jnl) 
% which could be modified during optimization. 
% It is helpful to use this function before defining the modifiable variables of the model. 

function keywords = searchkeywords(file_jnl)
library={'Parameter',        'Truss Section Area', 'Elasticity',           'Density',         'Extrusion Depth',    'Cut Extrusion Depth' , 'Fillet';...
   'Parameter(expression=''','TrussSection(area=' ,'Elastic(table=((', 'Density(table=((', 'SolidExtrude(depth=','CutExtrude(depth='      , 'Round';...
   'Parameter(expression=''','TrussSection(area=' ,'Elastic(table=((', 'Density(table=((', 'SolidExtrude(depth=','CutExtrude(depth='      ,   'radius='  ;...          
   ''', name',                ', material'          ,', ',              ', )'   ,                ', ',            ', '                    ,        ')%%'};

keywords={};

Rec = Fil2strline(file_jnl);

if isempty(strfind(Rec,'Parameter(expression='''))==0 
     B=strfind(Rec,'Parameter(expression=''');
     m=length(strfind(Rec,'Parameter(expression='''));
     num1=length('Parameter(expression=''');
     for i=1:m

         firstloc=B(i);
         newStr = Rec(firstloc+num1:end);
         secloc=strfind(newStr,''', name');
         amount= newStr(1:secloc(1)-1);
         
         
         if isempty(str2num(amount))==0
         thirdloc=strfind(newStr,', path');
         
         aa=newStr(secloc(1)+9:thirdloc-2);
         newword=strcat('Parameter-',num2str(i),': ',aa)
         newword=strcat('Parameter-',num2str(i));
         keywords=[keywords;newword];
         end
     end   
end

for j=2:size(library,2)

if isempty(strfind(Rec,cell2mat(library(2,j))))==0 
     m=length(strfind(Rec,cell2mat(library(2,j))));
     for i=1:m
         newword=strcat(library(1,j),'-',num2str(i));
         keywords=[keywords;newword];
     end   
end
end

end
% 
