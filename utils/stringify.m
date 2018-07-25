function varargout = stringify(scriptFiles,prepForSprintf)
%% STRINGIFY  Prepares script files for use in MATLAB uifigure tweaks
%   Usage:
%     Strings = stringify('filename.css', true);
%   Arguments:
%     scriptFiles: str|cellstr, file names of script files or 'select'
%     prepForSprintf: bool[true], will replace special characters so that
%      sprintf can be used aferward
%   Output:
%     1st arg: cell array of stringified scripts
%     2nd arg: [optional] cell array of error messages
%
%   STRINGIFY can be called without inputs and user will be prompted to
%   select the desired script files.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Khris Griffis 2018

%%
if nargin < 2, prepForSprintf = true; end
if nargin < 1
  scriptFiles = 'select';
end
% Validate files list
if ~iscell(scriptFiles)
  % allow call to empty args
  if strcmpi(scriptFiles, 'select')
    [scriptFiles,root] = uigetfile(...
      fullfile(pwd,'*.*'), ...
      'Select Script Files', ...
      'MultiSelect', 'on');
    if ~iscell(scriptFiles) && ~scriptFiles
      error('No files selected.')
    end
    scriptFiles = fullfile(root,scriptFiles);
  else
    % if a single file was supplied, make it callstr
    scriptFiles = {scriptFiles}; 
  end
end

% initialize text holders
nFiles = length(scriptFiles);
erMsg = cell(nFiles,1);
stringified = cell(nFiles,1);

for fi = 1:nFiles
  fn = scriptFiles{fi};
  fid = fopen(fn, 'r');
  if fid < 0
    erMsg{fi} = sprintf('Unable to create connection to: "%s".', fn);
    fprintf(2, '%s\n', erMsg{fi});
    continue
  end
  stringified{fi} = fread(fid, [1, inf], '*char');
  fclose(fid);
  if prepForSprintf
    stringified{fi} = regexprep(stringified{fi}, '(\\|\%)', '$0$0');
  end
end

% assign outputs

varargout{1} = stringified(~cellfun(@isempty, stringified, 'unif',1));
if nargout > 1
  varargout{2} = erMsg;
end

end