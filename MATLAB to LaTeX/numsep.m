%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% numsep.m
%
% Beam.Aschakulporn@otago.ac.nz
% https://pbeama.github.io/
% Modified: Thursday 3 February 2022 (09:24)
% * Comments removed.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function str = numsep(num, varargin)

if nargin == 2
nRounding = varargin{1};
end

s = [];
if ~ischar(num)
if isempty(s)
s = sign(num);
end
if round(num) - num == 0
str = num2str(num*s);
else
str = num2str(num*s, '%.50f');
end
else
str = num;

if strcmp(str(1), '-')
s = -1;
str(1) = [];
end
end
j = strfind(str, '.');

if ~contains(str, 'E', 'IgnoreCase', true)
if isempty(j)
str = fliplr(str);
i = 0;
while i < length(str)
i = i + 3;
if i < length(str)
i = i + 1;
str = [str(1 : i - 1), ',', str(i : end)];
end
end
str = fliplr(str);
else
if nargin == 2
DEC = round(str2double(str(j + 1 : j + nRounding + 1))/10);
str = [str(1 : j), num2str(DEC)];
end

str = [numsep(str2double(str(1 : j - 1))), str(j : end)];
end
end
str = strE(str);

if s == -1
str = ['-', str];
end

str = regexprep(str, ',', '{,}');
str = regexprep(str, '{{,}}', '{,}');

if nargin == 2
if contains(str, '.')
Zeros2Add = nRounding - length(regexprep(str, '.*\.([\d]+).*', '$1'));
str = regexprep(str, '(\.[\d]+)', sprintf('$1%s', '0'*ones(1, Zeros2Add)));
else
if ~contains(str, '\\\\')
str = sprintf('%s.%s', str, '0'*ones(1, nRounding));
end
end
end
end

function str = strE(str)
if contains(str, 'E', 'IgnoreCase', true)
str = regexprep(str, '[Ee]', ' \\\\times 10^{');
str = [str, '}'];
end
end

