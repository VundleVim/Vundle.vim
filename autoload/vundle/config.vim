func! vundle#config#bundle(arg, ...)
  let bundle = extend(s:parse_options(a:000), s:parse_name(a:arg))
  call extend(bundle, copy(s:bundle))
  call add(g:bundles, bundle)
  call s:rtp_add(bundle.rtpath())
  call s:require(bundle)
endf

func! vundle#config#init()
  call filter(g:bundles, 's:rtp_rm(v:val.rtpath())')
  let g:bundles = []
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
  if arg =~ '^\s*\(git@\|git://\)\S\+' || arg =~ 'https\?://' || arg =~ '\.git\*$'
    let uri = arg
    let name = substitute(split(uri,'\/')[-1], '\.git\s*$','','i')
  else
    let name = arg
    let uri  = 'http://github.com/vim-scripts/'.name.'.git'
  endif
  return {'name': name, 'uri': uri }
endf

func! s:require(bundle)
  call s:rtp_add(g:bundle_dir)
  " TODO: it has to be relative rtpath, not bundle, name
  exec 'runtime! '.a:bundle.name.'/plugin/*.vim'
  exec 'runtime! '.a:bundle.name.'/after/*.vim'
  call s:rtp_rm(g:bundle_dir)
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
