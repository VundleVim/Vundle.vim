" This function is called by :PluginInstall.  It will try to clone all new
" bundles given (or all bundles in g:bundles by default) to g:bundle_dir.  If
" a:bang is 1 it will also update all plugins (git pull).
"
" bang   -- 1 or 0
" ...    -- any number of bundle specifications (seperate arguments)
" return -- 0 (unconditionally)
func! vundle#installer#new(bang, ...) abort
  let bundles = (a:1 == '') ?
        \ g:bundles :
        \ map(copy(a:000), 'vundle#config#bundle(v:val, {})')

  let names = vundle#scripts#bundle_names(map(copy(bundles), 'v:val.name_spec'))
  call vundle#scripts#view('Installer',['" Installing plugins to '.expand(g:bundle_dir, 1)], names +  ['Helptags'])

  " FIXME this tries to call 'add' as a normal mode command.  This is a buffer
  " local mapping defined in vundle#scripts#view().  The mapping will call a
  " buffer local command InstallPlugin which in turn will call
  " vundle#installer#run() with vundle#installer#install().  This is very
  " confusing and unclear.
  call s:process(a:bang, (a:bang ? 'add!' : 'add'))

  call vundle#config#require(bundles)
endf

" A function to iterate over all lines in a Vundle window and execute the
" given command for every line.  It is used by the installation and cleaning
" functions.
"
" bang   -- not used (FIXME)
" cmd    -- the (normal mode) command to execute for every line as a string
" return -- 0 (unconditionally)
func! s:process(bang, cmd)
  let msg = ''

  redraw
  sleep 1m

  let lines = (getline('.','$')[0:-2])

  for line in lines
    redraw

    exec ':norm '.a:cmd

    if 'error' == g:vundle_last_status
      let msg = 'With errors; press l to view log'
    endif

    if 'updated' == g:vundle_last_status && empty(msg)
      let msg = 'Plugins updated; press u to view changelog'
    endif

    " goto next one
    exec ':+1'

    setl nomodified
  endfor

  redraw
  echo 'Done! '.msg
endf

" Wrapper function to call another function in the different Vundle windows.
"
" func_name -- the function to call
" name      -- the bundle name to call func_name for (string)
" ...       -- the argument to be used when calling func_name (only the first
"              optional argument will be used)
" return    -- the status returned by the call to func_name
func! vundle#installer#run(func_name, name, ...) abort
  let n = a:name

  echo 'Processing '.n
  call s:sign('active')

  sleep 1m

  let status = call(a:func_name, a:1)

  call s:sign(status)

  redraw

  if 'new' == status
    echo n.' installed'
  elseif 'updated' == status
    echo n.' updated'
  elseif 'todate' == status
    echo n.' already installed'
  elseif 'deleted' == status
    echo n.' deleted'
  elseif 'helptags' == status
    echo n.' regenerated'
  elseif 'error' == status
    echohl Error
    echo 'Error processing '.n
    echohl None
    sleep 1
  else
    throw 'whoops, unknown status:'.status
  endif

  let g:vundle_last_status = status

  return status
endf

" Put a sign on the current line, indicating the status of the installation
" step.
"
" status -- string describing the status
" return -- 0 (unconditionally)
func! s:sign(status)
  if (!has('signs'))
    return
  endif

  exe ":sign place ".line('.')." line=".line('.')." name=Vu_". a:status ." buffer=" . bufnr("%")
endf

" Install a plugin, then add it to the runtimepath and source it.
"
" bang   -- 1 or 0, passed directly to vundle#installer#install()
" name   -- the name of a bundle (string)
" return -- the return value from vundle#installer#install()
func! vundle#installer#install_and_require(bang, name) abort
  let result = vundle#installer#install(a:bang, a:name)
  let b = vundle#config#bundle(a:name, {})
  call vundle#installer#helptags([b])
  call vundle#config#require([b])
  return result
endf

