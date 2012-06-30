func! vundle#config#init()
  if !exists('g:bundles') | let g:bundles = {} | endif
  call s:rtp_rm_a()
  let g:bundles = {}
endf

func! vundle#config#bundle(arg, ...)
  let opts = extend(s:parse_options(a:000), s:parse_name_spec(a:arg))
  let bundle = vundle#config#init_bundle(opts.name,opts)
  call s:rtp_rm_a()
  let g:bundles[opts.name] = bundle
  call s:rtp_add_a()
  return bundle
endf

func! vundle#config#parse_name_spec(arg)
  return s:parse_name_spec(a:arg)
endf

func! vundle#config#require(bundles) abort
  if type(a:bundles) == type({})
    let bundles = values(a:bundles)
  else
    let bundles = a:bundles
  endif
  for b in bundles
    call s:rtp_add(b.rtpath())
    call s:rtp_add(g:bundle_dir)
    " TODO: it has to be relative rtpath, not bundle.name
    exec 'runtime! '.b.name.'/plugin/*.vim'
    exec 'runtime! '.b.name.'/after/*.vim'
    call s:rtp_rm(g:bundle_dir)
  endfor
endf

func! vundle#config#init_bundle(name, opts)
  let b = extend(a:opts, copy(s:bundle))
  let b.name = a:name
  "make sure keys for these options exist
  let b.name_spec = get(b, 'name_spec', a:name)
  let b.uri = get(b, 'uri', '')
  return b
endf

func! s:parse_options(opts)
  if len(a:opts) < 1 | return {} | endif

  if type(a:opts[0]) == type({})
    return a:opts[0]
  endif
  let opts = {'tree-ish': a:opts[0]}
  if len(a:opts) >= 2 && type(a:opts[1]) == type({})
    let opts = extend(a:opts[1], opts)
  endif
  return opts
endf

func! s:parse_name_spec(arg)
  let arg = substitute(a:arg,"['".'"]\+','','g')
  let git_proto = exists('g:vundle_default_git_proto') ? g:vundle_default_git_proto : 'https'

  let altname = ''
  let name_spec = arg
  if arg =~? ' as '
    let altname = split(arg, ' as ')[-1]
    let arg = split(arg, ' as ')[0]
  endif

  if    arg =~? '^\s*\(gh\|github\):\S\+'
  \  || arg =~? '^[a-z0-9][a-z0-9-]*/[^/]\+$'
    let uri = git_proto.'://github.com/'.split(arg, ':')[-1]
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
    let uri  = git_proto.'://github.com/vim-scripts/'.name.'.git'
  endif
  return {'name': empty(altname) ? name : altname, 'uri': uri, 'name_spec': name_spec }
endf

func! s:rtp_rm_a()
  call filter(values(g:bundles), 's:rtp_rm(v:val.rtpath())')
endf

func! s:rtp_add_a()
  call filter(reverse(values(g:bundles)), 's:rtp_add(v:val.rtpath())')
endf

func! s:rtp_rm(dir) abort
  exec 'set rtp-='.fnameescape(expand(a:dir, 1))
  exec 'set rtp-='.fnameescape(expand(a:dir.'/after', 1))
endf

func! s:rtp_add(dir) abort
  exec 'set rtp^='.fnameescape(expand(a:dir, 1))
  exec 'set rtp+='.fnameescape(expand(a:dir.'/after', 1))
endf

func! s:expand_path(path) abort
  return simplify(expand(a:path, 1))
endf

let s:bundle = {}

func! s:bundle.path()
  return s:expand_path(g:bundle_dir.'/'.self.name)
endf

func! s:bundle.rtpath()
  return has_key(self, 'rtp') ? s:expand_path(self.path().'/'.self.rtp) : self.path()
endf
