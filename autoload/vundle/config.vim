func! vundle#config#bundle(arg, ...)
  let bundle = extend(s:parse_options(a:000), s:parse_name(a:arg))
  call extend(bundle, copy(s:bundle))
  call s:rtp_rm_a()
  call add(g:bundles, bundle)
  call s:rtp_add_a()
  " TODO: fix this: explicit sourcing kills command-T
  " call vundle#config#require(bundle)
endf

func! vundle#config#init()
  if !exists('g:bundles') | let g:bundles = [] | endif
  let g:vundle_log = tempname()
  call s:rtp_rm_a()
  let g:bundles = []
endf

func! vundle#config#require(bundle)
  call s:rtp_add(g:bundle_dir)
  " TODO: it has to be relative rtpath, not bundle.name
  exec 'runtime! '.a:bundle.name.'/plugin/*.vim'
  exec 'runtime! '.a:bundle.name.'/after/*.vim'
  call s:rtp_rm(g:bundle_dir)
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
  if arg =~ '^\s*\(git@\|git://\)\S\+' || arg =~ 'https\?://' || arg =~ '\.git\s*$'
    let uri = arg
    let name = substitute(split(uri,'\/')[-1], '\.git\s*$','','i')
  else
    let name = arg
    let uri  = 'http://github.com/vim-scripts/'.name.'.git'
  endif
  return {'name': name, 'uri': uri }
endf

func! s:rtp_rm_a()
  for b in g:bundles | call s:rtp_rm(b.rtpath()) | endfor
endf

func! s:rtp_add_a()
  for b in reverse(copy(g:bundles)) | call s:rtp_add(b.rtpath()) | endfor
endf

func! s:rtp_rm(dir)
  exec 'set rtp-='.a:dir
  exec 'set rtp-='.expand(a:dir.'/after')
endf

func! s:rtp_add(dir)
  exec 'set rtp^='.a:dir
  exec 'set rtp+='.expand(a:dir.'/after')
endf

let s:bundle = {}

func! s:bundle.path()
  return join([g:bundle_dir, self.name], '/')
endf

func! s:bundle.rtpath()
  return has_key(self, 'rtp') ? join([self.path(), self.rtp], '/') : self.path()
endf