" Install or update a bundle given by its name.
"
" bang   -- 1 or 0, passed directly to s:sync()
" name   -- the name of a bundle (string)
" return -- the return value from s:sync()
func! vundle#installer#install(bang, name) abort
  if !isdirectory(g:bundle_dir) | call mkdir(g:bundle_dir, 'p') | endif

  let n = substitute(a:name,"['".'"]\+','','g')
  let matched = filter(copy(g:bundles), 'v:val.name_spec == n')

  if len(matched) > 0
    let b = matched[0]
  else
    let b = vundle#config#init_bundle(a:name, {})
  endif

  return s:sync(a:bang, b)
endf

" Call :helptags for all bundles in g:bundles.
"
" return -- 'error' if an error occurred, else return 'helptags'
func! vundle#installer#docs() abort
  let error_count = vundle#installer#helptags(g:bundles)
  if error_count > 0
      return 'error'
  endif
  return 'helptags'
endf

" Call :helptags for a list of bundles.
"
" bundles -- a list of bundle dictionaries for which :helptags should be
"            called.
" return  -- the number of directories where :helptags failed
func! vundle#installer#helptags(bundles) abort
  let bundle_dirs = map(copy(a:bundles),'v:val.rtpath')
  let help_dirs = filter(bundle_dirs, 's:has_doc(v:val)')

  call s:log('')
  call s:log('Helptags:')

  let statuses = map(copy(help_dirs), 's:helptags(v:val)')
  let errors = filter(statuses, 'v:val == 0')

  call s:log('Helptags: '.len(help_dirs).' plugins processed')

  return len(errors)
endf

" List all installed plugins.
" Corresponding documentation: vundle-plugins-list
"
" bang   -- not used
" return -- 0 (unconditionally)
func! vundle#installer#list(bang) abort
  let bundles = vundle#scripts#bundle_names(map(copy(g:bundles), 'v:val.name_spec'))
  call vundle#scripts#view('list', ['" My Plugins'], bundles)
  redraw
  echo len(g:bundles).' plugins configured'
endf

" List and remove all directories in the bundle directory which are not
" activated (added to the bundle list).
"
" bang   -- 0 if the user should be asked to confirm every deletion, 1 if they
"           should be removed unconditionally
" return -- 0 (unconditionally)
func! vundle#installer#clean(bang) abort
  let bundle_dirs = map(copy(g:bundles), 'v:val.path()')
  let all_dirs = (v:version > 702 || (v:version == 702 && has("patch51")))
  \   ? split(globpath(g:bundle_dir, '*', 1), "\n")
  \   : split(globpath(g:bundle_dir, '*'), "\n")
  let x_dirs = filter(all_dirs, '0 > index(bundle_dirs, v:val)')

  if empty(x_dirs)
    let headers = ['" All clean!']
    let names = []
  else
    let headers = ['" Removing Plugins:']
    let names = vundle#scripts#bundle_names(map(copy(x_dirs), 'fnamemodify(v:val, ":t")'))
  end

  call vundle#scripts#view('clean', headers, names)
  redraw

  if (a:bang || empty(names))
    call s:process(a:bang, 'D')
  else
    call inputsave()
    let response = input('Continue? [Y/n]: ')
    call inputrestore()
    if (response =~? 'y' || response == '')
      call s:process(a:bang, 'D')
    endif
  endif
endf

" Delete to directory for a plugin.
"
" bang     -- not used
" dir_name -- the bundle directory to be deleted (as a string)
" return   -- 'error' if an error occurred, 'deleted' if the plugin folder was
"             successfully deleted
func! vundle#installer#delete(bang, dir_name) abort

  let cmd = ((has('win32') || has('win64')) && empty(matchstr(&shell, 'sh'))) ?
  \           'rmdir /S /Q' :
  \           'rm -rf'

  let bundle = vundle#config#init_bundle(a:dir_name, {})
  let cmd .= ' '.vundle#installer#shellesc(bundle.path())

  let out = s:system(cmd)

  call s:log('')
  call s:log('Plugin '.a:dir_name)
  call s:log('$ '.cmd)
  call s:log('> '.out)

  if 0 != v:shell_error
    return 'error'
  else
    return 'deleted'
  endif
endf

