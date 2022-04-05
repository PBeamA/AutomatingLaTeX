%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GetBib.m
%
% Beam.Aschakulporn@otago.ac.nz
% https://pbeama.github.io/
% Modified: Wednesday 6 April 2022 (09:24)
% * Comments removed.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function GetBib(varargin)

if nargin == 1
filename = varargin{1};
else
filename = 'texFilename';
end

filename = regexprep(filename, '\..*', '');

fid = fopen([filename, '.bcf'], 'rt');

STRING = fread(fid, '*char')';

fclose(fid);

STRING = regexprep(STRING, '.*(<bcf:citekey order="1">)', '$1');
STRING = regexprep(STRING, '</bcf:section>.*', '');
STRING = regexprep(STRING, '[ ]*', '');
STRING = regexprep(STRING, '<[^<^>]*>', '');

KEYS = [];
while length(STRING) > 1
KEYS{end + 1, 1} = regexprep(STRING, '\n.*', '');
STRING = regexprep(STRING, regexprep(STRING, '\n.*', ''), '');
STRING(1) = [];
STRING = regexprep(STRING, '\s*', '\n');

end

KEYS = unique(KEYS);

if isempty(KEYS{1})
KEYS(1) = [];
end

CitedKeys = KEYS;
length(KEYS)

fid = fopen([filename, '.bib'], 'rt');

STRING = fread(fid, '*char')';

fclose(fid);

fid = fopen([filename, '_CLEAN.bib'], 'wt');

nCitedKeys = length(CitedKeys);
for i = 1 : nCitedKeys
bib = regexprep(STRING, sprintf('.*(@[\\w]+{%s,[^@]+).*', CitedKeys{i}), '$1');
bib = regexprep(bib, '\\', '\\\\');
bib = regexprep(bib, '%', '%%');
fprintf(fid, bib);

end
fclose(fid);
end

