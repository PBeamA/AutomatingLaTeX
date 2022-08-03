%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GetAttached.m
%
% Pakorn.Aschakulporn@otago.ac.nz
% https://pbeama.github.io/
% Modified: Tuesday 12 July 2022 (12:07)
% * Comments removed.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function GetAttached(varargin)

if nargin == 1
filename = varargin{1};
else
tic
filename = 'texFilename';
end

if ~contains(filename, '.tex')
filename = [filename, '.tex'];
end

fid = fopen(filename, 'rt');

STRING = fread(fid, '*char')';

fclose(fid);

STRING = regexprep(STRING, '\r', '');
STRING = regexprep(STRING, '(\n+[\s]*%[^\n]*)+', '');

EXT = {'.pdf', '.eps', '.png', '.jpg'};

EXT = EXT(1);

EXT = regexprep(EXT, '\.', '\\.');
FILESstring = '';
for i = 1 : length(EXT)
ext = EXT{i};

dFILES = regexprep(STRING, sprintf('[^"]*"([^"]+)"%s[^"]*', ext), sprintf('$1%s\n', ext));

if ~strcmp(STRING, dFILES)
FILESstring = [FILESstring, dFILES];
else
end

end

LOC = strfind([sprintf('\n'), FILESstring], sprintf('\n'));

nLOC = length(LOC);

FILES = cell(nLOC - 1, 1);
for i = 1 : nLOC - 1
FILES{i} = FILESstring(LOC(i) : LOC(i + 1) - 2);
end

nFILES = length(FILES);
FullFilename = cell(nFILES, 1);
for i = 1 : nFILES

[~, fNAME, fEXT] = fileparts(FILES{i});

Folder = regexprep(STRING, sprintf('.*{([a-zA-Z /]+)"%s"%s}.*', fNAME, fEXT), '$1');
FullFilename{i, 1} = [Folder, FILES{i}];
end
FullFilename(contains(FullFilename, '\documentclass')) = [];

FOLDERS = unique(regexprep(FullFilename, '/[^/]+\.[^\.]+', ''));

for i = 1 : length(FOLDERS)
if ~isfolder(['USED/' FOLDERS{i}])
mkdir(['USED/' FOLDERS{i}])
end
end
for i = 1 : nFILES
copyfile(FullFilename{i}, ['USED/', FullFilename{i}])

end

toc
end

