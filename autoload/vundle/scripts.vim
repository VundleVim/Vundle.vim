" ---------------------------------------------------------------------------
" Search the database from vim-script.org for a matching plugin.  If no
" argument is given, list all plugins. This function is used by the :Plugins
" and :PluginSearch commands.
"
" bang -- if 1 refresh the script name cache, if 0 don't
" ...  -- a plugin name to search for
" ---------------------------------------------------------------------------
func! vundle#scripts#all(bang, ...)
  let b:match = ''
  let info = ['"Keymap: i - Install plugin; c - Cleanup; s - Search; R - Reload list']
  let matches = s:load_scripts(a:bang)
  if !empty(a:1)
    let matches = filter(matches, 'v:val =~? "'.escape(a:1,'"').'"')
    let info += ['"Search results for: '.a:1]
    " TODO: highlight matches
    let b:match = a:1
  endif
  call vundle#scripts#view('search',info, vundle#scripts#bundle_names(reverse(matches)))
  redraw
  echo len(matches).' plugins found'
endf


" ---------------------------------------------------------------------------
" Repeat the search for bundles.
" ---------------------------------------------------------------------------
func! vundle#scripts#reload() abort
  silent exec ':PluginSearch! '.(exists('b:match') ? b:match : '')
  redraw
endf


