%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FillLaTeX.m
%
% Beam.Aschakulporn@otago.ac.nz
% https://pbeama.github.io/
% Modified: Friday 24 December 2021 (19:01)
% * Comments removed.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function FillLaTeX
close all
clear all
clc

src = 'texFilename.tex'
dst = regexprep(src, '.tex', 'Filled.tex')
DataFilename = 'MATLAB\EssayIIDATA.txt'

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

