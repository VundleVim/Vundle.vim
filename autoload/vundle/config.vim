func! vundle#config#bundle(arg, ...)
  let bundle = vundle#config#init_bundle(a:arg, a:000)
  call add(g:bundles, bundle)
endf

func! vundle#config#bind(...)
  if a:0 == 0
    call s:rtp_rm(g:bundles)
    let bind_bundles = filter(copy(g:bundles), 'v:val.bind')
    call vundle#config#require(bind_bundles)
  else
    let matched_bundles = filter(copy(g:bundles),
          \ 's:is_tags_matched(v:val, '.string(a:000).')')
    call vundle#config#require(matched_bundles)
  end
endf

func! vundle#config#init()
  if exists('g:bundles')
    call s:rtp_rm(g:bundles)
  endif
  let g:bundles = []
endf

func! vundle#config#require(bundles) abort
  call s:rtp_add(a:bundles)
  " It's OK to do this since every plugin prevent itself be loaded twice
  runtime! plugin/*.vim
  runtime! after/*.vim
endf

func! vundle#config#init_bundle(name, opts)
  let opts = extend(s:parse_options(a:opts), s:parse_name(substitute(a:name,"['".'"]\+','','g')))
  let bundle = extend(copy(s:bundle), opts)

  let bundle.escaped_rtpath = fnameescape(expand(bundle.rtpath()))
  let bundle.escaped_rtpath_after = fnameescape(expand(bundle.rtpath().'/after'))
  return bundle
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

func! s:rtp_rm(bundles) abort
  for bundle in a:bundles
    exec 'set rtp-='.bundle.escaped_rtpath
    exec 'set rtp-='.bundle.escaped_rtpath_after
  endfor
endf

func! s:rtp_add(bundles) abort
  for bundle in reverse(copy(a:bundles))
    exec 'set rtp^='.bundle.escaped_rtpath
    exec 'set rtp+='.bundle.escaped_rtpath_after
  endfor
endf

func! s:is_tags_matched(bundle, tags)
  if !has_key(a:bundle, 'tags')
    return 0
  endif

  let is_matched = 0
  for tag in a:bundle.tags
     let is_matched = index(a:tags, tag) != -1

     if is_matched
       break
     endif
  endfor

  return is_matched
endf

func! s:expand_path(path) abort
  return simplify(expand(a:path))
endf

let s:bundle = {'bind': 1}

func! s:bundle.path()
  return s:expand_path(g:bundle_dir.'/'.self.name)
endf

func! s:bundle.rtpath()
  return has_key(self, 'rtp') ? s:expand_path(self.path().'/'.self.rtp) : self.path()
endf
