func! vundle#config#bundle(bang, arg, ...) abort
  let bundle = vundle#config#init_bundle(a:bang, a:arg, a:000)
  call s:rtp_rm_a()
  call add(g:vundle#bundles, bundle)
  call s:rtp_add_a()
endf

func! vundle#config#init()
  if !exists('g:vundle#bundles') | let g:vundle#bundles = [] | endif
  call s:rtp_rm_a()
  let g:vundle#bundles = []
endf

func! vundle#config#require(bundles) abort
  for b in a:bundles
    call s:rtp_add(b.rtpath())
    call s:rtp_add(g:vundle#bundle_dir)
    " TODO: it has to be relative rtpath, not bundle.name
    exec 'runtime! '.b.name.'/plugin/*.vim'
    exec 'runtime! '.b.name.'/after/*.vim'
    call s:rtp_rm(g:vundle#bundle_dir)
  endfor
endf

func! vundle#config#init_bundle(bang, name, opts)
  let opts = extend(s:parse_options(a:bang, a:opts), s:parse_name(substitute(a:name,"['".'"]\+','','g')))
  return extend(opts, copy(s:bundle))
endf

func! s:parse_options(bang, opts)
  if len(a:opts) != 1 
    let opts = {}
  elseif type(a:opts[0]) == type({})
    let opts = a:opts[0]
  elseif type(a:opts[0]) == type('')
    let opts = {'rev': a:opts[0]}
  endif

  if a:bang
    let opts = extend({'sync':'no'}, opts)
  endif

  return opts
endf

func! s:parse_name(arg)
  let arg = a:arg
  if    arg =~? '^\s*\(gh\|github\):\S\+'
  \  || arg =~? '^\w[a-z0-9-]\+/[^/]\+$'
    let uri = 'https://github.com/'.split(arg, ':')[-1]
    let name = substitute(split(uri,'\/')[-1], '\.git\s*$','','i')
  elseif arg =~? '^\s*\(git@\|git://\)\S\+' 
  \   || arg =~? '(file|https\?)://'
  \   || arg =~? '\.git\s*$'
    let uri = arg
    let name = split( substitute(uri,'/\?\.git\s*$','','i') ,'\/')[-1]
  else
    let name = arg
    let uri  = 'https://github.com/vim-scripts/'.name.'.git'
  endif
  return {'name': name, 'uri': uri }
endf

func! s:rtp_rm_a()
  call filter(copy(g:vundle#bundles), 's:rtp_rm(v:val.rtpath())')
endf

func! s:rtp_add_a()
  call filter(reverse(copy(g:vundle#bundles)), 's:rtp_add(v:val.rtpath())')
endf

func! s:rtp_rm(dir) abort
  exec 'set rtp-='.fnameescape(expand(a:dir))
  exec 'set rtp-='.fnameescape(expand(a:dir.'/after'))
endf

func! s:rtp_add(dir) abort
  exec 'set rtp^='.fnameescape(expand(a:dir))
  exec 'set rtp+='.fnameescape(expand(a:dir.'/after'))
endf

let s:bundle = {}

func! s:bundle.nosync() 
  return has_key(self, 'sync') && 'no' == self.sync
endf

func! s:bundle.installed()
  return !empty(split(globpath(self.path(), '*'), "\n"))
endf

func! s:bundle.path()
  if self.nosync()
    if isdirectory(expand(self.uri))
      let path = expand(self.uri)
    endif
  else
    let path = g:vundle#bundle_dir
  endif
  return join([path, self.name], '/')
endf

func! s:bundle.rtpath()
  return has_key(self, 'rtp') ? join([self.path(), self.rtp], '/') : self.path()
endf
