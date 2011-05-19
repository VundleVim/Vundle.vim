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

func! vundle#config#configure(bundle) abort
  return s:source(a:bundle.rtpath().'/bundle/'.a:bundle.name.'.vim')
endf

func! vundle#config#source(bundles) abort
  for b in a:bundles
    " TODO: should this be here?
    call s:rtp_add(b.rtpath())
    " load plugin
    call s:source(b.rtpath().'/plugin/**/*.vim')
    call s:source(b.rtpath().'/after/**/*.vim')
  endfor
endf

func! s:source(glob) abort
  for s in s:glob(a:glob)
    exec 'source '.s
  endfor
endf

func! s:glob(pattern)
  return split(glob(a:pattern),"\n")
endf

func! vundle#config#init_bundle(bang, name, opts)
  let opts = extend(s:parse_options(a:bang, a:opts), s:parse_name(substitute(a:name,"['".'"]\+','','g')),'keep')
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
  \  || arg =~? '^[a-z0-9][a-z0-9-]*/[^/]\+$'
    let uri = 'https://github.com/'.split(arg, ':')[-1]
    let name = substitute(split(uri,'\/')[-1], '\.git\s*$','','i')
  elseif arg =~? '^\s*\(git@\|git://\)\S\+' 
  \   || arg =~? '(file|https\?)://'
  \   || arg =~? '\.git\s*$'
  \   || isdirectory(expand(arg))
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
  " TODO: should lcd to tmpdir here
  " TODO: FIX this spagetti
  if self.nosync() && isdirectory(expand(self.uri))
    return expand(self.uri)
  endif

  return join([g:vundle#bundle_dir, self.name], '/')
endf

func! s:bundle.rtpath()
  return has_key(self, 'rtp') ? join([self.path(), self.rtp], '/') : self.path()
endf
