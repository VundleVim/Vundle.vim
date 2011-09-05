func! vundle#config#vundle(arg, ...)
  let vundle = vundle#config#init_vundle(a:arg, a:000)
  call s:rtp_rm_a()
  call add(g:vundles, vundle)
  call s:rtp_add_a()
endf

func! vundle#config#init()
  if !exists('g:vundles') | let g:vundles = [] | endif
  call s:rtp_rm_a()
  let g:vundles = []
  if !exists('g:Vundle_no_full_repo')
    let g:Vundle_no_full_repo=0
  endif
endf

func! vundle#config#require(vundles) abort
  for b in a:vundles
    call s:rtp_add(b.rtpath())
    call s:rtp_add(g:vundle_dir)
    " TODO: it has to be relative rtpath, not vundle.name
    exec 'runtime! '.b.name.'/plugin/*.vim'
    exec 'runtime! '.b.name.'/after/*.vim'
    call s:rtp_rm(g:vundle_dir)
  endfor
endf

func! vundle#config#init_vundle(name, opts)
  let opts = extend(s:parse_options(a:opts), s:parse_name(substitute(a:name,"['".'"]\+','','g')))
  return extend(opts, copy(s:vundle))
endf

func! s:parse_options(opts)
  " TODO: improve this
  if len(a:opts) != 1 | return {} | endif

  if type(a:opts[0]) == type({})
    return a:opts[0]
  else
    return {'rev': a:opts[0]}
  endif
endf

func! s:parse_name(arg)
  let arg = a:arg

  if    arg =~? '^\s*\(gh\|github\):\S\+'
  \  || arg =~? '^[a-z0-9][a-z0-9-]*/[^/]\+$'
    let uri = 'https://github.com/'.split(arg, ':')[-1]
    if uri !~? '\.git$'
      let uri .= '.git'
    endif
    let name = substitute(split(uri,'\/')[-1], '\.git\s*$','','i')
  elseif arg =~? '^\s*\(git@\|git://\)\S\+'
  \   || arg =~? '\(file\|https\?\)://'
  \   || arg =~? '\.git\s*$'
    let uri = arg
    let name = split( substitute(uri,'/\?\.git\s*$','','i') ,'\/')[-1]
  else
    let name = arg
    let uri  = 'https://github.com/vim-scripts/'.name.'.git'
  endif
  return {'name': name, 'uri': uri, 'name_spec': arg }
endf

func! s:rtp_rm_a()
  call filter(copy(g:vundles), 's:rtp_rm(v:val.rtpath())')
endf

func! s:rtp_add_a()
  call filter(reverse(copy(g:vundles)), 's:rtp_add(v:val.rtpath())')
endf

func! s:rtp_rm(dir) abort
  exec 'set rtp-='.fnameescape(expand(a:dir))
  exec 'set rtp-='.fnameescape(expand(a:dir.'/after'))
endf

func! s:rtp_add(dir) abort
  exec 'set rtp^='.fnameescape(expand(a:dir))
  exec 'set rtp+='.fnameescape(expand(a:dir.'/after'))
endf

func! s:expand_path(path) abort
  return simplify(expand(a:path))
endf

let s:vundle = {}

func! s:vundle.path()
  return s:expand_path(g:vundle_dir.'/'.self.name)
endf

func! s:vundle.rtpath()
  return has_key(self, 'rtp') ? s:expand_path(self.path().'/'.self.rtp) : self.path()
endf
