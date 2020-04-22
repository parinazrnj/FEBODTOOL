function [record_key,var_identifier]= Outputrequest_index (output_variables)
global  Element_lib Node_lib
record_key=[];
var_identifier={};
lib=[Element_lib, Node_lib];
num_outputvar=size(output_variables,2);
 for j=1:num_outputvar
         varname=cell2mat(output_variables(j));
         matched_library=find(strcmp(varname, lib(1,:)));
         matched_reckey=cell2mat(lib(2,matched_library));
         matched_identifier=cell2mat(lib(3,matched_library));
         record_key=[record_key, matched_reckey]
         var_identifier=[var_identifier,matched_identifier]
         

 end
end

