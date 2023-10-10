%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RemoveEquations.m
%
% Pakorn.Aschakulporn@otago.ac.nz
% https://pbeama.github.io/
% Modified: Wednesday 11 October 2023 (10:52)
% * Comments removed.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RemoveEquations(varargin)

if nargin == 1
filename = varargin{1};
else
tic

D = dir;
D([D.isdir]) = [];
D(~contains({D.name}, '.tex')) = [];

D(contains({D.name}, 'References')) = [];
D(contains({D.name}, '_Mathless')) = [];

nD = length(D);
if nD > 1
for i = 1 : nD
filename = D(i).name;
RemoveEquations(filename);
end
return
else
filename = D.name;
end
end

if ~contains(filename, '.tex')
filename = [filename, '.tex'];
end

if isfile(regexprep(filename, '\.tex', '\.bib')) 
copyfile(regexprep(filename, '\.tex', '\.bib'), regexprep(filename, '\.tex', '_Mathless\.bib'))
end

fid = fopen(filename, 'rt');

STRING = fread(fid, '*char')';

fclose(fid);

STRING = regexprep(STRING, '\r', '');
STRING = regexprep(STRING, '(\n+[\s]*%[^\n]*)+', '');

STRING = regexprep(STRING, '(\\begin\{tabular\}).*?(\\end\{tabular\})', '$1{c}\nTABLE\n$2');

STRING = regexprep(STRING, '(\\begin\{(align|equation)\*\}|\\[).*?(\.|\,)?\n(\\end\{(align|equation)\*\}|\\])', '\\[\nEQUATION$2\n\\]');

STRING = regexprep(STRING, '\\begin\{equation\}(\\label\{eq\:[^\}]+\})*.*?(\,|\.)?\n\\end\{equation\}', '\\begin\{equation\}$1\nEQUATION$2\n\\end\{equation\}');

STRING = regexprep(STRING, '\\begin\{split\}(\\label\{eq\:[^\}]+\}|\\nonumber)*.*?((\,|\.)?)( *\\\\)?\n\\end\{split\}(.*?)(\\\\)?\n', '\&EQUATION$2 $1 $4\\\\\n');

[startIndex, endIndex] = regexp(STRING, '(?<=\\begin\{align\}\n).*?(?=\n\\end\{align\})');
nIndex = length(startIndex);
for ithIndex = nIndex : -1 : 1
stro = STRING([startIndex(ithIndex) : endIndex(ithIndex)]);

if ~strcmp(stro(end - 1 : end), '\\')
stro = [stro, ' \\'];
end

str = regexprep(stro, '[^\n]*\&.*?(\.|\,)? *([ ]*\\label\{eq\:[^\}]+\}|[ ]*\\nonumber|[ ]*\\tag\{\\ref\{eq\:[^\}]+\}\})*( \\\\\n*)', '\&EQUATION$1$2$3');

str = regexprep(str, '( *\\\\)$', '');

STRING = splice(STRING, startIndex(ithIndex), endIndex(ithIndex), str);

end

function STRING = splice(STRING, startIndex, endIndex, str)

STRING = [STRING(1 : startIndex - 1), str, STRING(endIndex + 1 : end)];

end

STRING = regexprep(STRING, '(?<!\\)\$.*?(?<!\\)\$', '\\\#');

STRING = regexprep(STRING, 'EQUATION[ ]+', 'EQUATION ');
STRING = regexprep(STRING, ' \\\\\n(\\end\{align\}|\\intertext\{)', '\n$1');

fid = fopen(regexprep(filename, '\.', '_Mathless\.'), 'wt');

fwrite(fid, STRING);

fclose(fid);

toc
end