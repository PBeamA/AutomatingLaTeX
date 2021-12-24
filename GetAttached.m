%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Beam.Aschakulporn@otago.ac.nz
% https://pbeama.github.io/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function GetAttached
close all
clear all
clc
tic

filename = 'texFilename.tex';

fid = fopen(filename, 'rt');

STRING = fread(fid, '*char')';

fclose(fid);


% STRING
%
% EXT = {'.pdf', '.csv', '.m', '.tex', '.eps', '.png', '.jpg'};
EXT = {'.pdf', '.eps', '.png', '.jpg'};

EXT = EXT(1);

EXT = regexprep(EXT, '\.', '\\.');
% STROMG
FILESstring = '';
for i = 1 : length(EXT)
    ext = EXT{i};
    
    
    dFILES = regexprep(STRING, sprintf('[^"]*"([^"]+)"%s[^"]*', ext), sprintf('$1%s\n', ext));
    % %     dFILES = regexprep(STRING, sprintf('[^"]*{([^"]+)"%s}[^"]*', ext), sprintf('$1\n'))
    %
    % regexprep(STRING, sprintf('[^"]*{([^"]+)"%s}[^"]*', ext), sprintf('$1\n'))
    
    %     asd
    if ~strcmp(STRING, dFILES)
        FILESstring = [FILESstring, dFILES];
    else
        %         ext
    end
    
end

LOC = strfind([sprintf('\n'), FILESstring], sprintf('\n'));

nLOC = length(LOC);

FILES = cell(nLOC - 1, 1);
for i = 1 : nLOC - 1
    FILES{i} = FILESstring(LOC(i) : LOC(i + 1) - 2);
end
% FILES

nFILES = length(FILES);
% nFILES = 1
% Folders = [];
FullFilename = cell(nFILES, 1);
for i = 1 : nFILES
    
    [~, fNAME, fEXT] = fileparts(FILES{i});
    %     regexprep(FILES{i}, '\.[^\.]+', '')
    
    
    % regexprep(STRING, sprintf('.*{([^\"\{]*)"%s"%s}.*', fNAME, fEXT), '$1')
    Folder = regexprep(STRING, sprintf('.*{([a-zA-Z /]+)"%s"%s}.*', fNAME, fEXT), '$1');
    FullFilename{i, 1} = [Folder, FILES{i}];
end


FOLDERS = unique(regexprep(FullFilename, '/[^/]+\.[^\.]+', ''));

for i = 1 : length(FOLDERS)
    if ~isfolder(['USED/' FOLDERS{i}])
        mkdir(['USED/' FOLDERS{i}])
    end
end
for i = 1 : nFILES
    %     ['USED/', FullFilename{i}]
    copyfile(FullFilename{i}, ['USED/', FullFilename{i}])
    
    
    
end


toc
end




















