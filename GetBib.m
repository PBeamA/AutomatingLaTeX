%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Beam.Aschakulporn@otago.ac.nz
% https://pbeama.github.io/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function GetBib
close all
clear all
clc


filename = 'BKMAJDFull';


fid = fopen([filename, '.bcf'], 'rt');

STRING = fread(fid, '*char')';

fclose(fid);
% STRING


STRING = regexprep(STRING, '.*(<bcf:citekey order="1">)', '$1');
STRING = regexprep(STRING, '</bcf:section>.*', '');
STRING = regexprep(STRING, '[ ]*', '');
STRING = regexprep(STRING, '<[^<^>]*>', '');

% regexprep(STRING, '\n.*', '')

KEYS = [];
while length(STRING) > 1
    KEYS{end + 1, 1} = regexprep(STRING, '\n.*', '');
    STRING = regexprep(STRING, regexprep(STRING, '\n.*', ''), '');
    STRING(1) = [];
    STRING = regexprep(STRING, '\s*', '\n');
%     STRING = regexprep(STRING, '\r\n\r\n', '\r\n')




% STRING = regexprep(STRING, '\n(.*)', '$1');
% asdasd

%     pause
end


KEYS = unique(KEYS);


if length(KEYS{1}) == 0
    KEYS(1) = [];
   KEYS;
end

CitedKeys = KEYS;
length(KEYS)









fid = fopen([filename, '.bib'], 'rt');

STRING = fread(fid, '*char')';

fclose(fid);

fid = fopen([filename, '_CLEAN.bib'], 'wt');
BIBKEYS = regexprep(STRING, '@[\w]+{([^,]+),[^@]+', '$1\n');

nCitedKeys = length(CitedKeys);
% nCitedKeys = 1;
for i = 1 : nCitedKeys
    
    
bib = regexprep(STRING, sprintf('.*(@[\\w]+{%s,[^@]+).*', CitedKeys{i}), '$1');

bib = regexprep(bib, '\\', '\\\\');

bib = regexprep(bib, '%', '%%');
    fprintf(fid, bib);
    
%     bib
    
    
%     pause
end
fclose(fid);
end

































