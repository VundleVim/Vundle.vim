func! vundle#scripts#all(bang, ...)
  let b:match = ''
  let info = ['"Keymap: i - Install bundle; c - Cleanup; s - Search; R - Reload list']
  let matches = s:load_scripts(a:bang)
  if !empty(a:1)
    let matches = filter(matches, 'v:val =~? "'.escape(a:1,'"').'"')
    let info += ['"Search results for: '.a:1]
    " TODO: highlight matches
    let b:match = a:1
  endif
  call vundle#scripts#view('search',info, vundle#scripts#bundle_names(reverse(matches)))
  redraw
  echo len(matches).' bundles found'
endf

func! vundle#scripts#reload() abort
  silent exec ':BundleSearch! '.(exists('b:match') ? b:match : '')
  redraw
endf

func! vundle#scripts#complete(a,c,d)
  return join(s:load_scripts(0),"\n")
endf

func! s:view_log()
  if !exists('g:vundle_log_file')
    let g:vundle_log_file = tempname()
  endif

  call writefile(g:vundle_log, g:vundle_log_file)
  execute 'silent pedit ' . g:vundle_log_file

  wincmd P | wincmd H
endf

func! s:create_changelog() abort
  for bundle_data in g:updated_bundles
    let initial_sha = bundle_data[0]
    let updated_sha = bundle_data[1]
    let bundle      = bundle_data[2]

    let cmd = 'cd '.vundle#installer#shellesc(bundle.path()).
          \              ' && git log --pretty=format:"%s   %an, %ar" --graph '.
          \               initial_sha.'..'.updated_sha

    let cmd = g:shellesc_cd(cmd)

    let updates = system(cmd)

    call add(g:vundle_changelog, '')
    call add(g:vundle_changelog, 'Updated Bundle: '.bundle.name)

    if bundle.uri =~ "https://github.com"
      call add(g:vundle_changelog, 'Compare at: '.bundle.uri[0:-5].'/compare/'.initial_sha.'...'.updated_sha)
    endif

    for update in split(updates, '\n')
      let update = substitute(update, '\s\+$', '', '')
      call add(g:vundle_changelog, '  '.update)
    endfor
  endfor
endf

func! s:view_changelog()
  call s:create_changelog()

  if !exists('g:vundle_changelog_file')
    let g:vundle_changelog_file = tempname()
  endif

  call writefile(g:vundle_changelog, g:vundle_changelog_file)
  execute 'silent pedit ' . g:vundle_changelog_file

  wincmd P | wincmd H
endf

func! vundle#scripts#bundle_names(names)
  return map(copy(a:names), ' printf("Bundle ' ."'%s'".'", v:val) ')
endf

func! vundle#scripts#view(title, headers, results)
  if exists('g:vundle_view') && bufloaded(g:vundle_view)
    exec g:vundle_view.'bd!'
  endif

  exec 'silent pedit [Vundle] '.a:title

  wincmd P | wincmd H

  let g:vundle_view = bufnr('%')
  "
  " make buffer modifiable 
  " to append without errors
  set modifiable

  call append(0, a:headers + a:results)

  setl buftype=nofile
  setl noswapfile

  setl cursorline
  setl nonu ro noma ignorecase 
  if (exists('&relativenumber')) | setl norelativenumber | endif

  setl ft=vundle
  setl syntax=vim
  syn keyword vimCommand Bundle
  syn keyword vimCommand Helptags

  com! -buffer -bang -nargs=1 DeleteBundle
    \ call vundle#installer#run('vundle#installer#delete', split(<q-args>,',')[0], ['!' == '<bang>', <args>])

  com! -buffer -bang -nargs=? InstallAndRequireBundle   
    \ call vundle#installer#run('vundle#installer#install_and_require', split(<q-args>,',')[0], ['!' == '<bang>', <q-args>])

  com! -buffer -bang -nargs=? InstallBundle
    \ call vundle#installer#run('vundle#installer#install', split(<q-args>,',')[0], ['!' == '<bang>', <q-args>])

  com! -buffer -bang -nargs=0 InstallHelptags 
    \ call vundle#installer#run('vundle#installer#docs', 'helptags', [])

  com! -buffer -nargs=0 VundleLog call s:view_log()

  com! -buffer -nargs=0 VundleChangelog call s:view_changelog()

  nnoremap <buffer> q :silent bd!<CR>
  nnoremap <buffer> D :exec 'Delete'.getline('.')<CR>

  nnoremap <buffer> add  :exec 'Install'.getline('.')<CR>
  nnoremap <buffer> add! :exec 'Install'.substitute(getline('.'), '^Bundle ', 'Bundle! ', '')<CR>

  nnoremap <buffer> i :exec 'InstallAndRequire'.getline('.')<CR>
  nnoremap <buffer> I :exec 'InstallAndRequire'.substitute(getline('.'), '^Bundle ', 'Bundle! ', '')<CR>

  nnoremap <buffer> l :VundleLog<CR>
  nnoremap <buffer> u :VundleChangelog<CR>
  nnoremap <buffer> h :h vundle<CR>
  nnoremap <buffer> ? :norm h<CR>

  nnoremap <buffer> c :BundleClean<CR>
  nnoremap <buffer> C :BundleClean!<CR>

  nnoremap <buffer> s :BundleSearch 
  nnoremap <buffer> R :call vundle#scripts#reload()<CR>

  " goto first line after headers
  exec ':'.(len(a:headers) + 1)
endf

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

func! s:load_scripts(bang)
  let f = expand(g:bundle_dir.'/.vundle/script-names.vim-scripts.org.json', 1)
  if a:bang || !filereadable(f)
    if 0 != s:fetch_scripts(f)
      return []
    end
  endif
  return eval(readfile(f, 'b')[0])
endf