" ---------------------------------------------------------------------------
" Complete names for bundles in the command line.
"
" a, c, d -- see :h command-completion-custom
" return  -- all valid plugin names from vim-scripts.org as completion
"            candidates, or all installed plugin names when running an 'Update
"            variant'. see also :h command-completion-custom
" ---------------------------------------------------------------------------
func! vundle#scripts#complete(a,c,d)
  if match(a:c, '\v^%(Plugin|Vundle)%(Install!|Update)') == 0
    " Only installed plugins if updating
    return join(map(copy(g:vundle#bundles), 'v:val.name'), "\n")
  else
    " Or all known plugins otherwise
    return join(s:load_scripts(0),"\n")
  endif
endf


" ---------------------------------------------------------------------------
" View the logfile after an update or installation.
" ---------------------------------------------------------------------------
func! s:view_log()
  if !exists('s:log_file')
    let s:log_file = tempname()
  endif

  if bufloaded(s:log_file)
    execute 'silent bdelete' s:log_file
  endif
  call writefile(g:vundle#log, s:log_file)
  execute 'silent pedit ' . s:log_file

  wincmd P | wincmd H
endf


" ---------------------------------------------------------------------------
" Parse the output from git log after an update to create a change log for the
" user.
" ---------------------------------------------------------------------------
func! s:create_changelog() abort
  let changelog = ['Updated Plugins:']
  for bundle_data in g:vundle#updated_bundles
    let initial_sha = bundle_data[0]
    let updated_sha = bundle_data[1]
    let bundle      = bundle_data[2]

    let cmd = 'cd '.vundle#installer#shellesc(bundle.path()).
          \              ' && git log --pretty=format:"%s   %an, %ar" --graph '.
          \               initial_sha.'..'.updated_sha

    let cmd = vundle#installer#shellesc_cd(cmd)

    let updates = system(cmd)

    call add(changelog, '')
    call add(changelog, 'Updated Plugin: '.bundle.name)

    if bundle.uri =~ "https://github.com"
      call add(changelog, 'Compare at: '.bundle.uri[0:-5].'/compare/'.initial_sha.'...'.updated_sha)
    endif

    for update in split(updates, '\n')
      let update = substitute(update, '\s\+$', '', '')
      call add(changelog, '  '.update)
    endfor
  endfor
  return changelog
endf


" ---------------------------------------------------------------------------
" View the change log after an update or installation.
" ---------------------------------------------------------------------------
func! s:view_changelog()
  if !exists('s:changelog_file')
    let s:changelog_file = tempname()
  endif

  if bufloaded(s:changelog_file)
    execute 'silent bdelete' s:changelog_file
  endif
  call writefile(s:create_changelog(), s:changelog_file)
  execute 'silent pedit' s:changelog_file

  wincmd P | wincmd H
endf


" ---------------------------------------------------------------------------
" Create a list of 'Plugin ...' lines from a list of bundle names.
"
" names  -- a list of names (strings) of plugins
" return -- a list of 'Plugin ...' lines suitable to be written to a buffer
" ---------------------------------------------------------------------------
func! vundle#scripts#bundle_names(names)
  return map(copy(a:names), ' printf("Plugin ' ."'%s'".'", v:val) ')
endf


" ---------------------------------------------------------------------------
" Open a buffer to display information to the user.  Several special commands
" are defined in the new buffer.
"
" title   -- a title for the new buffer
" headers -- a list of header lines to be displayed at the top of the buffer
" results -- the main information to be displayed in the buffer (list of
"            strings)
" ---------------------------------------------------------------------------
func! vundle#scripts#view(title, headers, results)
  if exists('s:view') && bufloaded(s:view)
    exec s:view.'bd!'
  endif

  exec 'silent pedit [Vundle] '.a:title

  wincmd P | wincmd H

  let s:view = bufnr('%')
  "
  " make buffer modifiable
  " to append without errors
  set modifiable

  call append(0, a:headers + a:results)

  setl buftype=nofile
  setl noswapfile

  setl cursorline
  setl nonu ro noma
  if (exists('&relativenumber')) | setl norelativenumber | endif

  setl ft=vundle
  setl syntax=vim
  syn keyword vimCommand Plugin
  syn keyword vimCommand Bundle
  syn keyword vimCommand Helptags

  com! -buffer -bang -nargs=1 DeletePlugin
    \ call vundle#installer#run('vundle#installer#delete', split(<q-args>,',')[0], ['!' == '<bang>', <args>])

  com! -buffer -bang -nargs=? InstallAndRequirePlugin
    \ call vundle#installer#run('vundle#installer#install_and_require', split(<q-args>,',')[0], ['!' == '<bang>', <q-args>])

  com! -buffer -bang -nargs=? InstallPlugin
    \ call vundle#installer#run('vundle#installer#install', split(<q-args>,',')[0], ['!' == '<bang>', <q-args>])

  com! -buffer -bang -nargs=0 InstallHelptags
    \ call vundle#installer#run('vundle#installer#docs', 'helptags', [])

  com! -buffer -nargs=0 VundleLog call s:view_log()

  com! -buffer -nargs=0 VundleChangelog call s:view_changelog()

  nnoremap <buffer> q :silent bd!<CR>
  nnoremap <buffer> D :exec 'Delete'.getline('.')<CR>

  nnoremap <buffer> add  :exec 'Install'.getline('.')<CR>
  nnoremap <buffer> add! :exec 'Install'.substitute(getline('.'), '^Plugin ', 'Plugin! ', '')<CR>

  nnoremap <buffer> i :exec 'InstallAndRequire'.getline('.')<CR>
  nnoremap <buffer> I :exec 'InstallAndRequire'.substitute(getline('.'), '^Plugin ', 'Plugin! ', '')<CR>

  nnoremap <buffer> l :VundleLog<CR>
  nnoremap <buffer> u :VundleChangelog<CR>
  nnoremap <buffer> h :h vundle<CR>
  nnoremap <buffer> ? :norm h<CR>

  nnoremap <buffer> c :PluginClean<CR>
  nnoremap <buffer> C :PluginClean!<CR>

  nnoremap <buffer> s :PluginSearch
  nnoremap <buffer> R :call vundle#scripts#reload()<CR>

  " goto first line after headers
  exec ':'.(len(a:headers) + 1)
endf


" ---------------------------------------------------------------------------
" Load the plugin database from vim-scripts.org .
"
" to     -- the filename (string) to save the database to
" return -- 0 on success, 1 if an error occurred
" ---------------------------------------------------------------------------
func! s:fetch_scripts(to)
  let scripts_dir = fnamemodify(expand(a:to, 1), ":h")
  if !isdirectory(scripts_dir)
    call mkdir(scripts_dir, "p")
  endif

  let l:vim_scripts_json = 'http://vim-scripts.org/api/scripts.json'
  if executable("curl")
    let cmd = 'curl --fail -s -o '.vundle#installer#shellesc(a:to).' '.l:vim_scripts_json
  elseif executable("wget")
    let temp = vundle#installer#shellesc(tempname())
    let cmd = 'wget -q -O '.temp.' '.l:vim_scripts_json. ' && mv -f '.temp.' '.vundle#installer#shellesc(a:to)
    if (has('win32') || has('win64'))
      let cmd = substitute(cmd, 'mv -f ', 'move /Y ', '') " change force flag
      let cmd = vundle#installer#shellesc(cmd)
    end
  else
    echoerr 'Error curl or wget is not available!'
    return 1
  endif

  call system(cmd)

  if (0 != v:shell_error)
    echoerr 'Error fetching scripts!'
    return v:shell_error
  endif
  return 0
endf


" ---------------------------------------------------------------------------
" Load the plugin database and return a list of all plugins.
"
" bang   -- if 1 download the redatabase, else only download if it is not
"           readable on disk (i.e. does not exist)
" return -- a list of strings, these are the names (valid bundle
"           specifications) of all plugins from vim-scripts.org
" ---------------------------------------------------------------------------
func! s:load_scripts(bang)
  let f = expand(g:vundle#bundle_dir.'/.vundle/script-names.vim-scripts.org.json', 1)
  if a:bang || !filereadable(f)
    if 0 != s:fetch_scripts(f)
      return []
    end
  endif
  return eval(readfile(f, 'b')[0])
endf

" vim: set expandtab sts=2 ts=2 sw=2 tw=78 norl:
