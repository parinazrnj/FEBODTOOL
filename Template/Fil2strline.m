function STRdata = Fil2strline( file_jnl)
 fileID = fopen(file_jnl,'r');
 C = textscan (fileID, '%s', 'CollectOutput', 1, 'delimiter','', 'whitespace','');

fclose(fileID);
AA=C{1,1};

sizestr=size(AA,1)
STRdata='';
for i=1:sizestr
    STRdata=[STRdata , '%%',cell2mat(AA(i))];
end
STRdata  = strrep(STRdata,'%%    ','')
% STRdata  = strrep(STRdata,'%%',' ')

end