" Check if a bundled plugin has any documentation.
"
" rtp    -- a path (string) where the plugin is installed
" return -- 1 if some documentation was found, 0 otherwise
func! s:has_doc(rtp) abort
  return isdirectory(a:rtp.'/doc')
  \   && (!filereadable(a:rtp.'/doc/tags') || filewritable(a:rtp.'/doc/tags'))
  \   && (v:version > 702 || (v:version == 702 && has("patch51")))
  \     ? !(empty(glob(a:rtp.'/doc/*.txt', 1)) && empty(glob(a:rtp.'/doc/*.??x', 1)))
  \     : !(empty(glob(a:rtp.'/doc/*.txt')) && empty(glob(a:rtp.'/doc/*.??x')))
endf

" Update the helptags for a plugin.
"
" rtp    -- the path to the plugin's root directory (string)
" return -- 1 if :helptags succeeded, 0 otherwise
func! s:helptags(rtp) abort
  " it is important to keep trailing slash here
  let doc_path = resolve(a:rtp).'/doc/'
  call s:log(':helptags '.doc_path)
  try
    execute 'helptags ' . doc_path
  catch
    call s:log("> Error running :helptags ".doc_path)
    return 0
  endtry
  return 1
endf

" Install or update a given bundle object with git.
"
" bang   -- 0 if only new plugins should be installed, 1 if existing plugins
"           should be updated
" bundle -- a bundle object (dict)
" return -- 'todate' if nothing was updated or the repository was up to date,
"           'new' when the plugin was newly installed, 'updated' if some
"           changes where pulled via git, 'error' if an error occurred in the
"           shell command
func! s:sync(bang, bundle) abort
  let git_dir = expand(a:bundle.path().'/.git/', 1)
  if isdirectory(git_dir) || filereadable(expand(a:bundle.path().'/.git', 1))
    if !(a:bang) | return 'todate' | endif
    let cmd = 'cd '.vundle#installer#shellesc(a:bundle.path()).' && git pull && git submodule update --init --recursive'

    let cmd = g:shellesc_cd(cmd)

    let get_current_sha = 'cd '.vundle#installer#shellesc(a:bundle.path()).' && git rev-parse HEAD'
    let get_current_sha = g:shellesc_cd(get_current_sha)
    let initial_sha = s:system(get_current_sha)[0:15]
  else
    let cmd = 'git clone --recursive '.vundle#installer#shellesc(a:bundle.uri).' '.vundle#installer#shellesc(a:bundle.path())
    let initial_sha = ''
  endif

  let out = s:system(cmd)
  call s:log('')
  call s:log('Plugin '.a:bundle.name_spec)
  call s:log('$ '.cmd)
  call s:log('> '.out)

  if 0 != v:shell_error
    return 'error'
  end

  if empty(initial_sha)
    return 'new'
  endif

  let updated_sha = s:system(get_current_sha)[0:15]

  if initial_sha == updated_sha
    return 'todate'
  endif

  call add(g:updated_bundles, [initial_sha, updated_sha, a:bundle])
  return 'updated'
endf

" Escape special characters in a string to be able to use it as a shell
" command with system().
"
" cmd    -- the string holding the shell command
" return -- a string with the relevant characters escaped
func! vundle#installer#shellesc(cmd) abort
  if ((has('win32') || has('win64')) && empty(matchstr(&shell, 'sh')))
    return '"' . substitute(a:cmd, '"', '\\"', 'g') . '"'
  endif
  return shellescape(a:cmd)
endf

" Fix a cd shell command to be used on Windows.
"
" cmd    -- the command to be fixed (string)
" return -- the fixed command (string)
func! g:shellesc_cd(cmd) abort
  if ((has('win32') || has('win64')) && empty(matchstr(&shell, 'sh')))
    let cmd = substitute(a:cmd, '^cd ','cd /d ','')  " add /d switch to change drives
    return cmd
  else
    return a:cmd
  endif
endf

" Wrapper for system calls.  FIXME: Why is this needed?
"
" cmd    -- the command passed to system() (string)
" return -- the return value from system()
func! s:system(cmd) abort
  return system(a:cmd)
endf

" Add a log message to Vundle's internal logging variable.
"
" str    -- the log message (string)
" return -- a:str
func! s:log(str) abort
  let fmt = '%y%m%d %H:%M:%S'
  call add(g:vundle_log, '['.strftime(fmt).'] '.a:str)
  return a:str
endf
