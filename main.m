function main(verbose)
if nargin < 1, verbose=false; end
% add the current folder and subfolders to the path for this session
FILEROOT = fileparts(mfilename('fullpath'));
addpath(genpath(FILEROOT));

% use the verbose flag to list all m-files of the repository
if verbose
  RECURSE_LIMIT = 500;
  mfiles = recurse_dir('\.m$', FILEROOT);
  fprintf(2,'\nM-Files found (excluding mlapptools):\n\n');
  for i = 1:length(mfiles)
    fprintf(2,'  %s\n', mfiles{i});
  end
end


function matches = recurse_dir(filter, root)
  %% recursive function to pull files matching filter spec (excluding
  persistent recurse_iter

  if isempty(recurse_iter)
    recurse_iter = 1;
  else
    recurse_iter = recurse_iter + 1;
  end
  if recurse_iter > RECURSE_LIMIT
    error('Recursion limit hit');
  end

  direc = dir(root);

  fileInds = ~cellfun( @isempty, regexpi({direc.name}, filter)');

  matches = { direc( fileInds ).name }';
  
  if ~strcmp(FILEROOT,root)
    if ~strcmp(FILEROOT(end),filesep())
      prependName = erase(root,[FILEROOT,filesep()]);
    else
      prependName = erase(root,FILEROOT);
    end
    matches = cellfun( ...
      @(n) ...
        fullfile(prependName,n), ...
      matches, ...
      'UniformOutput', 0);
  end
  
  subDirs = {direc([direc.isdir]).name};

  subDirs = subDirs(cellfun(@isempty, regexpi(subDirs, '^\.')))';
  subDirs = subDirs(cellfun(@isempty, regexpi(subDirs, 'mlapptools')))';
  
  subDirs = cellfun(@(s)fullfile(root,s),subDirs,'UniformOutput', 0);

  for sD = 1:length(subDirs)

    matches = [ ...
      matches ; ...
      recurse_dir(filter, subDirs{sD}) ...
      ]; %#okAGROW

  end

end %recurse_dir

end %main



