%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FillLaTeX.m
%
% Pakorn.Aschakulporn@otago.ac.nz
% https://pbeama.github.io/
% Modified: Wednesday 25 October 2023 (17:09)
% * Comments removed.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function FillLaTeX(varargin)

src = 'texFilename.tex';
DataFilename = 'MATLAB\DATA.txt';
if nargin ~= 0
src = varargin{1};
if ~contains(src, '.tex')
src = [src, '.tex'];
end
if nargin == 2
DataFilename = varargin{2};
end
end

dst = regexprep(src, '.tex', 'Filled.tex');

if isfile(regexprep(src, '.tex', '.bib'))
copyfile(regexprep(src, '.tex', '.bib'), regexprep(src, '.tex', 'Filled.bib'))
end

fidsrc = fopen(src, 'rt');
STRING = fread(fidsrc, '*char')';

fclose(fidsrc);
fidData = fopen(DataFilename, 'rt');
while ~feof(fidData)
LINE = fgetl(fidData);

VariableName = regexprep(LINE, ' =.*', '');
VariableValue = regexprep(LINE, '.*= ', '');

STRING = regexprep(STRING, sprintf('\\\\Sexpr{%s}', VariableName), VariableValue);
end
fclose(fidData);
STRING
fiddst = fopen(dst, 'wt');
fprintf(fiddst, '%s', STRING)
fclose(fiddst);

command = sprintf('pdflatex %s', dst)
[status,cmdout] = system(command ,'-echo')

command = sprintf('biber %s', regexprep(dst, '.tex', '.bcf'))
[status,cmdout] = system(command ,'-echo')

command = sprintf('pdflatex %s', dst)
[status,cmdout] = system(command ,'-echo')
command = sprintf('pdflatex %s', dst)
[status,cmdout] = system(command ,'-echo')
end

