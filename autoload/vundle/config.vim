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
  if a:name != substitute(a:name, '^\s*\(.\{-}\)\s*$', '\1', '')
    echo "Spurious leading and/or trailing whitespace found in bundle spec '" . a:name . "'"
  endif
  let opts = extend(s:parse_options(a:opts), s:parse_name(substitute(a:name,"['".'"]\+','','g')))
  let b = extend(opts, copy(s:bundle))
  let b.rtpath = s:rtpath(opts)
  return b
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

" this abstracts the operation:
"  'set runtimepath-=LIST'
"
" notes:
"  * it takes care of trailing '/' characters on each of the entries in LIST
"     (it attempts to remove the entry with and without the trailing '/', just
"     in case);
"  * it attempts to do the "real thing", if it can
"     (if 'fnameescape()' is available);
"   * otherwise, it has a number of fallback scenarios, ordered by
"      reliability;
"
" args:
"  dirs [string]: described as 'LIST' above;
"
" for now, it does not produce an explicit return value
"
func! s:compat_rtp_rm_entry(dirs)
  " debug: echomsg '[debug] s:compat_rtp_rm_entry(): entered. rtp: ' . string(&rtp) . '; dirs: ' . string(a:dirs)
  " optimisation: there seems to be a few of these cases
  if empty(a:dirs)
    return 0
  endif
  if exists('*fnameescape')
    exec 'set rtp-='.fnameescape(a:dirs)
  elseif exists('*filter') && exists('*split') && exists('*join') " && ( stridx(a:dir, ',') < 0 )
    " a bit costly, but more compatible
    let l:runtimepath_list = split(&rtp, ',', 1)

    unlet! g:vundle_config_compat_rtp_rm_entry_dir
    for l:dir_now in split(a:dirs, ',', 1)
      " FIXME: normalise path (think of win32 and other platforms)
      "  (fnamemodify()?)
      " get rid of the last slash, if it's not a root directory
      if ( strlen(l:dir_now) > 1 ) && ( l:dir_now[ -1: ] == '/' ) && ( l:dir_now[ -2:-2 ] != ':' )
        let l:dir_now = l:dir_now [ :-2 ]
      endif
      " remove the directory as is (without a trailing '/'),
      "  and with a trailing '/', too.
      for l:dir_suff in [ '', '/' ]
        if ( empty(l:dir_now) && ( ! empty(l:dir_suff) ) )
          continue
        endif
        let g:vundle_config_compat_rtp_rm_entry_dir = l:dir_now . l:dir_suff
        let l:runtimepath_list = filter(l:runtimepath_list, 'v:val != g:vundle_config_compat_rtp_rm_entry_dir')
      endfor
    endfor
    unlet! g:vundle_config_compat_rtp_rm_entry_dir
    " assemble the runtime variable from the list
    let &rtp = join(l:runtimepath_list, ',')
  elseif exists('*escape')
    " from fnameescape() documentation:
    "  it escapes: " \t\n*?[{`$\\%#'\"|!<"
    "  plus, depending on 'isfname', other characters.
    "  (TODO: add those cases, if needed)
    exec 'set rtp-='.escape(a:dirs, " \t\n*?[{`$\\%#'\"|!<")
  else
    " cheap and cheerful (but no escaping)
    exec 'set rtp-='.a:dirs
  endif
  " debug: echomsg '[debug] s:compat_rtp_rm_entry(): exiting. rtp: ' . string(&rtp)
endf

" abstracts the following operations:
"  'set runtimepath^=LIST'
"  'set runtimepath+=LIST'
"  'set runtimepath=LIST'
"
" args:
"  dirs [string]: described as 'LIST' above;
"  addset_operator [string]: one of:
"   '^': prepend ('set runtimepath^=');
"   '+': append ('set runtimepath+=');
"   '':  set ('set runtimepath=');
"
" for now, it does not produce an explicit return value
"
func! s:compat_rtp_addset_entry(dirs, addset_operator)
  " debug: echomsg '[debug] s:compat_rtp_addset_entry(): entered. rtp: ' . string(&rtp) . '; dirs: ' . string(a:dirs) . '; operator: ' . string( a:addset_operator )
  if exists('*fnameescape')
    exec 'set rtp'.a:addset_operator.'='.fnameescape(a:dirs)
  else
    " almost as quick, but more compatible
    if a:addset_operator == ''
      let &rtp = a:dirs
    else
      let l:elem_separator = ( empty(&rtp) ? '' : ',' )
      " note: ideally, we would want to
      "  do nothing if the value already exists
      "  (this is what the standard 'set {op}=' expressions do)
      "  but, for efficiency, we will let those elements
      "  through (besides, s:compat_rtp_rm_entry() would get rid of all
      "  matches if we want to do that before or after this operation)
      if a:addset_operator == '^'
        let &rtp = a:dirs . l:elem_separator . &rtp
      elseif a:addset_operator == '+'
        let &rtp = &rtp . l:elem_separator . a:dirs
      else
        " FIXME: internal error
      endif
    endif
  endif
  " debug: echomsg '[debug] s:compat_rtp_addset_entry(): exiting. rtp: ' . string(&rtp)
endf

func! s:rtp_rm_a()
  let paths = map(copy(g:bundles), 'v:val.rtpath')
  if !empty(paths)
    let prepends = join(paths, ',')
    let appends = join(paths, '/after,').'/after'
    call s:compat_rtp_rm_entry(prepends)
    call s:compat_rtp_rm_entry(appends)
  endif
endf

func! s:rtp_add_a()
  let paths = map(copy(g:bundles), 'v:val.rtpath')
  if !empty(paths)
    let prepends = join(paths, ',')
    let appends = join(paths, '/after,').'/after'
    call s:compat_rtp_addset_entry(prepends,'^')
    call s:compat_rtp_addset_entry(appends,'+')
  endif
endf

func! s:rtp_rm(dir) abort
  if !empty(a:dir)
    call s:compat_rtp_rm_entry(expand(a:dir, 1))
    call s:compat_rtp_rm_entry(expand(a:dir.'/after', 1))
  endif
endf

func! s:rtp_add(dir) abort
  if !empty(a:dir)
    call s:compat_rtp_addset_entry(expand(a:dir, 1), '^')
    call s:compat_rtp_addset_entry(expand(a:dir.'/after', 1), '+')
  endif
endf

func! s:expand_path(path) abort
  return simplify(expand(a:path, 1))
endf

func! s:rtpath(opts)
  return has_key(a:opts, 'rtp') ? s:expand_path(a:opts.path().'/'.a:opts.rtp) : a:opts.path()
endf

let s:bundle = {}

func! s:bundle.path()
  return s:expand_path(g:bundle_dir.'/'.self.name)
endf

