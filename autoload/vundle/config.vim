func! vundle#config#bundle(arg, ...)
  let bundle = vundle#config#init_bundle(a:arg, a:000)
  call s:rtp_rm_a()
  call add(g:bundles, bundle)
  call s:rtp_add_a()
  return bundle
endf

func! vundle#config#init()
  if !exists('g:bundles') | let g:bundles = [] | endif
  call s:rtp_rm_a()
  let g:bundles = []
endf

func! vundle#config#require(bundles) abort
  for b in a:bundles
    call s:rtp_add(b.rtpath)
    call s:rtp_add(g:bundle_dir)
    " TODO: it has to be relative rtpath, not bundle.name
    exec 'runtime! '.b.name.'/plugin/*.vim'
    exec 'runtime! '.b.name.'/after/*.vim'
    call s:rtp_rm(g:bundle_dir)
  endfor
endf

func! vundle#config#init_bundle(name, opts)
  let opts = extend(s:parse_options(split( substitute( join(a:opts),"['".'"]\+','','g') )), s:parse_name(substitute(a:name,"['".'"]\+','','g')))
  let b = extend(opts, copy(s:bundle))
  let b.rtpath = s:rtpath(opts)
  return b
endf

func! s:parse_options(opts)
  " TODO: improve this
  let parsed_opts = {}
  for opt in a:opts
    if type(opt) == type({})
      " already a dict
      call extend( parsed_opts, opt )
    elseif type(opt) == type("")
      " a string. detect delimiter
      if opt =~? '\S\+=\S\+'             " is it a '='
        let [key,val] = split( opt, '=' )
      elseif opt =~? '\S\+:\S\+'        " is it a ':'
        let [key,val] = split( opt, ':' )
      else
       let key = 'could_not_parse'
       let val = opt
      endif
      let parsed_opts[key] = val
    endif
  endfor
  return parsed_opts
endf

func! s:parse_name(arg)
  let arg = a:arg
  let git_proto = exists('g:vundle_default_git_proto') ? g:vundle_default_git_proto : 'https'

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
  return {'name': name, 'uri': uri, 'name_spec': arg }
endf

func! s:rtp_rm_a()
  let paths = map(copy(g:bundles), 'v:val.rtpath')
  let prepends = join(paths, ',')
  let appends = join(paths, '/after,').'/after'
  exec 'set rtp-='.fnameescape(prepends)
  exec 'set rtp-='.fnameescape(appends)
endf

func! s:rtp_add_a()
  let paths = map(copy(g:bundles), 'v:val.rtpath')
  let prepends = join(paths, ',')
  let appends = join(paths, '/after,').'/after'
  exec 'set rtp^='.fnameescape(prepends)
  exec 'set rtp+='.fnameescape(appends)
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

func! s:rtpath(opts)
  if has_key(a:opts, 'rtp')  " check if user set rtp
    return s:expand_path(a:opts.path().'/'.a:opts.rtp)
  elseif has_key(a:opts, 'rtpath')  " check if user set rtpath
    return s:expand_path(a:opts.path().'/'.a:opts.rtpath)
  else
    " default to the bundles path
    return has_key(a:opts, 'rtp') ? s:expand_path(a:opts.path().'/'.a:opts.rtp) : a:opts.path()
  endif
endf

let s:bundle = {}

func! s:bundle.path()
  return s:expand_path(g:bundle_dir.'/'.self.name)
endf

